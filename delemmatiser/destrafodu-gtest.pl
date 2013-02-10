
use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;
use warnings;

binmode STDOUT, ":utf8";

use vars qw( $opt_l $opt_p $opt_d $opt_o );

require 'InfoExtractor.pl';
require 'PersistenceFactory.pl';
require 'TagConverter.pl';
require 'WeightingScheme.pl';


our @testData;

#	-l <file|->		Lassy frequency counts file
#	-p <file|->		persistent Lassy lexicon file
#	-d <dir>		Lassy XML directory
#	-o <file>		writes output to file, default is to stdout

# currently only tokens are generated. Use sort -u for types.

getopts( 'l:p:d:o:' );

if ($opt_l)
{
	#print "Reading Lassy counts file... ";
	
	if($opt_l eq "-")
	{			
		@testData = extractLassyCountFileStdIn();
	} else
	{
		@testData = extractLassyCountFile($opt_l);
	}
	
	#print "Number of entries read: ".(($#testData+1)/3)."\n";
}

if ($opt_p)
{
	#print "Reading Lassy persistent lexicon file... ";
	
	if($opt_p eq "-")
	{			
		@testData = readTestLexiconStdIn();
	} else
	{
		@testData = readTestLexicon($opt_p);
	}
	
	#print "Number of entries read: ".(($#testData+1)/3)."\n";
}

if( $opt_d )
{
	#print "Reading Lassy XML directory... ";
	@testData = extractLassyXMLDirectory($opt_d);
	
	#print "Number of entries read: ".(($#testData+1)/3)."\n";
}

if( $opt_o )
{
	writeLexicon($opt_o, \@testData);
	#print "Saved weighted train lexicon to $opt_o\n";
} else
{
	writeLexiconStdOut(\@testData);
}
