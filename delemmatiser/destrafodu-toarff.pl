
use Acme::Comment type => 'C++';
use Getopt::Std;
use List::Util qw[min max];
use utf8;
use Encode;

use strict;

require 'FeatureFunctions.pl';

binmode STDOUT, ":utf8";
binmode STDIN,  ":utf8";

#   -p              particles file

#   -s              max suffix length, default=35

#   -i <file|->     reads input from file, default is from stdin
#   -o <file|->     writes output to file, default is to stdout

use vars qw( $opt_p $opt_s $opt_o $opt_i );
getopts('p:s:o:i:');

my @DLParticles;
my $maxSuffixLength = 35;

if ($opt_p)
{
	readParticle($opt_p);
}

if ($opt_s)
{
	$maxSuffixLength = $opt_s;
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


print $fh "% 1. Title: destrafodu\n" . "%\n"
  . "% 2. Sources\n" . "%\n"
  . "\@RELATION nouns\n" . "\n"
  . "\@ATTRIBUTE tag		string\n"
  . "\@ATTRIBUTE prefix	string\n"
  . "\@ATTRIBUTE capital	{1,0}\n";
foreach my $attrItr ( 1 .. $maxSuffixLength )
{
	print $fh "\@ATTRIBUTE c$attrItr\t\tstring\n";
}
print $fh "\@ATTRIBUTE class	string\n";
print $fh "\@DATA\n";

while (<$ifh>)
{
	if ( $_ =~ /^(N\([^\s]+\)) ([^\s]+) ([^\s]+)/ )
	{
		my $tag  = $1;
		my $word = $2;
		my $form = $3;

		$tag =~ s/\,/_/g;

		my %features = computeFeatures($word);

		my $diff = extDifff( $word, $form );

		print $fh "$tag,?," . ( $word =~ /^[A-Z]/ ? "1" : "0" );
		foreach my $itr ( suffices( $word, $maxSuffixLength ) )
		{
			print $fh "," . ( $itr ne "" ? "\"" . $itr . "\"" : "?" );
		}
		print $fh ",\"$diff\"\n";
	}

	elsif ( $_ =~ /^(V\([^\s]+\)) ([^\s]+) ([^\s]+)/ )
	{
		my $tag  = $1;
		my $word = $2;
		my $form = $3;

		$tag =~ s/\,/_/g;

		my %features = computeFeatures($word);

		my $diff = extDifff( $word, $form );

		my $sWP = startsWithParticle($word, \@DLParticles);

		print $fh "$tag,"
		  . ( $sWP ? "\"$sWP\"" : "\"\"" ) . ","
		  . ( $word =~ /^[A-Z]/ ? "1" : "0" );
		foreach my $itr ( suffices( $word, $maxSuffixLength ) )
		{
			print $fh "," . ( $itr ne "" ? "\"" . $itr . "\"" : "?" );
		}
		print $fh ",\"$diff\"\n";
	}

	elsif ( $_ =~ /^(Adjv\([^\s]+\)) ([^\s]+) ([^\s]+)/ )
	{
		my $tag = $1;

		my $word = $2;
		my $form = $3;

		$tag =~ s/\,/_/g;
		my %features = computeFeatures($word);

		my $diff = extDifff( $word, $form );

		print $fh "$tag,?,?";
		foreach my $itr ( suffices( $word, $maxSuffixLength ) )
		{
			print $fh "," . ( $itr ne "" ? "\"" . $itr . "\"" : "?" );
		}
		print $fh ",\"$diff\"\n";
	}
}

