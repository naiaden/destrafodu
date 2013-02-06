use HTML::Entities;

our $lassyTagRegex = qr/^\s*<node.*?lemma=\"(.*?)\".*?postag=\"(.*?)\".*?word=\"(.*?)\".*?\/>$/;
our $elexTagRegex = qr/<pos>([^<]+)<\/pos>/;

sub extractLassyXMLFile
{
	
}

# returns a 4-tuple. If the first value is a zero, no valid TLF triple was found in the line.
# If the first value is a 1, then the second value is the converted tag, the third value the lemma, and the last value the form.
sub extractLassyXMLLine($)
{
	(my $lassyEntry) = @_;
	
	if($lassyEntry =~ $lassyTagRegex)
	{
		my $tag = $2;
		my $lemma = $1;
		my $form = $3;
		
		my $convertedTag = convertTag($tag);
		if($convertedTag)
		{
			return (1, $convertedTag, $lemma, $form);
		}	
	}
	
	return (0, "", "", "");
}

sub extractElexXMLFile ($)
{
	my $elexXMLFile = shift;
	
	my @tlffCombinations;
	
	open IF, '<:encoding(latin1)', "$elexXMLFile" or die "Cannot open elex input file $elexXMLFile!\n";
	
	my $lemma;
	my $form;
	my $freq;
	my $tag;
	
	while(<IF>)
	{
		my $line = $_;
		
		if($line =~ m/<lem>([^,]+)(,.*?)?<\/lem>/g)
		{
			$lemma = decode_entities($1);
		} elsif($line =~ m/<orth>([^<]+)<\/orth>/g)
		{
			$form = decode_entities($1);
		} elsif($line =~ m/<pos>([^<]+)<\/pos>/g)
		{
			$tag = convertTag($1);
		} elsif($line =~ m/<freq>([^<]+)<\/freq>/g)
		{
			$freq = $1;
		} elsif($line =~ m/<\/wordf>/g)
		{					
			if($tag ne 0)
			{
				push(@tlffCombinations, ($tag, $lemma, $form, $freq));
			}
		}
	}
	
	close IF;
	
	return @tlffCombinations;
}