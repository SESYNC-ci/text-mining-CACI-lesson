---
---

## Topic Modelling

Latent Dirichlet Allocation (LDA) is an algorithim that's conceptually similar
to dimensionallity reduction techniques for numerical data, such as PCA.
Although, LDA requires you to determine the number of "topics" in a corpus
beforehand, while PCA allows you to choose the number of principle components
needed based on their loadings.
{:.notes}

===



~~~r
library(topicmodels)

seed = 12345
fit = LDA(dtm_trimmed, k = 5, control = list(seed=seed))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> terms(fit, 20)
~~~
{:title="Console" .input}


~~~
      Topic 1    Topic 2 Topic 3      Topic 4    Topic 5    
 [1,] "thank"    "get"   "market"     "price"    "mari"     
 [2,] "lynn"     "will"  "monika"     "the"      "agreement"
 [3,] "will"     "know"  "enron"      "enron"    "enron"    
 [4,] "pleas"    "can"   "financi"    "will"     "pleas"    
 [5,] "meet"     "just"  "pulp"       "compani"  "thank"    
 [6,] "can"      "like"  "includ"     "market"   "attach"   
 [7,] "let"      "think" "compani"    "gas"      "will"     
 [8,] "bill"     "dont"  "trader"     "trade"    "master"   
 [9,] "know"     "time"  "skill"      "energi"   "know"     
[10,] "need"     "look"  "load"       "deal"     "fax"      
[11,] "fyi"      "want"  "trade"      "manag"    "let"      
[12,] "ani"      "work"  "price"      "parti"    "ani"      
[13,] "question" "call"  "inform"     "new"      "copi"     
[14,] "call"     "one"   "north"      "transact" "need"     
[15,] "schedul"  "good"  "oregon"     "this"     "corp"     
[16,] "discuss"  "need"  "make"       "month"    "document" 
[17,] "work"     "back"  "causholli"  "contract" "can"      
[18,] "get"      "take"  "temperatur" "posit"    "send"     
[19,] "group"    "day"   "data"       "use"      "sign"     
[20,] "michell"  "hope"  "attach"     "servic"   "servic"   
~~~
{:.output}


===

By assigning topic "weights" back to the documents, which gives an indication of how likely it
is to find each topic in a document, you have engineered some numerical features associated
with each document that might further help with classification or visualization.
{:.notes}



~~~r
email_topics <- as.data.frame(
  posterior(fit, dtm_trimmed)$topics)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> head(email_topics)
~~~
{:title="Console" .input}


~~~
                                      1            2           3         4
15572442.1075858843984.txt 3.720195e-05 0.4526013220 0.229491023 0.3178332
3203154.1075852351910.txt  6.036603e-03 0.6220533207 0.120064073 0.2458096
13645178.1075839996540.txt 4.612527e-01 0.0029070018 0.051030738 0.3338006
22210912.1075858601602.txt 8.923614e-04 0.0008921769 0.012294932 0.9850281
2270209.1075858847824.txt  1.401818e-01 0.2407141202 0.002458558 0.6141870
26147562.1075839996615.txt 7.567838e-02 0.2396156416 0.101497075 0.5829608
                                      5
15572442.1075858843984.txt 3.721505e-05
3203154.1075852351910.txt  6.036383e-03
13645178.1075839996540.txt 1.510089e-01
22210912.1075858601602.txt 8.924571e-04
2270209.1075858847824.txt  2.458535e-03
26147562.1075839996615.txt 2.481385e-04
~~~
{:.output}


===

The challenge with LDA, as with any machine learning result, is interpretting the
result. Are the "topics" recognizable by the words used?



~~~r
library(ggwordcloud)

topics <- tidy(fit) %>%
  filter(beta > 0.004)

ggplot(topics,
  aes(size = beta, label = term)) +
  geom_text_wordcloud_area(rm_outside = TRUE) +
  facet_wrap(vars(topic))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/topic/unnamed-chunk-5-1.png" %})
{:.captioned}

