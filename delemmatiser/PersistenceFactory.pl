use Acme::Comment type => 'C++';
use Switch;

















sub readTrainLexiconStdIn($)
{
	my $tlffCombinationsRef = shift;
	my @tlffCombinations = @$tlffCombinationsRef;
		
	binmode STDIN, ":utf8";
	
	my ($tag, $lemma, $form, $frequency);
	
	while(<>)
	{
		my $line = $_;
		
		unless($line =~ m/^#/g)
		{
			my @tlffLocal = split(/\s+/, $line);
			
			$tag = $tlffLocal[0];
			$lemma = $tlffLocal[1];
			$form = $tlffLocal[2];
			$frequency = $tlffLocal[3];
	
			push(@tlffCombinations, ($tag, $lemma, $form, $frequency));
		}
	}
	
	return @tlffCombinations;
}

sub readTrainLexicon($$)
{
	my $lexiconFile = shift;
	my $tlffCombinationsRef = shift;
	my @tlffCombinations = @$tlffCombinationsRef;
	
	open IF, "<$lexiconFile" or die "Cannot open train lexicon input file $lexiconFile!\n";
	
	binmode IF, ":utf8";
	
	my ($tag, $lemma, $form, $frequency);
	
	while(<IF>)
	{
		my $line = $_;
		
		unless($line =~ m/^#/g)
		{
			my @tlffLocal = split(/\s+/, $line);
			
			$tag = $tlffLocal[0];
			$lemma = $tlffLocal[1];
			$form = $tlffLocal[2];
			$frequency = $tlffLocal[3];
	
			push(@tlffCombinations, ($tag, $lemma, $form, $frequency));
		}
	}
	
	close IF;
	
	return @tlffCombinations;
}

sub readTestLexiconStdIn($)
{
	my $tlfCombinationsRef = shift;
	my @tlfCombinations = @$tlfCombinationsRef;
		
	binmode STDIN, ":utf8";
	
	my ($tag, $lemma, $form);
	
	while(<>)
	{
		my $line = $_;
		
		unless($line =~ m/^#/g)
		{
			my @tlfLocal = split(/\s+/, $line);
			
			$tag = $tlfLocal[0];
			$lemma = $tlfLocal[1];
			$form = $tlfLocal[2];
	
			push(@tlfCombinations, ($tag, $lemma, $form));
		}
	}
	
	return @tlfCombinations;
}

sub readTestLexicon($$)
{
	my $lexiconFile = shift;
	my $tlfCombinationsRef = shift;
	my @tlfCombinations = @$tlfCombinationsRef;
	
	open IF, "<$lexiconFile" or die "Cannot open test lexicon input file $lexiconFile!\n";
	
	binmode IF, ":utf8";
	
	my ($tag, $lemma, $form);
	
	while(<IF>)
	{
		my $line = $_;
		
		unless($line =~ m/^#/g)
		{
			my @tlfLocal = split(/\s+/, $line);
			
			$tag = $tlfLocal[0];
			$lemma = $tlfLocal[1];
			$form = $tlfLocal[2];
	
			push(@tlfCombinations, ($tag, $lemma, $form));
		}
	}
	
	close IF;
	
	return @tlfCombinations;
}

sub writeTrainLexicon($$)
{
	my $lexiconFile = shift;
	my $tlffCombinationsRef = shift;
	my @tlffCombinations = @$tlffCombinationsRef;
	
	open OF, ">$lexiconFile" or die "Cannot open train lexicon output file $lexiconFile!\n";
	
	binmode OF, ":utf8";
	
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
				
				print OF "$tag $lemma $form $frequency\n";
				
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

sub writeWeightedTrainLexicon($$)
{
	my $lexiconFile = shift;
	my $tlffmCombinationsRef = shift;
	my @tlffmCombinations = @$tlffmCombinationsRef;
	
	open OF, ">$lexiconFile" or die "Cannot open weighted train lexicon output file $lexiconFile!\n";
	
	binmode OF, ":utf8";

	my ($tag, $lemma, $form, $frequency, $mass);
	
	my $i = 1;
	foreach(@tlffmCombinations)
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
			}  
			case 5
			{
				$mass = $line;
				
				print OF "$tag $lemma $form $frequency $mass\n";
				
				$i = 0;
			}
			else
			{
				print STDERR "Unknown iterator in writeWeightedTrainLexicon: $i";
			}
		}
		
		$i++;
	}
	
	close OF;
}

sub writeWeightedTrainLexiconStdOut($$)
{
	my $lexiconFile = shift;
	my $tlffmCombinationsRef = shift;
	my @tlffmCombinations = @$tlffmCombinationsRef;
	
	binmode STDOUT, ":utf8";
	
	my ($tag, $lemma, $form, $frequency, $mass);
	
	my $i = 1;
	foreach(@tlffmCombinations)
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
			}  
			case 5
			{
				$mass = $line;
				
				print "$tag $lemma $form $frequency $mass\n";
				
				$i = 0;
			}
			else
			{
				print STDERR "Unknown iterator in writeWeightedTrainLexicon: $i";
			}
		}
		
		$i++;
	}
}

sub writeTestLexiconStdOut
{
	my $tlfCombinationsRef = shift;
	my @tlfCombinations = @$tlfCombinationsRef;
	
	binmode STDOUT, ":utf8";

	my ($tag, $lemma, $form);
	
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
				
				print "$tag $lemma $form\n";
				
				$i = 0;
			} 
			else
			{
				print STDERR "Unknown iterator in writeTestLexicon: $i";
			}
		}
		
		$i++;
	}
	
}

sub writeTestLexicon($$)
{
	my $lexiconFile = shift;
	my $tlfCombinationsRef = shift;
	my @tlfCombinations = @$tlfCombinationsRef;
	
	open OF, ">$lexiconFile" or die "Cannot open test lexicon output file $lexiconFile!\n";
	
	binmode OF, ":utf8";

	my ($tag, $lemma, $form);
	
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
				
				print OF "$tag $lemma $form\n";
				
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