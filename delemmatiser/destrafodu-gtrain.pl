
use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;
#use warnings;

binmode STDOUT, ":utf8";

use vars qw( $opt_e $opt_o $opt_p $opt_w $opt_t $opt_m $opt_M $opt_d $opt_i $opt_l);

require 'InfoExtractor.pl';
require 'LexiconActions.pl';
require 'PersistenceFactory.pl';
require 'TagConverter.pl';
require 'WeightingScheme.pl';

# defaults
$opt_w = 2;
$opt_t = 1;
$opt_M = 10;
$opt_d = 0;
$opt_i = 0;

# is of the form tlff
our @trainData;

#	-e <file|->		eLex XML file
#	-p <file|->		persistent eLex lexicon file

#	-l <file|->		Lassy frequency counts file	

#	-o <file|->		writes output to file, default is to stdout
#	-m <file>		writes the lexicon entries with their relative mass to a file

#	-w <n>			weighting scheme, n = {1,2,3}, default = 2
#	-t <n>			repetition scheme, n = {1,2,3}, default = 1 (type, token, masstoken)

#	-M <n>			number of entries per tag-lemma pair for masstoken, default = 10
#	-d 				normalise diacritics
#   -i				normalise all characters to lower case

getopts( 'e:o:p:w:t:m:M:dil:' );


if ($opt_e)
{
	#print "Reading eLex XML file... ";
	
	@trainData = readeLexXMLFile($opt_e, $opt_d, $opt_i);

	#print "Number of entries read: ".(($#trainData+1)/4)."\n";
} elsif ($opt_p)
{
	#print "Reading eLex persistent lexicon file... ";
	
	@trainData = readPersistentFile($opt_p, $opt_d, $opt_i);
	
	#print "Number of entries read: ".(($#trainData+1)/4)."\n";
} elsif ($opt_l)
{
	#print "Reading Lassy counts file... ";
	
	@trainData = readPersistentFile($opt_p, $opt_d, $opt_i);
	
	#print "Number of entries read: ".(($#trainData+1)/3)."\n";
}


else
{
	die ("Cannot create a lexicon without input data!\n");
}





my @trainTypeData = applyWeighting($opt_w, \@trainData);
#print "Number of entries after appyling weight: ".(($#trainTypeData+1)/5)."\n";

if($opt_m)
{
	my $fh;
	open($fh, '>', $opt_m) or die;
	binmode $fh, ":utf8";
	
	writeWeightedTrainLexicon($fh, \@trainTypeData);
}








my @trainOutputData;
if ($opt_t eq 1)
{
	@trainOutputData = generateTypes(\@trainTypeData);
	
}
elsif( $opt_t eq 2)
{
	@trainOutputData = generateTokens(\@trainTypeData);
}
elsif( $opt_t eq 3)
{
	@trainOutputData = generateMassTokens(\@trainTypeData, $opt_M);
}



if( $opt_o )
{
	
	my $fh;
	if ($opt_o ne "-") {
	   open($fh, '>', $opt_o) or die;
	} else {
	   $fh = \*STDOUT;
	}
	binmode $fh, ":utf8";
	
	
	writeLexicon($fh, \@trainOutputData);
} else
{
	writeLexicon(\*STDOUT, \@trainOutputData);
}
