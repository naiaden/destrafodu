declare -a eLex=(eLex.w2.t1 eLex.w2.t1.i eLex.w2.t1.d eLex.w2.t1.di eLex.w2.t3 eLex.w2.t3.i eLex.w2.t3.d eLex.w2.t3.di)
declare -a Lassy=(Lassy.w1.t1 Lassy.w1.t1.i Lassy.w1.t1.d Lassy.w1.t1.di Lassy.w1.t2 Lassy.w1.t2.i Lassy.w1.t2.d Lassy.w1.t2.di)

for i in ${eLex[@]}
do
   for j in ${Lassy[@]}
	do
		echo Machine learning-based experiment with $i and $j
		timbl -a 1 -t -t generated/$j.arff -f generated/$i.arff -F ARFF -o results/ml/ml.$i-$j.predictions
	done
done

for i in ${eLex[@]}
do
   for j in ${Lassy[@]}
	do
	echo Machine learning-based experiment with $i and $j
		perl destrafodu-fromarff.pl -iresults/ml/ml.$i-$j.predictions | perl destrafodu-analysis.pl -oresults/ml/ml.$i-$j.performance
		grep "[NAV]:" results/ml/ml.$i-$j.performance | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
	done
done

for i in ${eLex[@]}
do
   for j in ${Lassy[@]}
	do
	echo Machine learning-based experiment with $i and $j
		perl destrafodu-fromarff.pl -x -iresults/ml/ml.$i-$j.predictions | perl destrafodu-analysis.pl -oresults/ml/ml.$i-$j.performance
		grep "[NAV]:" results/ml/ml.$i-$j.performance | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
	done
done
