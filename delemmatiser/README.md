Create lexicon files
==============

The script can currently handle both the eLex lexicon file and the Lassy corpus files of which can generate a lexicon.

The options are:

    destrafodu-createlexicon.pl
    
    #	-e <file|->		eLex XML file
    
    #	-p <file|->		persistent lexicon file
    
    #	-l <file|->		Lassy frequency counts file
    #	-L <dir>		Lassy XML directory, currently not implemented
    
    #	-o <file|->		writes output to file, default is to stdout
    #	-m <file>		writes the lexicon entries with their relative mass to a file
    
    #	-w <n>			weighting scheme, n = {1,2,3}, default = 2
    #	-t <n>			repetition scheme, n = {1,2,3}, default = 1 (type, token, masstoken)    
    #	-M <n>			number of entries per tag-lemma pair for masstoken, default = 10

    #	-d 				normalise diacritics
    #   -i				normalise all characters to lower case

You have to specify either -e, -p, -l, or -L, as the program must have an input. The default
output is to STDOUT, but this can be redirected using -o.
    
The weighting scheme has three options:

    w1: do nothing
    w2: +1 to every triple
    w3: 0 -> 2, 1 -> 1, +1 to other frequencies
    
w1 will use the eLex frequencies as is. w2 uses also the zero-valued triples in eLex. These
are triples that were in earlier lexicons, but were not observed in the corpora on which eLex
is based. w3 prefers unobserved triples over triples that were only observed once. The idea is
that triples that were only observed once are more likely to be errors, whereas unobserved 
triples are just, ... unobserved.

For the repetition scheme there are also three values. t1 returns all the unique triples. 
t2 returns all the triples, each triple occurs as often as their frequency indicates. If t3 is
enabled the triples occur proportional to their relative mass. For each tag-lemma-form triple we
determine how often it occurs with respect to its tag-lemma pair. We convert this to a relative
frequency, and output the triple as often as this frequency indicates. The amount of "proportional
slots" can be adjusted with -M.

For normalisation we currently use two methods. -d enables the diacritics normalisation. Letters with
accents or other diacritic signs are mapped to their "base" letter: ë -> e, ï -> i, ê -> e, ç -> c, etc.
The second method is case normalisation (-i). All characters are mapped to their lower case equivalent.
In case both options are used, first the diacritics are removed, then the characters are mapped to lower case.

Create ARFF files
==============

The use machine learning, we have to convert our data into features. We use a fairly simple approach
based on the trie data structure. For each word, we look the reverse word endings for all lengths. So, for the
word "fiets", we use "s", "st", "ste", "stei", "steif". As additional data we use the tag, whether the word
starts with a capital, and if the word starts with a prefix. So, hardly any magic here.

We use a script to generate these features, and write them to ARFF format. This is convenient, because
many machine learning applications can read this format. 

    destrafodu-toarff.pl
    
    # 	-p		        particles file
    
    # 	-s		        max suffix length, default=35
    
    #	-i <file|->		reads input from file, default is from stdin
    #	-o <file|->		writes output to file, default is to stdout

The max suffix length can be changed if there are words with more than 35 characters. Tests show that the 
suffixes 30 to 35 have very little information gain (< E-05), so you might want to get rid of them. Generally, this is
not necessary, and the default value performs well enough in general.

Lexicon-based delemmatisation
==============

Strategy
--------------

The idea is simple, if the tag-lemma triple occurs in the lexicon, we do a lookup in the lexicon to find the corresponding form.
If it does not occur in the lexicon, we can do two things. Either we return a result that we don't know the form ("?"), or we 
return the lemma. The latter case is the best guess we can do given the circumstances.

If there are multiple surface forms that correspond to one tag-lemma pair, we take the surface form with the maximum likelihood,
the one that occurs most. Or if multiple forms occur as many times (4 same forms with a flat distribution: i.e. 25% of the time)
we randomly take one of those.

This means that if you want to steer the results in favour of preferring dialect, for example, you have to boost the frequency of dialect words.
We don't have facilities for that, but the input is plain text and easy to process.

The script to perform lexicon-based delemmatisation has the following options:

    destrafodu-lex.pl
    
    #	-m <file>		reads rel.mass lexicon file
    #	-i <file|->		reads the input
    #	-o <file|->		writes tag-lemma-form-prediction quadruples to file, default is to stdout
    
    #	-l				returns lemma if tag-lemma not in lexicon 

Early normalisation
--------------
If you want to train on eLex with relative frequency scaling and case normalisation and use the non-seen triples as well:

    perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -w2 -t3 -i -o/tmp/destrafodu/eLex.w2.t3.i.lexicon -m/tmp/eLex.w2.t3.i.rm

and you want to test on Lassy's case normalised tokens:

    perl destrafodu-createlexicon.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq -w1 -t2 -i -o/tmp/destrafodu/Lassy.w1.t2.i.lexicon

After creating the lexicon files, you can do the delemmatisation:

    perl destrafodu-lex.pl -m/tmp/eLex.w2.t3.i.rm -i/tmp/destrafodu/Lassy.w1.t2.i.lexicon | perl destrafodu-analysis.pl

which gives as result, something similar to:

    Overall performance:
    	N: 0.885682 (218550/246759)
    	V: 0.988608 (140672/142293)
    	A: 0.963407 (77456/80398)

With case-insensitive analysis:

    perl destrafodu-lex.pl -m/tmp/eLex.w2.t3.i.rm -i/tmp/destrafodu/Lassy.w1.t2.i.lexicon | perl destrafodu-analysis.pl -i

the result is:

    Overall performance:
    	N: 0.885682 (218550/246759)
    	V: 0.988608 (140672/142293)
    	A: 0.963407 (77456/80398)

Late normalisation
--------------

Similar results can also be achieved with the following commands, by normalising the case in the analysis phase:

    perl destrafodu-createlexicon.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml -w2 -t3 -o/tmp/destrafodu/eLex.w2.t3.lexicon -m/tmp/destrafodu/eLex.w2.t3.rm
    
    perl destrafodu-createlexicon.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq -w1 -t2 -o/tmp/destrafodu/Lassy.w1.t2.lexicon
    
    perl destrafodu-lex.pl -m/tmp/destrafodu/eLex.w2.t3.rm -i/tmp/destrafodu/Lassy.w1.t2.lexicon | perl destrafodu-analysis.pl -i

Which gives as result:

    Overall performance:
    	N: 0.881617 (217546/246758)
    	V: 0.988608 (140672/142293)
    	A: 0.962362 (77372/80398)

Compare these results to the case-sensitive analysis, and as expected there is a discrepancy in the performance. In the early-normalisation analysis, this discrepancy is not present.

    perl destrafodu-lex.pl -m/tmp/destrafodu/eLex.w2.t3.rm -i/tmp/destrafodu/Lassy.w1.t2.lexicon | perl destrafodu-analysis.pl

Now the results are slightly different:

    Overall performance:
    	N: 0.818320 (201927/246758)
    	V: 0.970512 (138097/142293)
    	A: 0.894997 (71956/80398)


Concluding, because the lexicon-based delemmatisation strategy is based on simple case-sensitive lookup in the lexicon, it matters in which stage you perform the case normalisation. Not surprisingly, the performance is a bit better in the early-normalisation stage.

    	
ML-based delemmatisation
==============

First you have to create ARFF files that contain the features and the class. First for the train examples:

    perl destrafodu-toarff.pl -i/tmp/destrafodu/eLex.w2.t2.i.lexicon -p/home/louis/p1/delemmatiser/data/particles.txt -o/tmp/destrafodu/eLex.w2.t2.i.arff
        
Then for the test examples:
        
    perl destrafodu-toarff.pl -i/tmp/destrafodu/Lassy.w1.t2.i.lexicon -p/home/louis/p1/delemmatiser/data/particles.txt -o/tmp/destrafodu/Lassy.w1.t2.i.arff
        
Then it's just a matter of running it through a classifier such as timbl:

    timbl -a 1 -t -t /tmp/destrafodu/Lassy.w1.t2.i.arff -f /tmp/destrafodu/eLex.w2.t2.i.arff -F ARFF -o /tmp/destrafodu/eMT.lTO.i.predictions

With the result

    overall accuracy:        0.990129  (464820/469454)

it's getting somewhere, as this is the accuracy of predicting the right edit script. However there are multiple edit scripts that
can yield the same form given a lemma. We can analyse the results by applying the predicted edit scripts
on the lemmas:

    perl destrafodu-fromarff.pl -i/tmp/destrafodu/eMT.lTO.i.predictions | perl destrafodu-analysis.pl
    
Which returns something like:

    Overall performance:
    	N: 0.990854 (244507/246764)
    	V: 0.990555 (140950/142294)
    	A: 0.991579 (79719/80396)

Which seems a little bit better, as we expected. The case-insensitive analysis yields the same results,
but since we used case-normalised lexicon files, this is no suprise.

(The numbers here a bit different from LEX results, this is because some entries in the lexicon contain a
comma. Currently, they mess up the ARFF file. We will fix this later.)


Hybrid approach
==============

Assuming you have set up a timbl server, and it is running, we can start the timbl client:

    perl destrafodu-hyb.pl -m/tmp/destrafodu/eLex.w2.mrlexicon -p/home/louis/p1/delemmatiser/data/particles.txt
    
This script starts a client for you and handles the input and output with the timbl server. Now all you have to do
is enter tag-lemma-form triples. If you don't know the form, for example because you are using the program in a real
application rather than only testing it, you can use a question mark.

In the following example I tried some entries:

    V(fin=fin,tense=past,num=sing,form=norm) wrden werd
    V(fin=fin,tense=past,num=sing,form=norm) wrden werd wrdde
    V(fin=fin,tense=past,num=sing,form=norm) worden werd
    V(fin=fin,tense=past,num=sing,form=norm) worden werd werd
    Adjv(deg=pos,form=e) nieuw nieuwe
    Adjv(deg=pos,form=e) nieuw nieuwe nieuwe
    Adjv(deg=pos,form=e) Belgisch-Nederlands Belgisch-Nederlandse
    Adjv(deg=pos,form=e) Belgisch-Nederlands Belgisch-Nederlandse Belgisch-Nederlandse
    Adjv(deg=comp,form=en) jong JONGEREN
    Adjv(deg=comp,form=en) jong JONGEREN jongeren
    N(dim=dim,num=plu,case=nom) böl bölkes
    N(dim=dim,num=plu,case=nom) böl bölkes böltjes
    V(fin=fin,tense=past,num=sing,form=norm) wrden ?
    V(fin=fin,tense=past_num=sing,form=norm) wrden ? wrdde
    
Some are from the lexicon, some are provided by timbl. The first line is the input by the user (stdin), and the second
line is the result with the prediction (on stdout).

Set up a timbl server
==============

Create a config file timbleConfiguration:

    port=7000
    maxconn=100
    destrafodu="-a1 -f /tmp/destrafodu/eLex.w2.masstoken.arff -F ARFF"
    

Start the server with:
    
    timblserver --config timblOptions

The first thing you have to do when you start the client is select the default base (anigrides is the name of the server):

    timblclient -n anigrides -p 7000
    base destrafodu
    
Now everything's set up and you can ask the server to classify new instances with:

    c V(fin=fin_tense=pres_num=sing_form=norm),"",0,"n","nj","nji","njiz",?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"-.zijn +.is"
    
For which it gives the result:

    CATEGORY {"-.zijn\_+.is"}
    
Which seems about right :)


