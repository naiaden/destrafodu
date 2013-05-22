declare -a eLex=(eLex.w2.t1 eLex.w2.t1.i eLex.w2.t1.d eLex.w2.t1.di)
declare -a Lassy=(Lassy.w1.t1 Lassy.w1.t1.i Lassy.w1.t1.d Lassy.w1.t1.di Lassy.w1.t2 Lassy.w1.t2.i Lassy.w1.t2.d Lassy.w1.t2.di)

for i in ${eLex[@]}
do
   for j in ${Lassy[@]}
	do
		echo Lexicon-based LEXu experiment with $i and $j
		perl destrafodu-lex.pl -mgenerated/$i.rm -igenerated/$j.lexicon | tee results/lex/u/LEXu.$i-$j.predictions | perl destrafodu-analysis.pl -oresults/lex/u/LEXu.$i-$j.performance
		grep "[NAV]:" results/lex/u/LEXu.$i-$j.performance | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
	done
done

for i in ${eLex[@]}
do
   for j in ${Lassy[@]}
	do
		echo Lexicon-based LEXl experiment with $i and $j
		perl destrafodu-lex.pl -mgenerated/$i.rm -igenerated/$j.lexicon -l | tee results/lex/l/LEXl.$i-$j.predictions | perl destrafodu-analysis.pl -oresults/lex/l/LEXl.$i-$j.performance
		grep "[NAV]:" results/lex/l/LEXl.$i-$j.performance | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
	done
done

echo Now experiments on eLex.w2.t1 and Lassy.w1.t2 with different analysis normalisation options
echo No normalisation
perl destrafodu-lex.pl -mgenerated/eLex.w2.t1.rm -igenerated/Lassy.w1.t2.lexicon -l | perl destrafodu-analysis.pl | grep "[NAV]:" | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
echo Lowercase conversion
perl destrafodu-lex.pl -mgenerated/eLex.w2.t1.rm -igenerated/Lassy.w1.t2.lexicon -l | perl destrafodu-analysis.pl -i | grep "[NAV]:" | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
echo Diacritics normalisation
perl destrafodu-lex.pl -mgenerated/eLex.w2.t1.rm -igenerated/Lassy.w1.t2.lexicon -l | perl destrafodu-analysis.pl -d | grep "[NAV]:" | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
echo Both lowercase and diacritics normalisation
perl destrafodu-lex.pl -mgenerated/eLex.w2.t1.rm -igenerated/Lassy.w1.t2.lexicon -l | perl destrafodu-analysis.pl -d -i | grep "[NAV]:" | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
