sub generateTypes
{
	my $lexiconRef = shift;
	my @lexicon = @$lexiconRef;
	
	my @typeLexicon;
	
	foreach(@lexicon)
	{
		my $entry = $_;
		my ($tag, $lemma, $form, $frequency) = $entry;
		
		push(@typeLexicon, ($tag, $lemma, $form));
	}
	
	return @typeLexicon;
}

sub generateTokens
{
	my $lexiconRef = shift;
	my @lexicon = @$lexiconRef;
	
	my @tokenLexicon;
	
	foreach(@lexicon)
	{
		my $entry = $_;
		my ($tag, $lemma, $form, $frequency) = $entry;
		
		for(1..$frequency)
		{
			push(@tokenLexicon, ($tag, $lemma, $form));
		}
	}
	
	return @tokenLexicon;
}

sub generateMassTokens
{
	
}