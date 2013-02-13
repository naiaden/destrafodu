use Acme::Comment type => 'C++';
use Getopt::Std;
use List::Util qw[min max];
use utf8;
use Encode;

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

sub suffices
{
	my $word = decode_utf8(shift);
	my $length = shift;
	my $itr = 0;
	my @suffices = ();
	
	foreach $itr (1 .. (min($length, length($word))))
	{
		my $rWord = reverse $word;
		push(@suffices, substr($rWord, 0, $itr));
	}
	$itr = min($length, length($word));
	
	while($itr<$length)
	{
		push(@suffices, "");
		$itr++;
	}
	
	return @suffices;
}

sub computeFeatures
{
	my $lemma = shift;
	my %features = ();
	
	if($lemma =~ m/^[A-Z]/)
	{
		$features{'capital'} = 1;
	}
	
	foreach my $i (1..(length($lemma)))
	{
		if (length($lemma) >= $i) 
		{
			$features{"c$i"} = substr($lemma, length($lemma)-$i, 1);
		} else 
		{
			$features{"c$i"} = "";
		}
	}
	
	return %features;
}

# Computes the difference between two words. The first argument is takes as 
# reference, on which the diff is based. As many characters are removed from 
# the first word as needed, such that the second word can be created with the
# same beginning. Thus, the function determines the common beginning of both
# words, and the result is a diff telling what was cut of the first word, and
# what is appended to the second word. 
sub extDifff
{
	my $word1 = shift;
	my $word2 = shift;
	my $whereDiffer = whereDiffer($word1, $word2);
	
	if($word1 eq $word2) { return "-. +." }
	
	my $aRem = substr($word1, $whereDiffer);
	my $bRem = "";
	my $aAdd = substr($word2, $whereDiffer);
	my $bAdd = "";
	
	if(substr($word2, 0, 2) eq "ge")
	{
		$bAdd = substr($word2, 0, 2); # "ge"
		$aAdd = substr($word2, 2);
		
		$whereDiffer = whereDiffer($word1, $aAdd);
		$aRem = substr($word1, $whereDiffer);
		$aAdd = substr($aAdd, $whereDiffer);
		
	} else
	{
		$whereDiffer = whereDiffer($word1, $word2);
		$aRem = substr($word1, $whereDiffer);
		$aAdd = substr($word2, $whereDiffer);
	}
	
	return "-$bRem.$aRem +$bAdd.$aAdd";
}

# Computes at which points the words differ from eachother. Returns a pointer to the first
# character that is not shared.
sub whereDiffer
{
	my $word1 = shift;
	my $word2 = shift;
	foreach my $itr (0 .. min(length($word1), length($word2)))
	{
		if(substr($word1, $itr, 1) ne substr($word2, $itr, 1))
		{
			return $itr;
		}
	}
	return min(length($word1), length($word2));
}

sub startsWithParticle
{
	my $word = shift;
	
	# For now we take the longest particle possible
	my @fittingParticles;
	foreach my $particle (@DLParticles)
	{
		if($particle gt $word)
		{
			last;
		}	
		if(substr($word, 0, length($particle)) eq $particle)
		{
			push(@fittingParticles, $particle);
		}
	}
	
	if(@fittingParticles)
	{
		@fittingParticles = sort { length($a) <=> length($b) } @fittingParticles;
		return $fittingParticles[-1];
	} else
	{
		return "";
	}
}

sub readParticle($)
{
	my $particleFile = shift;
	my @particles;

	open FILE, "$particleFile" or die "Cannot open particle file $particleFile!\n";
	
	binmode FILE, "utf8";
	
	while(<FILE>)
	{
		if($_ = m/^\s*\d+\s+([^\s]+)/)
		{
			push(@particles, $1);
		}
	}
	sort(@particles);
	close FILE;
	
	return @particles;
}

1;