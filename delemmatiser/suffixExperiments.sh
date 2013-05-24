train=eLex.w2.t1.di
test=Lassy.w1.t1.di

for i in $(seq 40)
do
	echo Preparing suffix experiment for suffix length $i
	echo -ne train...
	perl destrafodu-toarff.pl -s $i -p/home/louis/p1/delemmatiser/data/particles.txt -igenerated/$train.lexicon -ogenerated/suffix/$train-$i.arff
	echo done!
	
	echo -ne test
	perl destrafodu-toarff.pl -s $i -p/home/louis/p1/delemmatiser/data/particles.txt -igenerated/$test.lexicon -ogenerated/suffix/$test-$i.arff
	echo done!
	
	timbl -a 1 -t generated/suffix/$test-$i.arff -f generated/suffix/$train-$i.arff -F ARFF -o results/suffix/$train-$test-$i.predictions
done

for i in $(seq 40)
do
	echo Suffix experiment for suffix length $i
	perl destrafodu-fromarff.pl -iresults/suffix/$train-$test-$i.predictions | perl destrafodu-analysis.pl | grep "[NAV]:" | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
done
