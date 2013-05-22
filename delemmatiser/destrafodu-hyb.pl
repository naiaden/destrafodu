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
require 'FeatureFunctions.pl';
require 'ScriptApplication.pl';


binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";

$|++;

use vars qw( $opt_m $opt_p $opt_t $opt_P $opt_b $opt_i $opt_o $opt_h $opt_x $opt_s);

#	-h <host>			host name or address on which the timblserver runs
#	-P <n>				port number on which the timblserver runs, default=7000
#	-t <timblclient>	the timblclient, default it is timblclient (from PATH)
#	-b <name>			base name, default=destrafodu

#  -x                only apply the edit script if possible, returns "???" if
#                    the script cannot be applied. Default setting is to force
#                    the application of the edit script.
#   -s               max suffix length, default=35

#  -p <file>         particles file
#	-m <file>			reads rel.mass lexicon file

#	-i <file|->			input of tag-lemma-form triples, form can be ? in case it is unknown, default is from stdin
#	-o <file|->			writes output to file, default is to stdout

my @DLParticles;
my $maxSuffixLength = 35;
my %tlfWord = ();

$opt_t = "timblclient";
$opt_P = "7000";
$opt_b = "destrafodu";

getopts('m:p:t:P:b:i:o:h:xs:');

unless($opt_h)
{
	die ("You must give up a hostname which runs the timblserver!\n");
}

if( $opt_m )
{
	%tlfWord = readMassLexicon($opt_m, \%tlfWord);
}

if( $opt_p )
{
	@DLParticles = readParticle($opt_p);
}

my $fh;
if ($opt_o) {
	if ($opt_o eq "-") 
	{
		$fh = \*STDOUT;
	} else
	{
   open($fh, '>', $opt_o) or die;
	}
} else {
   $fh = \*STDOUT;
}
binmode $fh, ":utf8";

my $ifh;
if ($opt_i) {
	if ($opt_i eq "-") 
	{
		$ifh = \*STDIN;
	} else
	{
   		open($ifh, '<', $opt_i) or die;
	}

} else {
   $ifh = \*STDIN;
}
binmode $ifh, ":utf8";

if ($opt_s)
{
	$maxSuffixLength = $opt_s;
}


my $pid = open3(\*CHLD_IN, \*CHLD_OUT, \*CHLD_ERR, "$opt_t -n $opt_h -p $opt_P")
    or die "open3() failed $!";

my $serverResponse;

print CHLD_IN "base $opt_b\n";
binmode CHLD_IN, ":utf8";
binmode CHLD_OUT, ":utf8";

while(<$ifh>)
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
					
					if($opt_x)
					{
						$prediction = applyExtDifffIfPossible($lemma, $diff);
					}
					else
					{
						$prediction = applyExtDifff($lemma, $diff);
					}
					
					last;
				}
			}
			
		}
		
		print $fh $tag." ".$lemma." ".$form." ".$prediction."\n";
	}
}

