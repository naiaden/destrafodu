sub generateDumbTypes
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
		
		push(@tokenLexicon, ($tag, $lemma, $form));
	}
	
	return @tokenLexicon;
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
	my @lexicon = @$lexiconRef;
	
	my @tokenLexicon;
	
	for(my $i = 0; $i < $#lexicon; )
	{
		my $tag = $lexicon[$i++];
		my $lemma = $lexicon[$i++];
		my $form = $lexicon[$i++];
		my $frequency = $lexicon[$i++];
		my $mass = $lexicon[$i++];
		
		my $rounded = int((10*$mass) + 0.5);
		
		for(1..$rounded)
		{
			push(@tokenLexicon, ($tag, $lemma, $form));
		}
	}
	
	return @tokenLexicon;
}

1;