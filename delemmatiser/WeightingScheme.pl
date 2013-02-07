use Acme::Comment type => 'C++';
use Switch;

sub applyScheme1($)
{
	
}

sub applyScheme2($)
{
	
}

sub applyWeighting($$)
{
	my $weightingScheme = shift;
	my $tlffCombinationsRef = shift;
	my @tlffCombinations = @$tlffCombinationsRef;
	
	switch ($weightingScheme)
	{
		case 1
		{
			applyScheme1(\@tlffCombinations);
		}
		case 2
		{
			applyScheme2(\@tlffCombinations);
		} 
		else
		{
			print STDERR "Unknown weighting scheme: $weightingScheme";
		}
	}
}

1;