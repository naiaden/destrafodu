declare -a inputFiles=(eLex.w2.t1 eLex.w2.t1.i eLex.w2.t1.d eLex.w2.t1.di eLex.w2.t3 eLex.w2.t3.i eLex.w2.t3.d eLex.w2.t3.di Lassy.w1.t1 Lassy.w1.t1.i Lassy.w1.t1.d Lassy.w1.t1.di Lassy.w1.t2 Lassy.w1.t2.i Lassy.w1.t2.d Lassy.w1.t2.di)

for i in ${inputFiles[@]}
do
	echo "Generating ARFF for $i"
	perl destrafodu-toarff.pl -p/home/louis/p1/delemmatiser/data/particles.txt -igenerated/$i.lexicon -ogenerated/$i.arff
done


