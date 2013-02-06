
# hoi

use Acme::Comment type => 'C++';
use Getopt::Std;

binmode STDOUT, ":utf8";

use vars qw( $opt_g $opt_r $opt_s );

require 'InfoExtractor.pl';
require 'TagConverter.pl';
require 'WeightingScheme.pl';


if( ! getopts('gl:' ) )
{
  die "You did something wrong. Yes. This is not really helping...\n";
}

/*
if( $opt_g )
{
	print "Generate, jeej!\n";	
	
	if( $opt_l )
	{
		process_files($opt_l, \&readFile, $elexRegex);
		#print "$opt_l\n";
	}
	
/*	
if( $opt_e )
	{
		# elex
	}
*/
}
*/



#process_files ("/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Treebank");
#readFile("/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml", \&convertTag);
#readFile("/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml", \&extractElexXML);

my @lijstje = extractElexXMLFile("/tmp/elex");
#my @lijstje = extractElexXMLFile("/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml");
#my @lijstje = extractLassyXMLDirectory("/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Treebank/");
foreach(@lijstje)
{
	print "$_\n";
}


