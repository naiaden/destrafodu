use Acme::Comment type => 'C++';
use Getopt::Std;
use List::Util qw[min max];
use strict;
use IPC::Open3;

require 'InfoExtractor.pl';
require 'LexiconActions.pl';
require 'PersistenceFactory.pl';
require 'TagConverter.pl';
require 'WeightingScheme.pl';


binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";

$|++;

use vars qw( $opt_m $opt_p );
getopts('m:p: ');

my @DLParticles;
my $maxSuffixLength = 35;
my %tlfWord = ();

if( $opt_m )
{
	%tlfWord = readMassLexicon($opt_m, \%tlfWord);
}

if( $opt_p )
{
	readParticle($opt_p);
}

#V(fin=fin,tense=past,num=sing,form=norm) wrden werd

my $pid = open3(\*CHLD_IN, \*CHLD_OUT, \*CHLD_ERR, 'timblclient -n anigrides -p 7000')
    or die "open3() failed $!";

my $serverResponse;

print CHLD_IN "base destrafodu\n";

while(<>)
{
	if($_ =~ m/^([^\(]+\(.*?\)) ([^\s]+) ([^\s]+)$/)
	{
		my $lemma = $2;
		my $form = $3;
		my $tag = $1;
		
		my $prediction = "?";
		if(exists($tlfWord{"$tag $lemma"}))
		{
			$prediction = $tlfWord{"$tag $lemma"};
		}
		
		# Not in LEX, go for ML
		if($prediction eq "?")
		{
			my $convertedTag = $tag;
			$convertedTag =~ s/\,/_/g;
		
		
			my %features = computeFeatures( $form );
	
			my $diff = extDifff( $lemma, $form );
	
			print CHLD_IN "classify ";
			print CHLD_IN "$convertedTag,?," . ( $lemma =~ /^[A-Z]/ ? "1" : "0" );
			foreach my $itr ( suffices( $lemma, $maxSuffixLength ) )
			{
				print CHLD_IN "," . ( $itr ne "" ? "\"" . $itr . "\"" : "?" );
			}
			print CHLD_IN ",\"$diff\"\n";
			
			while(<CHLD_OUT>)
			{
				#print "> $_\n";
				my $category = $_;
				chomp($category);
				if($category =~ m/CATEGORY {(.*?)}$/)
				{
					#print ">>> $1\n";
					my $diff = $1;
					$diff =~ s/\\_/ /g;
					$diff =~ s/"//g;
					$prediction = applyExtDifff($lemma, $diff);
					last;
				}
			}
			
		}
		
		print $tag." ".$lemma." ".$form." ".$prediction."\n";
	}
}

















sub computeFeatures
{
	my $lemma = shift;
	my %features = ();
	
	if($lemma =~ m/^[A-Z]/)
	{
		$features{'capital'} = 1;
	}
	
	foreach my $i (1..(length($lemma)))
	{
		if (length($lemma) >= $i) 
		{
			$features{"c$i"} = substr($lemma, length($lemma)-$i, 1);
		} else 
		{
			$features{"c$i"} = "";
		}
	}
	
	return %features;
}

# Computes the difference between two words. The first argument is takes as 
# reference, on which the diff is based. As many characters are removed from 
# the first word as needed, such that the second word can be created with the
# same beginning. Thus, the function determines the common beginning of both
# words, and the result is a diff telling what was cut of the first word, and
# what is appended to the second word. 
sub extDifff
{
	my $word1 = shift;
	my $word2 = shift;
	my $whereDiffer = whereDiffer($word1, $word2);
	
	if($word1 eq $word2) { return "-. +." }
	
	my $aRem = substr($word1, $whereDiffer);
	my $bRem = "";
	my $aAdd = substr($word2, $whereDiffer);
	my $bAdd = "";
	
	if(substr($word2, 0, 2) eq "ge")
	{
		$bAdd = substr($word2, 0, 2); # "ge"
		$aAdd = substr($word2, 2);
		
		$whereDiffer = whereDiffer($word1, $aAdd);
		$aRem = substr($word1, $whereDiffer);
		$aAdd = substr($aAdd, $whereDiffer);
		
	} else
	{
		$whereDiffer = whereDiffer($word1, $word2);
		$aRem = substr($word1, $whereDiffer);
		$aAdd = substr($word2, $whereDiffer);
	}
	
	return "-$bRem.$aRem +$bAdd.$aAdd";
}


# Computes at which points the words differ from eachother. Returns a pointer to the first
# character that is not shared.
sub whereDiffer
{
	my $word1 = shift;
	my $word2 = shift;
	foreach my $itr (0 .. min(length($word1), length($word2)))
	{
		if(substr($word1, $itr, 1) ne substr($word2, $itr, 1))
		{
			return $itr;
		}
	}
	return min(length($word1), length($word2));
}

sub suffices
{
	my $word = decode_utf8(shift);
	my $length = shift // length($word); #/
	my $itr = 0;
	my @suffices = ();
	
	foreach $itr (1 .. (min($length, length($word))))
	{
		my $rWord = reverse $word;
		push(@suffices, substr($rWord, 0, $itr));
	}
	$itr = min($length, length($word));
	
	while($itr<$length)
	{
		push(@suffices, "");
		$itr++;
	}
	
	return @suffices;
}

sub readParticle($)
{
	my $particleFile = shift;
	my @particles;

	open FILE, "$particleFile" or die "Cannot open particle file $particleFile!\n";
	
	binmode FILE, "utf8";
	
	while(<FILE>)
	{
		if($_ = m/^\s*\d+\s+([^\s]+)/)
		{
			push(@particles, $1);
		}
	}
	sort(@particles);
	close FILE;
	
	return @particles;
}

# Applies a diff to a word. The diff must be of the form:
#   -[remove at front].[remove at end] +[add to front].[add to end]
# The brackets denote optionality, the most basic form is thus -. +.
# For example:
#   applyExtDiff("proberen", "-. +.") -> "proberen"
#   applyExtDiff("proberen", "-prob.en +felicite.de") -> "feliciteerde"
#   applyExtDiff("proberen", "-.proberen +.test") -> "test"
sub applyExtDifff
{
	my $word = shift;
	my $diff = shift;

	if($diff =~ m/^-([^\.]*)\.([^\s]*) \+([^\.]*)\.([^\s]*)/)
	{	
		my $sub = substr($word, length($1), length($word));
		return $3.substr($sub, 0, length($sub)-length($2)).$4;
	}
	
	warn("Trying to apply unvalid diff ($diff) on word ($word)\n"); 
	return undef;
}