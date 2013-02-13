
use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;

require 'InfoExtractor.pl';

binmode STDOUT, ":utf8";
binmode STDIN,  ":utf8";

use vars qw( $opt_i $opt_d $opt_o $opt_p );

$opt_i = 0;
$opt_d = 0;

getopts('ido:p:');

#   -i				normalise all characters to lower case
#	-d 				normalise diacritics
#	-p <file>		read predictions from file						
#	-o <file>		write statistics to file, default is to stdout

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
if ($opt_p)
{
	if ( $opt_p eq "-" )
	{
		$ifh = \*STDIN;
	}
	else
	{
		open( $ifh, '<', $opt_p ) or die;
	}

}
else
{
	$ifh = \*STDIN;
}
binmode $ifh, ":utf8";

my %tagTotal;
my %tagError;

while (<$ifh>)
{
	if ( $_ =~ m/^([^\(]+\(.*?\)) ([^\s]+) ([^\s]+) ([^\s]+)$/ )
	{
		my $tag    = $1;
		my $lemma  = $2;
		my $word   = $3;
		my $output = $4;

		unless ( normalise($word, $opt_i, $opt_d) eq normalise($output, $opt_i, $opt_d) )
		{
			$tagError{$tag} += 1;
		}

		$tagTotal{$tag} += 1;
	}
}

my $nError     = 0;
my $nTotal     = 0;
my $vError     = 0;
my $vTotal     = 0;
my $adjvError  = 0;
my $adjvTotal  = 0;
my $total      = 0;
my $totalError = 0;
foreach my $key ( keys %tagTotal )
{
	$totalError += $tagError{$key};
	$total      += $tagTotal{$key};
	if ( $key =~ m/^N\(/ )
	{
		$nError += $tagError{$key};
		$nTotal += $tagTotal{$key};
	}
	elsif ( $key =~ m/^V\(/ )
	{
		$vError += $tagError{$key};
		$vTotal += $tagTotal{$key};
	}
	elsif ( $key =~ m/^Adjv\(/ )
	{
		$adjvError += $tagError{$key};
		$adjvTotal += $tagTotal{$key};
	}
}

printf( $fh "Overall performance:\n" );
printf( $fh "\tN: %.6f (%d/%d)\n",
		( $nTotal - $nError ) / $nTotal,
		( $nTotal - $nError ), $nTotal );
printf( $fh "\tV: %.6f (%d/%d)\n",
		( $vTotal - $vError ) / $vTotal,
		( $vTotal - $vError ), $vTotal );
printf( $fh "\tA: %.6f (%d/%d)\n",
		( $adjvTotal - $adjvError ) / $adjvTotal,
		( $adjvTotal - $adjvError ), $adjvTotal );
printf( $fh "\n" );
printf( $fh "Performance per tag:\n" );
printf( $fh "\tTag\t\t\t\tErrors per tag/\tPercentage  Percentage\n" );
printf( $fh "\t\t\t\t\ttag occurences\tper tag\t    of total\n" );

foreach my $key ( sort keys %tagTotal )
{
	if ( $key =~ m/^N\(/ )
	{
		my $e1 = sprintf( "%d/%d", $tagError{$key}, $tagTotal{$key} );
		my $e2 = sprintf( "%.2f", $tagError{$key} / $tagTotal{$key} * 100 );
		printf( $fh "\t%-32s%-16s%-12s%f\n",
				$key, $e1, $e2, $tagError{$key} / $total * 100 );
	}
}
printf( $fh "\n" );
foreach my $key ( sort keys %tagTotal )
{
	if ( $key =~ m/^V\(/ )
	{
		my $e1 = sprintf( "%d/%d", $tagError{$key}, $tagTotal{$key} );
		my $e2 = sprintf( "%.2f", $tagError{$key} / $tagTotal{$key} * 100 );
		printf( $fh "\t%-32s%-16s%-12s%f\n",
				$key, $e1, $e2, $tagError{$key} / $total * 100 );
	}
}
printf( $fh "\n" );
foreach my $key ( sort keys %tagTotal )
{
	if ( $key =~ m/^Adjv\(/ )
	{
		my $e1 = sprintf( "%d/%d", $tagError{$key}, $tagTotal{$key} );
		my $e2 = sprintf( "%.2f", $tagError{$key} / $tagTotal{$key} * 100 );
		printf( $fh "\t%-32s%-16s%-12s%f\n",
				$key, $e1, $e2, $tagError{$key} / $total * 100 );
	}
}
