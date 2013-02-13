
use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;
use warnings;

binmode STDOUT, ":utf8";
binmode STDIN,  ":utf8";

use vars qw( $opt_m $opt_i $opt_l $opt_o);

require 'InfoExtractor.pl';
require 'LexiconActions.pl';
require 'PersistenceFactory.pl';
require 'TagConverter.pl';
require 'WeightingScheme.pl';

#	-m <file>		reads rel.mass lexicon file
#	-i <file|->		reads the input
#	-o <file|->		writes output to file, default is to stdout

#	-l				returns lemma if tag-lemma not in lexicon

getopts('m:i:lo:');

my %tlfWord = ();

if ($opt_m)
{
	%tlfWord = readMassLexicon( $opt_m, \%tlfWord );
}
else
{
	die("You must provide a relative mass lexicon!\n");
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

while (<$ifh>)
{
	if ( $_ =~ m/^([^\(]+\(.*?\)) ([^\s]+) ([^\s]+)$/ )
	{
		my $lemma = $2;
		my $word  = $3;
		my $tag   = $1;

		my $prediction = "?";
		if ($opt_l)
		{
			$prediction = $lemma;
		}
		if ( exists( $tlfWord{"$tag $lemma"} ) )
		{
			$prediction = $tlfWord{"$tag $lemma"};
		}

		print $fh $tag . " " . $lemma . " " . $word . " " . $prediction . "\n";

	}
}

