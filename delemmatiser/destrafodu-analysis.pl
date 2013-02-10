
use Acme::Comment type => 'C++';
use Getopt::Std;

use strict;

use strict;

binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";

use vars qw( $opt_i );
getopts( 'i' );


my %tagTotal;
my %tagError;

while(<STDIN>)
{
	if($_ =~ m/^([^\(]+\(.*?\)) ([^\s]+) ([^\s]+) ([^\s]+)$/)
	{
		my $tag = $1;
		my $lemma = $2;
		my $word = $3;
		my $output = $4;
		
		
		if($opt_i)
		{
			unless(uc($word) eq uc($output))
			{
				$tagError{$tag} += 1;
			}
		} else
		{
			unless($word eq $output)
			{
				$tagError{$tag} += 1;
			}
		}
		$tagTotal{$tag} += 1;
	}
}

my $nError = 0;
my $nTotal = 0;
my $vError = 0;
my $vTotal = 0;
my $adjvError = 0;
my $adjvTotal = 0;
my $total = 0;
my $totalError = 0;
foreach my $key (keys %tagTotal)
{
	$totalError += $tagError{$key};
	$total += $tagTotal{$key};
	if($key =~ m/^N\(/)
	{
		$nError += $tagError{$key};
		$nTotal += $tagTotal{$key};
	} elsif($key =~ m/^V\(/)
	{
		$vError += $tagError{$key};
		$vTotal += $tagTotal{$key};
	} elsif($key =~ m/^Adjv\(/)
	{
		$adjvError += $tagError{$key};
		$adjvTotal += $tagTotal{$key};
	}
}

printf("Overall performance:\n");
printf("\tN: %.6f (%d/%d)\n", ($nTotal-$nError)/$nTotal, ($nTotal-$nError), $nTotal);
printf("\tV: %.6f (%d/%d)\n", ($vTotal-$vError)/$vTotal, ($vTotal-$vError), $vTotal);
printf("\tA: %.6f (%d/%d)\n", ($adjvTotal-$adjvError)/$adjvTotal, ($adjvTotal-$adjvError), $adjvTotal);
printf("\n");
printf("Performance per tag:\n");
printf("\tTag\t\t\t\tErrors per tag/\tPercentage  Percentage\n");
printf("\t\t\t\t\ttag occurences\tper tag\t    of total\n");

foreach my $key (sort keys %tagTotal)
{
	if($key =~ m/^N\(/)
	{
		my $e1 = sprintf("%d/%d", $tagError{$key}, $tagTotal{$key});
		my $e2 = sprintf("%.2f", $tagError{$key}/$tagTotal{$key}*100);
		printf("\t%-32s%-16s%-12s%f\n", $key, $e1, $e2, $tagError{$key}/$total*100);
	}
}
printf("\n");
foreach my $key (sort keys %tagTotal)
{
	if($key =~ m/^V\(/)
	{
		my $e1 = sprintf("%d/%d", $tagError{$key}, $tagTotal{$key});
		my $e2 = sprintf("%.2f", $tagError{$key}/$tagTotal{$key}*100);
		printf("\t%-32s%-16s%-12s%f\n", $key, $e1, $e2, $tagError{$key}/$total*100);
	}
}
printf("\n");
foreach my $key (sort keys %tagTotal)
{
	if($key =~ m/^Adjv\(/)
	{
		my $e1 = sprintf("%d/%d", $tagError{$key}, $tagTotal{$key});
		my $e2 = sprintf("%.2f", $tagError{$key}/$tagTotal{$key}*100);
		printf("\t%-32s%-16s%-12s%f\n", $key, $e1, $e2, $tagError{$key}/$total*100);
	}
}