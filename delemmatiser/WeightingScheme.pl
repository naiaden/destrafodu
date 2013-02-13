use Acme::Comment type => 'C++';
use Switch;

sub applyScheme1($)
{
	my $frequency = shift;
	
	return $frequency;
}

sub applyScheme2($)
{
	my $frequency = shift;
	
	return $frequency+1;
}

sub applyScheme3($)
{
	my $frequency = shift;
	
	if($frequency == 0) 
	{ 
		return 2; 
	}
	elsif($frequency == 1) 
	{ 
		return 1; 
	}

	return $frequency+1; 
}

sub applyWeighting($$)
{
	my $weightingScheme = shift;
	my $tlffCombinationsRef = shift;
	
	my @tlffCombinations = @$tlffCombinationsRef;
	
	my %tlFrequencies = ();
	my %tlfFrequencies = ();
	
	for(my $itr = 0; $itr < $#tlffCombinations;)
	{
		my $line = $_;
		
		$tag = $tlffCombinations[$itr++];
		$lemma = $tlffCombinations[$itr++];
		$form = $tlffCombinations[$itr++];
		$frequency = $tlffCombinations[$itr++];
		
		if(exists($tlfFrequencies{"$tag $lemma $form"}))
		{
			$tlfFrequencies{"$tag $lemma $form"} = $tlfFrequencies{"$tag $lemma $form"} + $frequency;
		} else
		{
			$tlfFrequencies{"$tag $lemma $form"} = $frequency;
		}

	}
	
	foreach my $tlfFrequency (keys %tlfFrequencies)
	{
		my $frequency = $tlfFrequencies{$tlfFrequency};
		
		switch ($weightingScheme)
		{
			case 1
			{
				$tlfFrequencies{$tlfFrequency} = applyScheme1($frequency);
			}
			case 2
			{
				$tlfFrequencies{$tlfFrequency} = applyScheme2($frequency);
			}
			case 3
			{
				$tlfFrequencies{$tlfFrequency} = applyScheme3($frequency);
			}  
			else
			{
				print STDERR "Unknown weighting scheme: $weightingScheme";
			}
		}
	}
	
	foreach my $tlfFrequency (keys %tlfFrequencies)
	{	
		my $frequency = $tlfFrequencies{$tlfFrequency};
		if($tlfFrequency =~ m/^([^\(]+\(.*?\)) ([^\s]+) ([^\s]+)$/)
		{
			my $tag = $1;
			my $lemma = $2;
			
			if(exists($tlFrequencies{"$tag $lemma"}))
			{
				$tlFrequencies{"$tag $lemma"} = $tlFrequencies{"$tag $lemma"} + $frequency;
			} else
			{
				$tlFrequencies{"$tag $lemma"} = $frequency;
			}
		}
	}
	
	my @tlffmCombinations;
	
	foreach my $tlfFrequency (keys %tlfFrequencies)
	{	
		my $frequency = $tlfFrequencies{$tlfFrequency};
		my $tlfFreq;
		
		my ($tag, $lemma, $form);
		if($tlfFrequency =~ m/^([^\(]+\(.*?\)) ([^\s]+) ([^\s]+)$/)
		{
			$tag = $1;
			$lemma = $2;
			$form = $3;
			
			$tlfFreq = $tlFrequencies{"$tag $lemma"};
		}
		
		my $tlfRelMass = 0;
		if($frequency > 0 && $tlfFreq > 0)
		{
			$tlfRelMass = $frequency/$tlfFreq;
		}
	
		push(@tlffmCombinations, ($tag, $lemma, $form, $frequency, $tlfRelMass));
	}
	
	return @tlffmCombinations;
}

1;