See the [wiki](https://github.com/naiaden/destrafodu/wiki) for more info and results. 

The text below is old, and will be rewritten on the wiki soon.

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


    	
