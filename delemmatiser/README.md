Lexicon-based delemmatisation
==============

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

 

    Overall performance:
    	N: 0.818320 (201927/246758)
    	V: 0.970512 (138097/142293)
    	A: 0.894997 (71956/80398)


Concluding, because the lexicon-based delemmatisation strategy is based on simple case-sensitive lookup in the lexicon, it matters in which stage you perform the case normalisation. Not surprisingly, the performance is a bit better in the early-normalisation stage.

    	
ML-based delemmatisation
==============

First you have to create ARFF files that contain the features and the class. First for the train examples:

    cat /tmp/destrafodu/eLex.w2.masstoken	\
        | perl destrafodu-toarff.pl -p/home/louis/p1/delemmatiser/data/particles.txt	\
        > /tmp/destrafodu/eLex.w2.masstoken.arff
        
Then for the test examples:
        
    cat /tmp/destrafodu/Lassy.token	\
        | perl destrafodu-toarff.pl -p/home/louis/p1/delemmatiser/data/particles.txt	\
        > /tmp/destrafodu/Lassy.token.arff
        
Then it's just a matter of running it through a classifier such as timbl:

    timbl -a 1 -t -t /tmp/destrafodu/Lassy.token.arff -f /tmp/destrafodu/eLex.w2.masstoken.arff -F ARFF -o /tmp/destrafodu/eMT.lTO.w2.predictions
    
Return its output back to lexicon form and analyse it:

    cat /tmp/destrafodu/eMT.lTO.w2.predictions | perl destrafodu-fromarff.pl | perl destrafodu-analysis.pl -i
    
Which returns something like:

    Overall performance:
	    N: 0.990007 (244298/246764)
	    V: 0.988664 (140681/142294)
	    A: 0.991144 (79684/80396)


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


