sub convertTagFromElex($)
{
	($elexTag) = @_;

	if ( $elexTag =~ m/^N\((.*?)\)/g )
	{
		return convertNounTagFromElex($1);
	}
	elsif ( $elexTag =~ m/^WW\((.*?)\)/g )
	{
		return convertVerbTagFromElex($1);
	}
	elsif ( $elexTag =~ m/^ADJ\((.*?)\)/g )
	{
		return convertAdjectiveTagFromElex($1);
	}
	
	#print STDERR "$elexTag is not supported (currently only N, V, and Adjv are supported)\n";
	return 0;
}

sub convertAdjectiveTagFromElex($)
{
	($subtag) = @_;

	my $degree;
	my $conj;

	# postnom, prenom, and vrij|dim are not included
	if ( $subtag eq "prenom,basis,met-e,bijz" ) 
	{
		$conj   = "e";
		$degree = "pos";
	}
	elsif ( $subtag eq "prenom,basis,met-e,stan" )
	{
		$conj   = "e";
		$degree = "pos";
	}
	elsif ( $subtag eq "prenom,basis,zonder" )
	{
		$conj   = "norm";
		$degree = "pos";
	}
	elsif ( $subtag eq "prenom,comp,met-e,stan" )
	{
		$conj   = "e";
		$degree = "comp";
	}
	elsif ( $subtag eq "prenom,comp,zonder" )
	{
		$conj   = "norm";
		$degree = "comp";
	}
	elsif ( $subtag eq "prenom,sup,met-e,stan" )
	{
		$conj   = "e";
		$degree = "sup";
	}

	# currently not supported, 2621 occurrences in elex however
	#if($subtag eq "postnom,basis,met-s")
	#   { $conj = "en"; $degree = "pos"; }
	elsif ( $subtag eq "postnom,basis,zonder" )
	{
		$conj   = "norm";
		$degree = "pos";
	}

	# idem, with 33 occurrences
	#if($subtag eq "postnom,comp,met-s")
	#   { $conj = "en"; $degree = "comp"; }
	elsif ( $subtag eq "postnom,comp,zonder" )
	{
		$conj   = "norm";
		$degree = "comp";
	}

	elsif ( $subtag eq "nom,basis,met-e,mv-n" )
	{
		$conj   = "en";
		$degree = "pos";
	}

	#if($subtag eq "nom,basis,met-e,zonder-n,bijz")
	#   { $conj = "en"; $degree = "pos"; }
	elsif ( $subtag eq "nom,basis,met-e,zonder-n,stan" )
	{
		$conj   = "e";
		$degree = "pos";
	}
	elsif ( $subtag eq "nom,basis,zonder,mv-n" )    #
	{
		$conj   = "en";
		$degree = "pos";
	}
	elsif ( $subtag eq "nom,basis,zonder,zonder-n" )
	{
		$conj   = "norm";
		$degree = "pos";
	}
	elsif ( $subtag eq "nom,comp,met-e,mv-n" )
	{
		$conj   = "en";
		$degree = "comp";
	}
	elsif ( $subtag eq "nom,comp,met-e,zonder-n,stan" )
	{
		$conj   = "e";
		$degree = "comp";
	}
	elsif ( $subtag eq "nom,comp,zonder,zonder-n" )
	{
		$conj   = "norm";
		$degree = "comp";
	}
	elsif ( $subtag eq "nom,sup,met-e,mv-n" ) 
	{ 
		$conj = "e"; 
		$degree = "sup"; 
	}
	elsif ( $subtag eq "nom,sup,met-e,zonder-n,stan" )
	{
		$conj   = "e";
		$degree = "sup";
	}
	elsif ( $subtag eq "nom,sup,zonder,zonder-n" )
	{
		$conj   = "norm";
		$degree = "sup";
	}
	elsif ( $subtag eq "vrij,basis,zonder" ) {
		$conj   = "norm";
		$degree = "pos";
	}
	elsif ( $subtag eq "vrij,comp,zonder" ) {
		$conj   = "norm";
		$degree = "comp";
	}
	elsif ( $subtag eq "vrij,sup,zonder" ) 
	{ 
		$conj = "norm"; 
		$degree = "sup"; 
	}

	if ( $degree && $conj )
	{
		return "Adjv(deg=$degree,form=$conj)";
	}

	#print STDERR "No conversion for Adjv($subtag)\n";
	return 0;
}

sub convertNounTagFromElex($)
{
	($subtag) = @_;

	my @subtags = split( ',', $subtag );

	my $dim = "norm";
	my $num;
	my $case = "nom";

	foreach my $st (@subtags)
	{
		if ( $st eq "dim" ) { $dim = "dim"; }

		elsif ( $st eq "ev" ) { $num = "sing"; }
		elsif ( $st eq "mv" ) { $num = "plu"; }

		elsif ( $st eq "dat" )   { $case = "dat"; }
		elsif ( $st eq "genus" ) { $case = "gen"; }
		elsif ( $st eq "gen" )   { $case = "gen"; }
	}

	if ($num)
	{
		return "N(dim=$dim,num=$num,case=$case)";
	}

	#print STDERR "No conversion for N($subtag)\n";
	return 0;
}

sub convertVerbTagFromElex($)
{
	($subtag) = @_;

	my $fin;
	my $tense;
	my $form;
	my $num;

	# Section 2.3 of the PART OF SPEECH TAGGING EN LEMMATISERING
	# VAN HET CORPUS GESPROKEN NEDERLANDS - Frank van Eynde
	if ( $subtag eq "pv,tgw,ev" )
	{
		$fin   = "fin";
		$tense = "pres";
		$num   = "sing";
		$form  = "norm";
	}
	if ( $subtag eq "pv,tgw,met-t" )
	{
		$fin   = "fin";
		$tense = "pres";
		$num   = "sing";
		$form  = "t";
	}
	if ( $subtag eq "pv,tgw,mv" )
	{
		$fin   = "fin";
		$tense = "pres";
		$num   = "plu";
		$form  = "norm";
	}
	if ( $subtag eq "pv,verl,ev" )
	{
		$fin   = "fin";
		$tense = "past";
		$num   = "sing";
		$form  = "norm";
	}
	if ( $subtag eq "pv,verl,met-t" )
	{
		$fin   = "fin";
		$tense = "past";
		$num   = "sing";
		$form  = "t";
	}
	if ( $subtag eq "pv,verl,mv" )
	{
		$fin   = "fin";
		$tense = "past";
		$num   = "plu";
		$form  = "norm";
	}

	if ( $subtag eq "vd,nom,met-e,mv-n" )
	{
		$fin   = "part";
		$tense = "past";
		$form  = "en";
	}
	if ( $subtag eq "vd,nom,met-e,zonder-n" )
	{
		$fin   = "part";
		$tense = "past";
		$form  = "e";
	}
	if ( $subtag eq "vd,prenom,met-e" )
	{
		$fin   = "part";
		$tense = "past";
		$form  = "e";
	}
	if ( $subtag eq "vd,prenom,zonder" )
	{
		$fin   = "part";
		$tense = "past";
		$form  = "norm";
	}
	if ( $subtag eq "vd,vrij,zonder" )
	{
		$fin   = "part";
		$tense = "past";
		$form  = "norm";
	}

	if ( $subtag eq "od,nom,met-e,mv-n" )
	{
		$fin   = "part";
		$tense = "pres";
		$form  = "en";
	}
	if ( $subtag eq "od,nom,met-e,zonder-n" )
	{
		$fin   = "part";
		$tense = "pres";
		$form  = "e";
	}
	if ( $subtag eq "od,prenom,met-e" )
	{
		$fin   = "part";
		$tense = "pres";
		$form  = "e";
	}
	if ( $subtag eq "od,prenom,zonder" )
	{
		$fin   = "part";
		$tense = "pres";
		$form  = "norm";
	}
	if ( $subtag eq "od,vrij,zonder" )
	{
		$fin   = "part";
		$tense = "pres";
		$form  = "norm";
	}

	if ( $subtag eq "inf,vrij,zonder" )
	{
		$fin  = "infin";
		$form = "norm";
	}

	#if($subtag eq "inf,vrij,zonder,dial")
	# { $fin = "infin"; $form = "norm"; }

	if ($fin)
	{

		# Only normal form for infinitive is supported by the delemmatiser
		if ( $fin eq "infin" && $form )
		{
			return "V(fin=$fin,form=$form)";
		}
		elsif ( $fin eq "fin" && $tense && $num && $form )
		{
			return "V(fin=$fin,tense=$tense,num=$num,form=$form)";
		}
		elsif ( $fin eq "part" && $tense && $form )
		{
			return "V(fin=$fin,tense=$tense,form=$form)";
		}
	}

	#print STDERR "No conversion for V($subtag)\n";
	return 0;
}

1;
