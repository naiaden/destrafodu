
use Acme::Comment type => 'C++';
use Getopt::Std;
use List::Util qw[min max];
use utf8;
use Encode;

use strict;

require 'arffthings.pl';

binmode STDOUT, ":utf8";
binmode STDIN,  ":utf8";



use vars qw( $opt_p $opt_s );
getopts( 'p:s:' );

my @DLParticles;
my $maxSuffixLength = 35;

if( $opt_p )
{
	readParticle($opt_p);
}

if( $opt_s)
{
	$maxSuffixLength = $opt_s	
}

# 	-p		particles file
# 	-s		max suffix length, default=35

print "% 1. Title: Nouns\n" . "%\n"
    . "% 2. Sources\n" . "%\n"
    . "\@RELATION nouns\n" . "\n"
    . "\@ATTRIBUTE tag		string\n"
    . "\@ATTRIBUTE prefix	string\n"
    . "\@ATTRIBUTE capital	{1,0}\n";
foreach my $attrItr ( 1 .. $maxSuffixLength )
{
	print "\@ATTRIBUTE c$attrItr\t\tstring\n";
}
print "\@ATTRIBUTE class	string\n";
print "\@DATA\n";

while (<>)
{
	if ( $_ =~ /^(N\([^\s]+\)) ([^\s]+) ([^\s]+)/ )
	{
		

		my $tag = $1;
		my $word = $2;
		my $form = $3;
		
		
		$tag =~ s/\,/_/g;
		
		my %features = computeFeatures( $word );

		my $diff = extDifff( $word, $form );

		print "$tag,?," . ( $word =~ /^[A-Z]/ ? "1" : "0" );
		foreach my $itr ( suffices( $word, $maxSuffixLength ) )
		{
			print "," . ( $itr ne "" ? "\"" . $itr . "\"" : "?" );
		}
		print ",\"$diff\"\n";
	}
	
	elsif ( $_ =~ /^(V\([^\s]+\)) ([^\s]+) ([^\s]+)/ )
	{
		

		my $tag = $1;
		my $word = $2;
		my $form = $3;
		
		$tag =~ s/\,/_/g;
		
		my %features = computeFeatures( $word );

		my $diff = extDifff( $word, $form );

		my $sWP = startsWithParticle($word);

		print "$tag,".($sWP ? "\"$sWP\"" : "\"\"")."," . ( $word =~ /^[A-Z]/ ? "1" : "0" );
		foreach my $itr ( suffices( $word, 35 ) )
		{
			print "," . ( $itr ne "" ? "\"" . $itr . "\"" : "?" );
		}
		print ",\"$diff\"\n";
	}
	
	elsif ( $_ =~ /^(Adjv\([^\s]+\)) ([^\s]+) ([^\s]+)/ )
	{
		

		my $tag = $1;

		my $word = $2;
		my $form = $3;
		
		
		$tag =~ s/\,/_/g;
		my %features = computeFeatures( $word );

		my $diff = extDifff( $word, $form );

		print "$tag,?,?";
		foreach my $itr ( suffices( $word, 35 ) )
		{
			print "," . ( $itr ne "" ? "\"" . $itr . "\"" : "?" );
		}
		print ",\"$diff\"\n";
	}
}






