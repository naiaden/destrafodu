eLexPath=/home/louis/p1/delemmatiser/data/corpora/elex1.1
LassyPath=/home/louis/p1/delemmatiser/data/corpora/Lassy1.0
destrafoduPath=/home/louis/git/destrafodu/delemmatiser

echo "Generating files..."

echo "Generating eLex types... "
echo -ne "\tdefault..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -m $destrafoduPath/generated/eLex.w2.t1.rm -o $destrafoduPath/generated/eLex.w2.t1.lexicon
echo -ne " done!\n"

echo -ne "\tcase insensitive..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -i -m $destrafoduPath/generated/eLex.w2.t1.i.rm -o $destrafoduPath/generated/eLex.w2.t1.i.lexicon
echo -ne " done!\n"

echo -ne "\tdiacritics insensitive..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -d -m $destrafoduPath/generated/eLex.w2.t1.d.rm -o $destrafoduPath/generated/eLex.w2.t1.d.lexicon
echo -ne " done!\n"

echo -ne "\tcase and diacritics insensitive..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -d -i -m $destrafoduPath/generated/eLex.w2.t1.di.rm -o $destrafoduPath/generated/eLex.w2.t1.di.lexicon
echo -ne " done!\n"


echo "Generating eLex tokens..."
echo -ne "\tdefault..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -t3 -m $destrafoduPath/generated/eLex.w2.t2.rm -o $destrafoduPath/generated/eLex.w2.t2.lexicon
echo -ne " done!\n"

echo -ne "\tcase insensitive..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -t3 -i -m $destrafoduPath/generated/eLex.w2.t2.i.rm -o $destrafoduPath/generated/eLex.w2.t2.i.lexicon
echo -ne " done!\n"

echo -ne "\tdiacritics insensitive..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -t3 -d -m $destrafoduPath/generated/eLex.w2.t2.d.rm -o $destrafoduPath/generated/eLex.w2.t2.d.lexicon
echo -ne " done!\n"

echo -ne "\tcase and diacritics insensitive..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -t3 -d -i -m $destrafoduPath/generated/eLex.w2.t2.di.rm -o $destrafoduPath/generated/eLex.w2.t2.di.lexicon
echo -ne " done!\n"


echo "Generating eLex masstokens..."
echo -ne "\tdefault..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -t3 -m $destrafoduPath/generated/eLex.w2.t3.rm -o $destrafoduPath/generated/eLex.w2.t3.lexicon
echo -ne " done!\n"

echo -ne "\tcase insensitive..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -t3 -i -m $destrafoduPath/generated/eLex.w2.t3.i.rm -o $destrafoduPath/generated/eLex.w2.t3.i.lexicon
echo -ne " done!\n"

echo -ne "\tdiacritics insensitive..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -t3 -d -m $destrafoduPath/generated/eLex.w2.t3.d.rm -o $destrafoduPath/generated/eLex.w2.t3.d.lexicon
echo -ne " done!\n"

echo -ne "\tcase and diacritics insensitive..."
perl destrafodu-createlexicon.pl -e $eLexPath/lexdata/elex-1.1.xml -t3 -d -i -m $destrafoduPath/generated/eLex.w2.t3.di.rm -o $destrafoduPath/generated/eLex.w2.t3.di.lexicon
echo -ne " done!\n"


echo "Generating Lassy types..."
echo -ne "\tdefault..."
perl destrafodu-createlexicon.pl -l $LassyPath/Freqs/WORD-LEMMA-POS.freq -w1 -m $destrafoduPath/generated/Lassy.w1.t1.rm -o $destrafoduPath/generated/Lassy.w1.t1.lexicon
echo -ne " done!\n"

echo -ne "\tcase insensitive..."
perl destrafodu-createlexicon.pl -l $LassyPath/Freqs/WORD-LEMMA-POS.freq -i -w1 -m $destrafoduPath/generated/Lassy.w1.t1.i.rm -o $destrafoduPath/generated/Lassy.w1.t1.i.lexicon
echo -ne " done!\n"

echo -ne "\tdiacritics insensitive..."
perl destrafodu-createlexicon.pl -l $LassyPath/Freqs/WORD-LEMMA-POS.freq -d -w1 -m $destrafoduPath/generated/Lassy.w1.t1.d.rm -o $destrafoduPath/generated/Lassy.w1.t1.d.lexicon
echo -ne " done!\n"

echo -ne "\tcase and diacritics insensitive..."
perl destrafodu-createlexicon.pl -l $LassyPath/Freqs/WORD-LEMMA-POS.freq -d -i -w1 -m $destrafoduPath/generated/Lassy.w1.t1.di.rm -o $destrafoduPath/generated/Lassy.w1.t1.di.lexicon
echo -ne " done!\n"


echo "Generating Lassy tokens..."
echo -ne "\tdefault..."
perl destrafodu-createlexicon.pl -l $LassyPath/Freqs/WORD-LEMMA-POS.freq -w1 -t2 -m $destrafoduPath/generated/Lassy.w1.t2.rm -o $destrafoduPath/generated/Lassy.w1.t2.lexicon
echo -ne " done!\n"

echo -ne "\tcase insensitive..."
perl destrafodu-createlexicon.pl -l $LassyPath/Freqs/WORD-LEMMA-POS.freq -i -w1 -t2 -m $destrafoduPath/generated/Lassy.w1.t2.i.rm -o $destrafoduPath/generated/Lassy.w1.t2.i.lexicon
echo -ne " done!\n"

echo -ne "\tdiacritics insensitive..."
perl destrafodu-createlexicon.pl -l $LassyPath/Freqs/WORD-LEMMA-POS.freq -d -w1 -t2 -m $destrafoduPath/generated/Lassy.w1.t2.d.rm -o $destrafoduPath/generated/Lassy.w1.t2.d.lexicon
echo -ne " done!\n"

echo -ne "\tcase and diacritics insensitive..."
perl destrafodu-createlexicon.pl -l $LassyPath/Freqs/WORD-LEMMA-POS.freq -d -i -w1 -t2 -m $destrafoduPath/generated/Lassy.w1.t2.di.rm -o $destrafoduPath/generated/Lassy.w1.t2.di.lexicon
echo -ne " done!\n"



