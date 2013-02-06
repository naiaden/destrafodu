use Acme::Comment type => 'C++';
use HTML::Entities;
use File::Find::Rule ;

our $lassyTagRegex = qr/^\s*<node.*?lemma=\"(.*?)\".*?postag=\"(.*?)\".*?word=\"(.*?)\".*?\/>$/;
our $elexTagRegex = qr/<pos>([^<]+)<\/pos>/;

sub extractLassyXMLDirectory($)
{
	my $path = shift;
	
	my $ffr_obj = File::Find::Rule->file()
                                  ->name( "*.xml" )
                                  ->start ( $path );

	my @tlfCombinations;

    while (my $file = $ffr_obj->match() )
    {
       @tlfCombinations = extractLassyXMLFileAdditive($file, \@tlfCombinations);
    }
    
    return @tlfCombinations;
}

sub extractLassyXMLFileAdditive($$)
{
	my $lassyXMLFile = shift;
	my $tlfCombinationsRef = shift;
	my @tlfCombinations = @$tlfCombinationsRef;
	
	open IF, "$lassyXMLFile" or die "Cannot open lassy input file $lassyXMLFile!\n";
	
	my $lemma;
	my $form;
	my $tag;
	
	while(<IF>)
	{
		my $result = 0;
		($result, $tag, $lemma, $form) = extractLassyXMLLine($_);
		
		if($result ne 0)
		{
			push(@tlfCombinations, ($tag, $lemma, $form));
		}
			
	}
	
	close IF;
	
	return @tlfCombinations;
}

sub extractLassyXMLFile($)
{
	my $lassyXMLFile = shift;
	my @tlfCombinations;
	return extractLassyXMLFileAdditive($lassyXMLFile, \@tlfCombinations);
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