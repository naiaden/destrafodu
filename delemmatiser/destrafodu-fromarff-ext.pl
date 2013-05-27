
use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;

require 'ScriptApplication.pl';
require 'FeatureFunctions.pl';

binmode STDOUT, ":utf8";
binmode STDIN,  ":utf8";

#   -i <file|->     reads input from file, default is from stdin
#   -t <file>       file with the truth forms. Assumes the same order as the input file

#   -x              only apply the edit script if possible, returns "???" if
#                   the script cannot be applied. Default setting is to force
#                   the application of the edit script.

#   -d              debug, also prints the scripts. Do not use in the pipeline!

#   -o <file|->     writes output to file, default is to stdout

use vars qw( $opt_o $opt_i $opt_x $opt_d $opt_t );
getopts('o:i:xdt:');

sub read_file_line {
  my $fh = shift;
  
  if ($fh and my $line = <$fh>) {
    chomp $line;
    return $line;
  }
  return;
}

my $fh;
if ($opt_o)
{
	if ( $opt_o eq "-" )
	{
		$fh = \*STDOUT;
	}
	else
	{
		open( $fh, '>', $opt_o ) or die;
	}
}
else
{
	$fh = \*STDOUT;
}
binmode $fh, ":utf8";

my $tfh;
open( $tfh, '<', $opt_t ) or die;
binmode $tfh, ":utf8";

my $ifh;
if ($opt_i)
{
	if ( $opt_i eq "-" )
	{
		$ifh = \*STDIN;
	}
	else
	{
		open( $ifh, '<', $opt_i ) or die;
	}

}
else
{
	$ifh = \*STDIN;
}
binmode $ifh, ":utf8";

my $l1 = read_file_line($ifh);
my $l2 = read_file_line($tfh);

while ($l1 and $l2)
{
	
	
	if($l1 eq "" || $l2 eq "") 
	{ next; }
	
	my $originalword = "???";
	my $originalform = "???";
	if($l2 =~ m/([^ ]+) ([^ ]+) ([^ ]+)$/ )
	{
		$originalword = $2;
		$originalform = $3;
	}
	
	
	my $predictededitscript;
	my $originaleditscript;
	if ( $l1 =~ m/([^,]+),(.*?),"([^\"]+)","([^\"]+)"$/ )
	{
		$originaleditscript = $3;
		$predictededitscript = $4;
	}
	
	my $predictedform = "???";
	if ($opt_x)
	{
		$predictedform = applyExtDifffIfPossible( $originalword, $predictededitscript );
	} 
	else
	{
		$predictedform = applyExtDifff( $originalword, $predictededitscript );
	}
	

	if($opt_d)
	{
		print $fh "$1 $originalword $originalform $predictedform $originaleditscript $predictededitscript\n";
	}
	else
	{
		print $fh "$1 $originalword $originalform $predictedform\n";
	}
	
	
	$l1 = read_file_line($ifh);
	$l2 = read_file_line($tfh);
}

