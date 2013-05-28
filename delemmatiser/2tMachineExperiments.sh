declare -a eLex=(eLex.w2.t1 eLex.w2.t1.i eLex.w2.t1.d eLex.w2.t1.di eLex.w2.t3 eLex.w2.t3.i eLex.w2.t3.d eLex.w2.t3.di)
declare -a Lassy=(Lassy.w1.t1 Lassy.w1.t1.i Lassy.w1.t1.d Lassy.w1.t1.di Lassy.w1.t2 Lassy.w1.t2.i Lassy.w1.t2.d Lassy.w1.t2.di)

for i in ${eLex[@]}
do
   for j in ${Lassy[@]}
	do
		echo "Machine learning-based experiment with $i and $j --- First tier"
		# tier 1
		#timbl -a 1 -t generated/$j.arff -f generated/$i.arff -F ARFF -o results/ml/ml.$i-$j.predictions
	done
done

for i in ${eLex[@]}
do
   for j in ${Lassy[@]}
	do
	echo "Machine learning-based experiment with $i and $j --- Second tier"
	
	perl destrafodu-fromarff.pl -x -iresults/ml/ml.$i-$j.predictions | tee results/ml/ml.$i-$j.forms | grep "???" | awk '{print $1, $2, $3}' > results/ml/ml.$i-$j.unknowns.lexicon
	perl destrafodu-toarff.pl -p/home/louis/p1/delemmatiser/data/particles.txt -iresults/ml/ml.$i-$j.unknowns.lexicon -oresults/ml/ml.$i-$j.unknowns.arff
	# tier 2
	timbl -a 0 -k 2 -t results/ml/ml.$i-$j.unknowns.arff -f generated/$i.arff -F ARFF -o results/ml/ml.$i-$j.unknowns.predictions
	perl destrafodu-fromarff.pl -iresults/ml/ml.$i-$j.unknowns.predictions -oresults/ml/ml.$i-$j.unknowns.forms
	
	cat results/ml/ml.$i-$j.unknowns.forms > results/ml/ml.$i-$j.tier2.forms
	grep -v "???" results/ml/ml.$i-$j.forms >> results/ml/ml.$i-$j.tier2.forms
	
		perl destrafodu-analysis.pl -presults/ml/ml.$i-$j.tier2.forms -oresults/ml/ml.$i-$j.tier2.performance
	done
done

for i in ${eLex[@]}
do
   for j in ${Lassy[@]}
	do
	echo "Machine learning-based experiment with $i and $j --- Second tier"
		grep "[NAV]:" results/ml/ml.$i-$j.tier2.performance | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
	done
done


