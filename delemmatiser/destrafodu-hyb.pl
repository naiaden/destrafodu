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
require 'arffthings.pl';


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

