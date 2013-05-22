echo "Generating files..."

echo "Generating eLex types... "
echo -ne "\tdefault..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -mgenerated/eLex.w2.t1.rm -ogenerated/eLex.w2.t1.lexicon
echo -ne " done!\n"

echo -ne "\tcase insensitive..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -i -mgenerated/eLex.w2.t1.i.rm -ogenerated/eLex.w2.t1.i.lexicon
echo -ne " done!\n"

echo -ne "\tdiacritics insensitive..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -d -mgenerated/eLex.w2.t1.d.rm -ogenerated/eLex.w2.t1.d.lexicon
echo -ne " done!\n"

echo -ne "\tcase and diacritics insensitive..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -d -i -mgenerated/eLex.w2.t1.di.rm -ogenerated/eLex.w2.t1.di.lexicon
echo -ne " done!\n"


echo "Generating eLex tokens..."
echo -ne "\tdefault..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -t3 -mgenerated/eLex.w2.t2.rm -ogenerated/eLex.w2.t2.lexicon
echo -ne " done!\n"

echo -ne "\tcase insensitive..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -t3 -i -mgenerated/eLex.w2.t2.i.rm -ogenerated/eLex.w2.t2.i.lexicon
echo -ne " done!\n"

echo -ne "\tdiacritics insensitive..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -t3 -d -mgenerated/eLex.w2.t2.d.rm -ogenerated/eLex.w2.t2.d.lexicon
echo -ne " done!\n"

echo -ne "\tcase and diacritics insensitive..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -t3 -d -i -mgenerated/eLex.w2.t2.di.rm -ogenerated/eLex.w2.t2.di.lexicon
echo -ne " done!\n"


echo "Generating eLex masstokens..."
echo -ne "\tdefault..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -t3 -mgenerated/eLex.w2.t3.rm -ogenerated/eLex.w2.t3.lexicon
echo -ne " done!\n"

echo -ne "\tcase insensitive..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -t3 -i -mgenerated/eLex.w2.t3.i.rm -ogenerated/eLex.w2.t3.i.lexicon
echo -ne " done!\n"

echo -ne "\tdiacritics insensitive..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -t3 -d -mgenerated/eLex.w2.t3.d.rm -ogenerated/eLex.w2.t3.d.lexicon
echo -ne " done!\n"

echo -ne "\tcase and diacritics insensitive..."
perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -t3 -d -i -mgenerated/eLex.w2.t3.di.rm -ogenerated/eLex.w2.t3.di.lexicon
echo -ne " done!\n"


echo "Generating Lassy types..."
echo -ne "\tdefault..."
perl destrafodu-createlexicon.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq -w1 -mgenerated/Lassy.w1.t1.rm -ogenerated/Lassy.w1.t1.lexicon
echo -ne " done!\n"

echo -ne "\tcase insensitive..."
perl destrafodu-createlexicon.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq -i -w1 -mgenerated/Lassy.w1.t1.i.rm -ogenerated/Lassy.w1.t1.i.lexicon
echo -ne " done!\n"

echo -ne "\tdiacritics insensitive..."
perl destrafodu-createlexicon.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq -d -w1 -mgenerated/Lassy.w1.t1.d.rm -ogenerated/Lassy.w1.t1.d.lexicon
echo -ne " done!\n"

echo -ne "\tcase and diacritics insensitive..."
perl destrafodu-createlexicon.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq -d -i -w1 -mgenerated/Lassy.w1.t1.di.rm -ogenerated/Lassy.w1.t1.di.lexicon
echo -ne " done!\n"


echo "Generating Lassy tokens..."
echo -ne "\tdefault..."
perl destrafodu-createlexicon.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq -w1 -t2 -mgenerated/Lassy.w1.t2.rm -ogenerated/Lassy.w1.t2.lexicon
echo -ne " done!\n"

echo -ne "\tcase insensitive..."
perl destrafodu-createlexicon.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq -i -w1 -t2 -mgenerated/Lassy.w1.t2.i.rm -ogenerated/Lassy.w1.t2.i.lexicon
echo -ne " done!\n"

echo -ne "\tdiacritics insensitive..."
perl destrafodu-createlexicon.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq -d -w1 -t2 -mgenerated/Lassy.w1.t2.d.rm -ogenerated/Lassy.w1.t2.d.lexicon
echo -ne " done!\n"

echo -ne "\tcase and diacritics insensitive..."
perl destrafodu-createlexicon.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq -d -i -w1 -t2 -mgenerated/Lassy.w1.t2.di.rm -ogenerated/Lassy.w1.t2.di.lexicon
echo -ne " done!\n"



