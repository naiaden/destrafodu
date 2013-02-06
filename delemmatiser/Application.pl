
# hoi

require 'TagConverter.pl';

print convertTagFromElex("N(soort,ev,basis,zijd,stan)")."\n";
print convertTagFromElex("ADJ(nom,basis,met-e,zonder-n,stan)")."\n";
print convertTagFromElex("WW(inf,nom,zonder,zonder-n)")."\n";
print convertTagFromElex("bollocks")."\n";

open IF, "/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml" or die "Cannot open elex\n";
while(<IF>)
{
	my $line = $_;
	
	
	if($line =~ m/<pos>([^<]+)<\/pos>/g)
	{
		my $convertedTag = convertTagFromElex($1);
		if($convertedTag)
		{
			print "$convertedTag\n";
		}
	}
}