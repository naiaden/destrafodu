# type type
train=eLex.w2.t1.di
test=Lassy.w1.t1.di

# token token
#echo Suffix experiment for token token
#train=eLex.w2.t2.di
#test=Lassy.w1.t2.di

maxrange=40

for i in $(seq $maxrange)
do
	echo Preparing suffix experiment for suffix length $i
	echo -ne train...
	perl destrafodu-toarff.pl -s $i -f $maxrange -p/home/louis/p1/delemmatiser/data/particles.txt -igenerated/$train.lexicon -ogenerated/suffix/$train-$i-$maxrange.arff
	echo done!
	
	echo -ne test
	perl destrafodu-toarff.pl -s $i -f $maxrange -p/home/louis/p1/delemmatiser/data/particles.txt -igenerated/$test.lexicon -ogenerated/suffix/$test-$i-$maxrange.arff
	echo done!
	
	timbl -a 1 -f generated/suffix/$train-$i-$maxrange.arff -t generated/suffix/$test-$i-$maxrange.arff -F ARFF -o results/suffix/$train-$test-$i-$maxrange.predictions

	perl destrafodu-fromarff-ext.pl -tgenerated/$test.lexicon -iresults/suffix/$train-$test-$i-$maxrange.predictions | perl destrafodu-analysis.pl 

done

for i in $(seq $maxrange)
do
	#echo "==================== $i ===================="
	#perl destrafodu-fromarff-ext.pl -tgenerated/$test.lexicon -iresults/suffix/$train-$test-$i-$maxrange.predictions | perl destrafodu-analysis.pl 
	#perl destrafodu-fromarff-ext.pl -tgenerated/$test.lexicon -iresults/suffix/$train-$test-$i-$maxrange.predictions | perl destrafodu-analysis.pl | grep "[NAV]:" | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
	perl destrafodu-fromarff-ext.pl -d -x -tgenerated/$test.lexicon -iresults/suffix/$train-$test-$i-$maxrange.predictions -oresults/suffix/$train-$test-$i-$maxrange.forms 
done


#for i in $(seq 3)
#do
#	echo Suffix experiment for suffix length $i
#	perl destrafodu-fromarff-ext.pl -d -tgenerated/$train.lexicon -iresults/suffix/$train-$test-$i-$maxrange.predictions -oresults/suffix/$train-$test-$i-$maxrange.forms
#	
#	perl destrafodu-fromarff-ext.pl -tgenerated/$test.lexicon -iresults/suffix/$train-$test-1-$maxrange.predictions | perl destrafodu-analysis.pl | grep "[NAV]:" | sed 's/^[ \t]*//' | sed 's/(\(.*\))$//' | sed -e :a -e '$!N; s/\n/ /; ta'
#done
