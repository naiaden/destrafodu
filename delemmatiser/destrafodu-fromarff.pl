use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;

require 'somefile.pl';
require 'arffthings.pl';

binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";

while(<>)
{
	if($_ =~ m/([^,]+),(.*?),"([^\"]+)","([^\"]+)"$/)
	{
			my $w = showWord($2);
			
			my $diff1 = $3;
            my $diff2 = $4;
			
			my $word1 = applyExtDifff($w, $diff1);
            my $word2 = applyExtDifff($w, $diff2);
			
			print "$1 $w $word1 $word2\n";
	}
}



