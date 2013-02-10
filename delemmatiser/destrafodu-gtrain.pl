
use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;
#use warnings;

binmode STDOUT, ":utf8";

use vars qw( $opt_e $opt_o $opt_p $opt_w $opt_t $opt_m);

require 'InfoExtractor.pl';
require 'LexiconActions.pl';
require 'PersistenceFactory.pl';
require 'TagConverter.pl';
require 'WeightingScheme.pl';

# defaults
$opt_w = 2;
$opt_t = 1;


our @trainData;

#	-e <file|->		eLex XML file
#	-p <file|->		persistent eLex lexicon file
#	-o <file>		writes output to file, default is to stdout
#	-m <file>		writes the lexicon entries with their relative mass to a file
#	-w <n>			weighting scheme, n = {1,2,3}, default = 2
#	-t <n>			repetition scheme, n = {1,2,3}, default = 1 (type, token, masstoken)

# currently -t1 is not implemented correctly. Do a sort -u on t2 to get types.

getopts( 'e:o:p:w:t:m:' );

if ($opt_e)
{
	#print "Reading eLex XML file... ";
	
	if($opt_e eq "-")
	{			
		@trainData = extractElexXMLFileStdIn();
	} else
	{
		@trainData = extractElexXMLFile($opt_e);
	}
	
	#print "Number of entries read: ".(($#trainData+1)/4)."\n";
}

if ($opt_p)
{
	#print "Reading eLex persistent lexicon file... ";
	
	if($opt_p eq "-")
	{			
		@trainData = readTrainLexiconStdIn();
	} else
	{
		@trainData = readTrainLexicon($opt_p);
	}
	
	#print "Number of entries read: ".(($#trainData+1)/4)."\n";
}

my @trainTypeData = applyWeighting($opt_w, \@trainData);
#print "Number of entries after appyling weight: ".(($#trainTypeData+1)/5)."\n";

if($opt_m)
{
	writeWeightedTrainLexicon($opt_m, \@trainTypeData);
}

my @trainOutputData;
if ($opt_t eq 1)
{
	#my %seen =() ;
	#@trainOutputData = grep { ! $seen{$_}++ } 
	@trainOutputData = generateDumbTypes(\@trainTypeData) ; # this does not do sort -u!!!
	
}
elsif( $opt_t eq 2)
{
	@trainOutputData = generateTokens(\@trainTypeData);
}
elsif( $opt_t eq 3)
{
	@trainOutputData = generateMassTokens(\@trainTypeData);
}

if( $opt_o )
{
	writeLexicon($opt_o, \@trainOutputData);
} else
{
	writeLexiconStdOut(\@trainOutputData);
}
