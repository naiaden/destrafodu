
# hoi

use Acme::Comment type => 'C++';
use Getopt::Std;

binmode STDOUT, ":utf8";

use vars qw( $opt_g $opt_r $opt_s );

require 'InfoExtractor.pl';
require 'PersistenceFactory.pl';
require 'TagConverter.pl';
require 'WeightingScheme.pl';


# Mode: g p
# 	-g				Generate lexicon files
#   -p <dir>		Persistent mode, save files in directory
#
# Inputs: [e|t] [l|L|T]
#	-e <file>		Elex XML file
# 	-l <file>		Lassy frequency counts file
# 	-L <dir>   		Lassy XML directory
#	-t <file>		Load persistent Elex file
#	-T <file>		Load persistent Lassy file
if( ! getopts('gl:p:' ) )
{
  die "You did something wrong. Yes. This is not really helping...\n";
}

#getopts('gl:p:' );

if( $opt_g )
{
	print "Generate, jeej!\n";	
	
	if( $opt_l )
	{
		#process_files($opt_l, \&readFile, $elexRegex);
		#print "$opt_l\n";
	}
	
/*	
if( $opt_e )
	{
		# elex
	}
*/
}




my @trainData = extractElexXMLFile("/tmp/elex");
my @testData = extractLassyXMLDirectory("/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Treebank/dpc-kam-001286-nl-sen/");


if( $opt_p )
{
	print "Making data persistent...";
	writeTrainLexicon("$opt_p/trainData", \@trainData);
	writeTestLexicon("$opt_p/testData", \@testData);
}
