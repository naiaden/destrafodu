use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;

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

sub showWord($)
{
   my $trie = shift;
   my @words = split(",", $trie);
 
   my $word = "";
   
   my $i = 0;
   foreach(@words)
   {
   	  if($i++>1)
   	  {
	      unless($_ eq "?")
	      {
	         $word = $_;
	      } else
	      {
	         last;
	      }
   	  }
   }
 
 	$word =~ s/"//g;
   return reverse $word;
}

# Applies a diff to a word. The diff must be of the form:
#   -[remove at front].[remove at end] +[add to front].[add to end]
# The brackets denote optionality, the most basic form is thus -. +.
# For example:
#   applyExtDiff("proberen", "-. +.") -> "proberen"
#   applyExtDiff("proberen", "-prob.en +felicite.de") -> "feliciteerde"
#   applyExtDiff("proberen", "-.proberen +.test") -> "test"
sub applyExtDifff
{
	my $word = shift;
	my $diff = shift;

	if($diff =~ m/^-([^\.]*)\.([^\s]*) \+([^\.]*)\.([^\s]*)/)
	{	
		my $sub = substr($word, length($1), length($word));
		return $3.substr($sub, 0, length($sub)-length($2)).$4;
	}
	
	warn("Trying to apply unvalid diff ($diff) on word ($word)\n"); 
	return undef;
}