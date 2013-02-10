
use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;
#use warnings;

binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";

use vars qw( $opt_m $opt_i $opt_l);

require 'InfoExtractor.pl';
require 'LexiconActions.pl';
require 'PersistenceFactory.pl';
require 'TagConverter.pl';
require 'WeightingScheme.pl';

#	-m <file>		reads rel.mass lexicon file
#	-i <file|->		reads the input
#	-l				returns lemma if tag-lemma not in lexicon

getopts('m:i: ');


my %tlfWord = ();

if( $opt_m )
{
	%tlfWord = readMassLexicon($opt_m, \%tlfWord);
}

if( $opt_i eq "-")
{
	while(<>)
	{
		if($_ =~ m/^([^\(]+\(.*?\)) ([^\s]+) ([^\s]+)$/)
		{	
			my $lemma = $2;
			my $word = $3;
			my $tag = $1;
			
			my $prediction = "?";
			if( $opt_l)
			{
				$prediction = $lemma;
			}
			if(exists($tlfWord{"$tag $lemma"}))
			{
				$prediction = $tlfWord{"$tag $lemma"};
			}
	
			print $tag." ".$lemma." ".$word." ".$prediction."\n";
	
		}
	}
} elsif( $opt_i)
{
	open IF, "$opt_i" or die "Cannot open input file $opt_i!\n";
	
	while(<IF>)
	{
		if($_ =~ m/^([^\(]+\(.*?\)) ([^\s]+) ([^\s]+)$/)
		{	
			my $lemma = $2;
			my $word = $3;
			my $tag = $1;
			
			my $prediction = "?";
			if( $opt_l)
			{
				$prediction = $lemma;
			}
			if(exists($tlfWord{"$tag $lemma"}))
			{
				$prediction = $tlfWord{"$tag $lemma"};
			}
	
			print $tag." ".$lemma." ".$word." ".$prediction."\n";
	
		}
	}
	
	close IF;
}
