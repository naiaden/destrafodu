Lexicon-based delemmatisation
==============

First you have to create a train lexicon. We will use eLex in this example as train lexicon.

    perl destrafodu-gtrain.pl -e/home/louis/p1/delemmatiser/data/corpora/elex1.1/lexdata/elex-1.1.xml \
                            -o/tmp/destrafodu/eLex.w2.masstoken \
                            -w2 \
                            -t3 \
                            -m/tmp/destrafodu/eLex.w2.mrlexicon

Here we use a simple +1 weighting for all frequencies (-w2), and we generate a lexicon where the frequencies of the tokens are relative to the frequency within the tag (-t3).
We store the lexicon (-o), and the intermediate masslexicon file (-m) as it will turn out to be convenient for a later step.

Second, you need a test lexicon. We use the entries from the Lassy corpus to generate a lexicon.

    perl destrafodu-gtest.pl -l/home/louis/p1/delemmatiser/data/corpora/Lassy1.0/Freqs/WORD-LEMMA-POS.freq  \
                            -o/tmp/destrafodu/Lassy.token

The last step is to do the actually delemmatisation:

    perl destafodu-lex.pl -m/tmp/destrafodu/eLex.w2.mrlexicon -i/tmp/destrafodu/Lassy.token

This will yield all the predictions. If you are more interested in the performance, and the error breakdown:

    perl destrafodu-lex.pl -m/tmp/destrafodu/eLex.w2.mrlexicon -i/tmp/destrafodu/Lassy.token | perl destrafodu-analysis.pl

For the unnormalised analysis, this gives something like:

    Overall performance:
    	N: 0.804988 (198634/246754)
    	V: 0.963962 (137165/142293)
    	A: 0.884425 (71106/80398)

With case-insensitive analysis

    perl destrafodu-lex.pl -m/tmp/destrafodu/eLex.w2.mrlexicon -i/tmp/destrafodu/Lassy.token | perl destrafodu-analysis.pl -i

The results are:

    Overall performance:
    	N: 0.867771 (214126/246754)
    	V: 0.981981 (139729/142293)
    	A: 0.951143 (76470/80398)

    	
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


