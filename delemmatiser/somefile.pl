# Applies a diff to a word. The diff must be of the form:
#   -[remove at front].[remove at end] +[add to front].[add to end]
# The brackets denote optionality, the most basic form is thus -. +.
# For example:
#   applyExtDiff("proberen", "-. +.") -> "proberen"
#   applyExtDiff("proberen", "-prob.en +felicite.de") -> "feliciteerde"
#   applyExtDiff("proberen", "-.proberen +.test") -> "test"
sub applyExtDifff
{
	my $word = shift;
	my $diff = shift;

	if($diff =~ m/^-([^\.]*)\.([^\s]*) \+([^\.]*)\.([^\s]*)/)
	{	
		my $sub = substr($word, length($1), length($word));
		return $3.substr($sub, 0, length($sub)-length($2)).$4;
	}
	
	warn("Trying to apply unvalid diff ($diff) on word ($word)\n"); 
	return undef;
}

1;