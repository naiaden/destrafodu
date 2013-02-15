
use Acme::Comment type => 'C++';
use HTML::Entities;
use File::Find::Rule;
use Unicode::Normalize;
use Encode;

require 'TagConverter.pl';

binmode STDIN, ":utf8";

our $lassyTagRegex =
  qr/^\s*<node.*?lemma=\"(.*?)\".*?postag=\"(.*?)\".*?word=\"(.*?)\".*?\/>$/;
our $elexTagRegex = qr/<pos>([^<]+)<\/pos>/;

sub normalise($$$)
{
	my $str                 = shift;
	my $normaliseDiacritics = shift;
	my $normaliseCase       = shift;

	$str =~ s/,/_/g;

	if ($normaliseDiacritics)
	{
		for ($str)
		{  
			$_ = NFD($_);       
			s/\pM//g;          
			s/[^\0-\x80]//g;
		}
	}

	if ($normaliseCase)
	{
		$str = lc($str);
	}
	return $str;
}

sub extractLassyXMLDirectory($)
{
	my $path = shift;

	my $ffr_obj = File::Find::Rule->file()->name("*.xml")->start($path);

	my @tlfCombinations;

	while ( my $file = $ffr_obj->match() )
	{
		print "Processing $file\n";
		@tlfCombinations =
		  extractLassyXMLFileAdditive( $file, \@tlfCombinations );
	}

	return @tlfCombinations;
}

sub extractLassyXMLFileAdditive($$)
{
	my $lassyXMLFile       = shift;
	my $tlfCombinationsRef = shift;
	my @tlfCombinations    = @$tlfCombinationsRef;

	open IF, "$lassyXMLFile"
	  or die "Cannot open lassy input file $lassyXMLFile!\n";

	my $lemma;
	my $form;
	my $tag;

	while (<IF>)
	{
		my $result = 0;
		( $result, $tag, $lemma, $form ) = extractLassyXMLLine($_);

		if ( $result ne 0 )
		{
			push( @tlfCombinations, ( $tag, $lemma, $form ) );
		}
	}

	close IF;

	return @tlfCombinations;
}

sub extractLassyXMLFile($)
{
	my $lassyXMLFile = shift;
	my @tlfCombinations;
	return extractLassyXMLFileAdditive( $lassyXMLFile, \@tlfCombinations );
}

# returns a 4-tuple. If the first value is a zero, no valid TLF triple was found in the line.
# If the first value is a 1, then the second value is the converted tag, the third value the lemma, and the last value the form.
sub extractLassyXMLLine($)
{
	( my $lassyEntry ) = @_;

	if ( $lassyEntry =~ $lassyTagRegex )
	{
		my $tag   = $2;
		my $lemma = $1;
		my $form  = $3;

		my $convertedTag = convertTag($tag);
		if ($convertedTag)
		{
			return ( 1, $convertedTag, $lemma, $form );
		}
	}

	return ( 0, "", "", "" );
}

sub extractLassyCountFile ($$$)
{
	my $fh                  = shift;
	my $normaliseDiacritics = shift;
	my $normaliseCase       = shift;

	my @tlffCombinations;

	my $lemma;
	my $form;
	my $tag;

	while (<$fh>)
	{
		my $line = $_;

		if ( $line =~ m/\s+(\d+) ([^ ]+) ([^ ]+) ([^ ]+)$/g )
		{
			my $frequency = $1;
			$lemma = normalise( $3, $normaliseDiacritics, $normaliseCase );
			$form  = normalise( $2, $normaliseDiacritics, $normaliseCase );
			$tag   = $4;

			my $convertedTag = convertTag($tag);
			if ($convertedTag)
			{

				#for(1 .. $frequency)
				#{
				#	push(@tlfCombinations, ($convertedTag, $lemma, $form));
				#}

				push( @tlffCombinations,
					  ( $convertedTag, $lemma, $form, $frequency ) );
			}

		}
	}

	return @tlffCombinations;
}

sub extractElexXMLFile ($$$)
{
	my $fh                  = shift;
	my $normaliseDiacritics = shift;
	my $normaliseCase       = shift;

	my @tlffCombinations;

	my $lemma;
	my $form;
	my $freq;
	my $tag;

	my $i = 0;

	while (<$fh>)
	{
		my $line = $_;

		if ( $line =~ m/<lem>([^,]+)(,.*?)?<\/lem>/g )
		{
			$lemma =
			  normalise( decode_entities($1), $normaliseDiacritics,
						 $normaliseCase );
		}
		elsif ( $line =~ m/<orth>([^<]+)<\/orth>/g )
		{
			$form =
			  normalise( decode_entities($1), $normaliseDiacritics,
						 $normaliseCase );
		}
		elsif ( $line =~ m/<pos>([^<]+)<\/pos>/g )
		{
			$tag = convertTag($1);
		}
		elsif ( $line =~ m/<freq>([^<]+)<\/freq>/g )
		{
			$freq = $1;
		}
		elsif ( $line =~ m/<\/wordf>/g )
		{
			if ( $tag ne 0 )
			{
				push( @tlffCombinations, ( $tag, $lemma, $form, $freq ) );
			}
		}
	}

	return @tlffCombinations;
}
