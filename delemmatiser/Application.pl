
# hoi

use Acme::Comment type => 'C++';
use Getopt::Std;

binmode STDOUT, ":utf8";

use vars qw( $opt_g $opt_r $opt_s );

require 'InfoExtractor.pl';
require 'TagConverter.pl';

sub printFileName($);
sub process_files($$$);
sub process_filess($$);
sub readFile($$);



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

#process_filess ("/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Treebank", \&readFile);
#process_files ("/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Treebank", \&readFile, InfoExtractor::lassyRegex);
#readFile("/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml", $elexRegex);




sub printFileName($)
{
	my $fileName = shift;
	
	print "$fileName\n";
}

# $1: the full path to a directory.
# Returns: nothing.
sub process_files($$$) {
    my $path = shift;
    my $functor = shift;
    my $regex = shift;

    # Open the directory.
    opendir (DIR, $path)
        or die "Unable to open $path: $!";

    # Read in the files.
    # You will not generally want to process the '.' and '..' files,
    # so we will use grep() to take them out.
    my @files = grep { !/^\.{1,2}$/ } readdir (DIR);

    closedir (DIR);

    @files = map { $path . '/' . $_ } @files;

    for (@files) {

        # If the file is a directory
        if (-d $_) {
            process_files ($_, $functor, $regex);
        } else { 
        	$functor->($_, $regex);
        }
    }
}

# $1: the full path to a directory.
# Returns: nothing.
sub process_filess($$) {
    my $path = shift;
    my $functor = shift;

    # Open the directory.
    opendir (DIR, $path)
        or die "Unable to open $path: $!";

    # Read in the files.
    # You will not generally want to process the '.' and '..' files,
    # so we will use grep() to take them out.
    my @files = grep { !/^\.{1,2}$/ } readdir (DIR);

    closedir (DIR);

    @files = map { $path . '/' . $_ } @files;

    for (@files) {

        # If the file is a directory
        if (-d $_) {
            process_filess ($_, $functor);
        } else { 
        	$functor->($_);
        }
    }
}



#process_files ("/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Treebank");
#readFile("/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml", \&convertTag);
#readFile("/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml", \&extractElexXML);

my @lijstje = extractElexXMLFile("/tmp/elex");
#my @lijstje = extractElexXMLFile("/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml");
foreach(@lijstje)
{
	print "$_\n";
}

sub readFile($$)
{	
	(my $file, my $infoExtractor) = @_;
	
	open IF, $file or die "Cannot open elex\n";
	while(<IF>)
	{
		my $line = $_;

		my ($result, $tag, $lemma, $form) = $infoExtractor->($line);
		if($result ne "0")
		{
			print ">>> $tag $lemma $form\n";
		}
	}
}


