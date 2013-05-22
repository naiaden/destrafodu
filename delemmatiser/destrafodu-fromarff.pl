
use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;

require 'ScriptApplication.pl';
require 'FeatureFunctions.pl';

binmode STDOUT, ":utf8";
binmode STDIN,  ":utf8";

#   -i <file|->     reads input from file, default is from stdin

#   -x              only apply the edit script if possible, returns "???" if
#                   the script cannot be applied. Default setting is to force
#                   the application of the edit script.

#   -o <file|->     writes output to file, default is to stdout

use vars qw( $opt_o $opt_i $opt_x );
getopts('o:i:x');

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

while (<$ifh>)
{
	if ( $_ =~ m/([^,]+),(.*?),"([^\"]+)","([^\"]+)"$/ )
	{
		my $w = showWord($2);

		my $diff1 = $3;
		my $diff2 = $4;

		my $word1 = "???";
		my $word2 = "???";

		if ($opt_x)
		{
			$word1 = applyExtDifffIfPossible( $w, $diff1 );
			$word2 = applyExtDifffIfPossible( $w, $diff2 );
		} 
		else
		{
			$word1 = applyExtDifff( $w, $diff1 );
			$word2 = applyExtDifff( $w, $diff2 );
		}

		print $fh "$1 $w $word1 $word2\n";
	}
}

