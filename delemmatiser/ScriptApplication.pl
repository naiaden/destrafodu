use Acme::Comment type => 'C++';

# Applies a diff to a word. The diff must be of the form:
#   -[remove at front].[remove at end] +[add to front].[add to end]
# The brackets denote optionality, the most basic form is thus -. +.
# For example:
#   applyExtDifff("proberen", "-. +.") -> "proberen"
#   applyExtDifff("proberen", "-prob.en +felicite.de") -> "feliciteerde"
#   applyExtDifff("proberen", "-.proberen +.test") -> "test"
sub applyExtDifff
{
	my $word = shift;
	my $diff = shift;

	if ( $diff =~ m/^-([^\.]*)\.([^\s]*) \+([^\.]*)\.([^\s]*)/ )
	{
		my $sub = substr( $word, length($1), length($word) );
		return $3 . substr( $sub, 0, length($sub) - length($2) ) . $4;
	}

	warn("Trying to apply unvalid diff ($diff) on word ($word)\n");
	return undef;
}

# Applies a diff to a word. The diff must be of the form:
#   -[remove at front].[remove at end] +[add to front].[add to end]
# The brackets denote optionality, the most basic form is thus -. +.
# If the part to be removed does not occur in the original word, an "empty"
# word is returned: "???". 
# For example:
#   applyExtDifffIfPossible("proberen", "-. +.") -> "proberen"
#   applyExtDifffIfPossible("proberen", "-prob.en +felicite.de") -> "feliciteerde"
#   applyExtDifffIfPossible("proberen", "-.proberen +.test") -> "test"
#   applyExtDifffIfPossible("proberen", "-po.en +po.de") -> "???"
sub applyExtDifffIfPossible
{
	my $word = shift;
	my $diff = shift;

	if ( $diff =~ m/^-([^\.]*)\.([^\s]*) \+([^\.]*)\.([^\s]*)/ )
	{
			#print "\t1:[$1], 2:[$2], 3:[$3], 4:[$4]\n";
			
			my $removeBefore = $1;
			my $removeAfter = $2;
			my $addBefore = $3;
			my $addAfter = $4;
			
			if(length($removeBefore) + length($removeAfter) > length($word))
			{
				return "???";
			}
			
			if($removeBefore ne "")
			{
				#print length($removeBefore)."\n";
				#print substr($word, 0, length($removeBefore))."\n";
				if(substr($word, 0, length($removeBefore)) ne $removeBefore)
				{
					return "???";
				}
			}
			
			if($removeAfter ne "")
			{
				#print length($removeAfter)."\n";
				#print substr($word, length($word)-length($removeAfter), length($word))."\n";
				if(substr($word, length($word)-length($removeAfter), length($word)) ne $removeAfter)
				{
					return "???";
				}
			}
			
			
		my $sub = substr( $word, length($1), length($word) );
			#print "\t$sub\n";
		return $3 . substr( $sub, 0, length($sub) - length($2) ) . $4;
	}

	warn("Trying to apply unvalid diff ($diff) on word ($word)\n");
	return undef;
}

/*
print "proberen =?= ".applyExtDifffIfPossible("proberen", "-. +.")."\n";
print "feliciteerde =?= ".applyExtDifffIfPossible("proberen", "-prob.en +felicite.de")."\n";
print "test =?= ".applyExtDifffIfPossible("proberen", "-.proberen +.test")."\n";
print "??? =?= ".applyExtDifffIfPossible("proberen", "-po.en +po.de")."\n";
print "??? =?= ".applyExtDifffIfPossible("proberen", "-pro.dn +po.de")."\n";
print "??? =?= ".applyExtDifffIfPossible("proberen", "-pro .en +po.de")."\n";
print "pode =?= ".applyExtDifffIfPossible("proberen", "-pro.beren +po.de")."\n";
print "probeerde =?= ".applyExtDifffIfPossible("proberen", "-prob.eren +probe.erde")."\n";
print "??? =?= ".applyExtDifffIfPossible("proberen", "-probe.eren +probe.erde")."\n";
print "??? =?= ".applyExtDifffIfPossible("proberen", "-proe.eren +probe.erde")."\n";
print "probeerde =?= ".applyExtDifffIfPossible("proberen", "-prob.ren +probe.rde")."\n";
print "proberenrde =?= ".applyExtDifffIfPossible("proberen", "-. +.rde")."\n";
print "??? =?= ".applyExtDifffIfPossible("proberen", "-doemaarzo. +.rde")."\n";
print "??? =?= ".applyExtDifffIfPossible("proberen", "-.doemaarzo +.rde")."\n";
*/

1;
