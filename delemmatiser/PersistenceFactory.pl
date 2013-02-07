use Acme::Comment type => 'C++';
use Switch;

sub writeTrainLexicon($$)
{
	my $lexiconFile = shift;
	my $tlffCombinationsRef = shift;
	my @tlffCombinations = @$tlffCombinationsRef;
	
	open OF, ">$lexiconFile" or die "Cannot open train lexicon output file $lexiconFile!\n";
	
	binmode OF, ":utf8";
	
	print OF "# This is an automatically generated lexicon file\n";
	print OF "# For information, requests, or bug reports, mail louis\@naiaden.nl\n";
	print OF "# Generated by destrafodu: Delemmatisation strategies for Dutch\n";
	print OF "# \n";
	print OF "# The structure is as follows:\n";
	print OF "# tag lemma form frequency\n";
	print OF "# Fields are seperated by a space\n";

	my ($tag, $lemma, $form, $frequency);
	
	my $i = 1;
	foreach(@tlffCombinations)
	{
		my $line = $_;
		
		switch ($i)
		{
			case 1
			{
				$tag = $line;
			}
			case 2
			{
				$lemma = $line;
			}
			case 3
			{
				$form = $line;
			} 
			case 4
			{
				$frequency= $line;
				
				print OF "$tag  $lemma  $form  $frequency\n";
				
				$i = 0;
			}  
			else
			{
				print STDERR "Unknown iterator in writeTrainLexicon: $i";
			}
		}
		
		$i++;
	}
	
	close OF;
}

sub writeTestLexicon($$)
{
	my $lexiconFile = shift;
	my $tlfCombinationsRef = shift;
	my @tlfCombinations = @$tlfCombinationsRef;
	
	open OF, ">$lexiconFile" or die "Cannot open test lexicon output file $lexiconFile!\n";
	
	binmode OF, ":utf8";
	
	print OF "# This is an automatically generated lexicon file\n";
	print OF "# For information, requests, or bug reports, mail louis\@naiaden.nl\n";
	print OF "# Generated by destrafodu: Delemmatisation strategies for Dutch\n";
	print OF "# \n";
	print OF "# The structure is as follows:\n";
	print OF "# tag lemma form\n";
	print OF "# Fields are seperated by a space\n";

	my ($tag, $lemma, $form, $frequency);
	
	my $i = 1;
	foreach(@tlfCombinations)
	{
		my $line = $_;
		
		switch ($i)
		{
			case 1
			{
				$tag = $line;
			}
			case 2
			{
				$lemma = $line;
			}
			case 3
			{
				$form = $line;
				
				print OF "$tag  $lemma  $form\n";
				
				$i = 0;
			} 
			else
			{
				print STDERR "Unknown iterator in writeTestLexicon: $i";
			}
		}
		
		$i++;
	}
	
	close OF;
}

1;