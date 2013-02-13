sub generateTypes
{
	my $lexiconRef = shift;
	my @lexicon = @$lexiconRef;

	my %hash;
	
	for(my $i = 0; $i < $#lexicon; )
	{
		my $tag = $lexicon[$i++];
		my $lemma = $lexicon[$i++];
		my $form = $lexicon[$i++];
		my $frequency = $lexicon[$i++];
		my $mass = $lexicon[$i++];
		
		$hash{"$tag $lemma $form"}++;
	}
	
	my @unique;
	
	foreach(keys %hash)
	{
		if($_ =~ m/^([^ ]+) ([^ ]+) ([^ ]+)$/g)
		{
			push(@unique, ($1, $2, $3));
		}
	}

	return @unique;
}

sub generateTokens
{
	my $lexiconRef = shift;
	my @lexicon = @$lexiconRef;
	
	my @tokenLexicon;
	
	for(my $i = 0; $i < $#lexicon; )
	{
		my $tag = $lexicon[$i++];
		my $lemma = $lexicon[$i++];
		my $form = $lexicon[$i++];
		my $frequency = $lexicon[$i++];
		my $mass = $lexicon[$i++];
		
		if($frequency == 0)
		{
			print STDERR ">>> freq0: $tag $lemma $form\n";
		}
		
		for(1..$frequency)
		{
			push(@tokenLexicon, ($tag, $lemma, $form));
		}
	}
	
	return @tokenLexicon;
}

sub generateMassTokens
{
	my $lexiconRef = shift;
	my $tlfSize = shift;
	
	
	my @lexicon = @$lexiconRef;
	
	my @tokenLexicon;
	
	for(my $i = 0; $i < $#lexicon; )
	{
		my $tag = $lexicon[$i++];
		my $lemma = $lexicon[$i++];
		my $form = $lexicon[$i++];
		my $frequency = $lexicon[$i++];
		my $mass = $lexicon[$i++];
		
		my $rounded = int(($tlfSize*$mass) + 0.5);
		
		for(1..$rounded)
		{
			push(@tokenLexicon, ($tag, $lemma, $form));
		}
	}
	
	return @tokenLexicon;
}

1;