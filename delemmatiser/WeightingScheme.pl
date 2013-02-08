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
	
	for(my $itr = 0; $itr < $#tlffCombinations; $itr = $itr + 4)
	{
		my $line = $_;
		
		#my ($tag, $lemma, $form, $frequency) = ($line);
		
		$tag = $tlffCombinations[$itr];
		$lemma = $tlffCombinations[$itr+1];
		$form = $tlffCombinations[$itr+2];
		$frequency = $tlffCombinations[$itr+3];
		
		#print ">$tag $lemma $form $frequency\n";
		
		if(exists($tlfFrequencies{"$tag $lemma $form"}))
		{
			$tlfFrequencies{"$tag $lemma $form"} = $tlfFrequencies{"$tag $lemma $form"} + $frequency;
		} else
		{
			$tlfFrequencies{"$tag $lemma $form"} = $frequency;
		}
		
		#if($itr % 100 eq 0)
		#{
		#	print "$itr ";
		#	if($itr % 5000 eq 0)
		#	{
		#		print "\n";
		#	}
		#}
	}
	
	print "\n";
	
	
	foreach my $tlfFrequency (keys %tlfFrequencies)
	{
		my $frequency = $tlfFrequencies{$tlfFrequency};
		
		switch ($weightingScheme)
		{
			case 1
			{
				applyScheme1($frequency);
			}
			case 2
			{
				applyScheme2($frequency);
			}
			case 3
			{
				applyScheme3($frequency);
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
		#print("$tag, $lemma, $form, $frequency, $tlfRelMass\n");
	}
	
	return @tlffmCombinations;
}

1;