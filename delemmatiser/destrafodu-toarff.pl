
use Acme::Comment type => 'C++';
use Getopt::Std;
use List::Util qw[min max];
use utf8;
use Encode;

use strict;

binmode STDOUT, ":utf8";
binmode STDIN,  ":utf8";

use vars qw( $opt_p $opt_s );
getopts( 'p:s:' );

my @DLParticles;
my $maxSuffixLength = 35;

if( $opt_p )
{
	readParticle($opt_p);
}

if( $opt_s)
{
	$maxSuffixLength = $opt_s	
}

# 	-p		particles file
# 	-s		max suffix length, default=35

print "% 1. Title: Nouns\n" . "%\n"
    . "% 2. Sources\n" . "%\n"
    . "\@RELATION nouns\n" . "\n"
    . "\@ATTRIBUTE tag		string\n"
    . "\@ATTRIBUTE prefix	string\n"
    . "\@ATTRIBUTE capital	{1,0}\n";
foreach my $attrItr ( 1 .. $maxSuffixLength )
{
	print "\@ATTRIBUTE c$attrItr\t\tstring\n";
}
print "\@ATTRIBUTE class	string\n";
print "\@DATA\n";

while (<>)
{
	if ( $_ =~ /^(N\([^\s]+\)) ([^\s]+) ([^\s]+)/ )
	{
		

		my $tag = $1;
		my $word = $2;
		my $form = $3;
		
		
		$tag =~ s/\,/_/g;
		
		my %features = computeFeatures( $word );

		my $diff = extDifff( $word, $form );

		print "$tag,?," . ( $word =~ /^[A-Z]/ ? "1" : "0" );
		foreach my $itr ( suffices( $word, $maxSuffixLength ) )
		{
			print "," . ( $itr ne "" ? "\"" . $itr . "\"" : "?" );
		}
		print ",\"$diff\"\n";
	}
	
	elsif ( $_ =~ /^(V\([^\s]+\)) ([^\s]+) ([^\s]+)/ )
	{
		

		my $tag = $1;
		my $word = $2;
		my $form = $3;
		
		$tag =~ s/\,/_/g;
		
		my %features = computeFeatures( $word );

		my $diff = extDifff( $word, $form );

		my $sWP = startsWithParticle($word);

		print "$tag,".($sWP ? "\"$sWP\"" : "\"\"")."," . ( $word =~ /^[A-Z]/ ? "1" : "0" );
		foreach my $itr ( suffices( $word, 35 ) )
		{
			print "," . ( $itr ne "" ? "\"" . $itr . "\"" : "?" );
		}
		print ",\"$diff\"\n";
	}
	
	elsif ( $_ =~ /^(Adjv\([^\s]+\)) ([^\s]+) ([^\s]+)/ )
	{
		

		my $tag = $1;

		my $word = $2;
		my $form = $3;
		
		
		$tag =~ s/\,/_/g;
		my %features = computeFeatures( $word );

		my $diff = extDifff( $word, $form );

		print "$tag,?,?";
		foreach my $itr ( suffices( $word, 35 ) )
		{
			print "," . ( $itr ne "" ? "\"" . $itr . "\"" : "?" );
		}
		print ",\"$diff\"\n";
	}
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

sub startsWithParticle
{
	my $word = shift;
	
	# For now we take the longest particle possible
	my @fittingParticles;
	foreach my $particle (@DLParticles)
	{
		if($particle gt $word)
		{
			last;
		}	
		if(substr($word, 0, length($particle)) eq $particle)
		{
			push(@fittingParticles, $particle);
		}
	}
	
	if(@fittingParticles)
	{
		@fittingParticles = sort { length($a) <=> length($b) } @fittingParticles;
		return $fittingParticles[-1];
	} else
	{
		return "";
	}
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