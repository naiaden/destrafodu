use Acme::Comment type => 'C++';
use Switch;
use Encode;

require 'InfoExtractor.pl';

sub readeLexXMLFile($$)
{
	my $file = shift;
	my $normaliseDiacritics = shift;
	my $normaliseCase = shift;
	
	my $fh;
	if ($file ne "-") {
	   open($fh, '<:encoding(latin1)', $file) or die;
	} else {
	   $fh = \*STDIN;
	}
	
	return extractElexXMLFile($fh, $normaliseDiacritics, $normaliseCase);
}

sub readPersistentFile($)
{
	my $file = shift;
	my $normaliseDiacritics = shift;
	my $normaliseCase = shift;
	
	my $fh;
	if ($file ne "-") {
	   open($fh, '<', $file) or die;
	} else {
	   $fh = \*STDIN;
	}
	binmode $fh, ":utf8";

	return readPersistentLexicon($fh, $normaliseDiacritics, $normaliseCase);
}

sub readLassyCountFile($)
{
	my $file = shift;
	my $normaliseDiacritics = shift;
	my $normaliseCase = shift;
	
	my $fh;
	if ($file ne "-") {
	   open($fh, '<', $file) or die;
	} else {
	   $fh = \*STDIN;
	}
	binmode $fh, ":utf8";

	return extractLassyCountFile($fh, $normaliseDiacritics, $normaliseCase);
}

sub filter($)
{
	my $output = shift;
	
	
	#$output =~ s/"//gi;
	$output =~ tr/"//d;
	
	
	return $output;
}

sub readPersistentLexicon($$$)
{
	my $fh = shift;
	my $normaliseDiacritics = shift;
	my $normaliseCase = shift;
	
	my @tlffCombinations;
	
	my ($tag, $lemma, $form, $frequency);
	
	while(<$fh>)
	{
		my $line = $_;
		
		unless($line =~ m/^#/g)
		{
			my @tlffLocal = split(/\s+/, $line);
			
			$tag = $tlffLocal[0];
			$lemma = normalise($tlffLocal[1], $normaliseDiacritics, $normaliseCase);
			$form = normalise($tlffLocal[2], $normaliseDiacritics, $normaliseCase);
			$frequency = $tlffLocal[3];
	
			push(@tlffCombinations, ($tag, $lemma, $form, $frequency));
		}
	}
	
	return @tlffCombinations;
}





sub writeTrainLexicon($$)
{
	my $lexiconFile = shift;
	my $tlffCombinationsRef = shift;
	my @tlffCombinations = @$tlffCombinationsRef;
	
	open OF, ">$lexiconFile" or die "Cannot open train lexicon output file $lexiconFile!\n";
	
	binmode OF, ":utf8";
	
	for(my $i = 0; $i < $#tlffCombinations; )
	{
		$tag = $tlffCombinations[$i++];
		$lemma = $tlffCombinations[$i++];
		$form = $tlffCombinations[$i++];
		$frequency = $tlffCombinations[$i++];
		
		print filter("$tag $lemma $form $frequency")."\n";
	}
	
	close OF;
}

sub writeWeightedTrainLexicon($$)
{
	my $fh = shift;
	my $tlffmCombinationsRef = shift;
	my @tlffmCombinations = @$tlffmCombinationsRef;
	
	for(my $i = 0; $i < $#tlffmCombinations; )
	{
		$tag = $tlffmCombinations[$i++];
		$lemma = $tlffmCombinations[$i++];
		$form = $tlffmCombinations[$i++];
		$frequency = $tlffmCombinations[$i++];
		$mass = $tlffmCombinations[$i++];
		
		print $fh filter("$tag $lemma $form $frequency $mass")."\n";
	}

}

sub writeLexicon($$)
{
	my $fh = shift;
	my $tlfCombinationsRef = shift;
	my @tlfCombinations = @$tlfCombinationsRef;
	
	my ($tag, $lemma, $form);
	
	for(my $i = 0; $i < $#tlfCombinations; )
	{
		$tag = $tlfCombinations[$i++];
		$lemma = $tlfCombinations[$i++];
		$form = $tlfCombinations[$i++];
		
		print $fh filter("$tag $lemma $form")."\n";
	}

}






sub readMassLexicon($$)
{
	my $massLexiconFile = shift;
	my $tlfWordRef = shift;
	my %tlfWord = %{$tlfWordRef};
	
	my %tlfMass = ();
	
	
	open IF, "$massLexiconFile" or die "Cannot open mass lexicon input file $massLexiconFile!\n";
	
	while(<IF>)
	{
		if($_ =~ m/^([^\(]+\(.*?\)) ([^\s]+) ([^\s]+) ([^\s]+) ([^\s]+)$/)
		{
			my $tag = $1;
			my $lemma = $2;
			my $word = $3;
			my $frequency = $4;
			my $mass = $5;
			
			if(exists($tlfMass{"$tag $lemma"}))
			{
				if($mass > $tlfMass{"$tag $lemma"})
				{
					$tlfMass{"$tag $lemma"} = $mass;
					$tlfWord{"$tag $lemma"} = $word;
				} 
			} else
			{
				$tlfMass{"$tag $lemma"} = $mass;
				$tlfWord{"$tag $lemma"} = $word;
			}
		}
	}
	
	close IF;
	
	return %tlfWord;
}











1;