
# hoi

use Acme::Comment type => 'C++';
use Getopt::Std;

binmode STDOUT, ":utf8";

use vars qw( $opt_g $opt_e $opt_L $opt_p $opt_t $opt_T);

require 'InfoExtractor.pl';
require 'PersistenceFactory.pl';
require 'TagConverter.pl';
require 'WeightingScheme.pl';


# Mode: g p
# 	-g				Generate lexicon files						implemented
#   -p <dir>		Persistent mode, save files in directory	implemented
#
# Inputs: [e|t] [l|L|T]
#	-e <file>		Elex XML file								implemented
# 	-l <file>		Lassy frequency counts file					
# 	-L <dir>   		Lassy XML directory							implemented
#	-t <file>		Load persistent Elex file					implemented
#	-T <file>		Load persistent Lassy file					implemented


#if( ! getopts('gl:p:' ) )
#{
#  die "You did something wrong. Yes. This is not really helping...\n";
#}

getopts('gl:p:e:L:t:T:' );


our @trainData;
our @testData;

if( $opt_g )
{
	print "Generating lexicon files\n";	
	
	if( $opt_e )
	{
		print "Reading eLex XML file... ";
		@trainData = extractElexXMLFile($opt_e);
		
		print "Number of entries read: ".(($#trainData+1)/4)."\n";
		
		if( $opt_p )
		{
			print "Saving eLex lexicon... ";
			writeTrainLexicon("$opt_p/trainData.lexicon", \@trainData);
			print "eLex lexicon saved in $opt_p/trainData.lexicon\n";
		}
	}
	elsif( $opt_t )
	{
		print "Reading persistent eLex lexicon file... ";
		@trainData = readTrainLexicon($opt_t, \@trainData);
		
		print "Number of entries read: ".(($#trainData+1)/4)."\n";
		
	}
	
	if( $opt_L )
	{
		print "Reading Lassy XML directory... ";
		@testData = extractLassyXMLDirectory($opt_L);
		
		print "Number of entries read: ".(($#testData+1)/3)."\n";
		
		if( $opt_p )
		{
			print "Saving Lassy lexicon... ";
			writeTestLexicon("$opt_p/testData.lexicon", \@testData);
			print "Lassy lexicon saved in $opt_p/testData.lexicon\n";
		}
	}
	elsif( $opt_T )
	{
		print "Reading persistent lassy lexicon file... ";
		@testData = readTestLexicon($opt_T, \@testData);
		
		print "Number of entries read: ".(($#testData+1)/3)."\n";
		
	}
	
}





