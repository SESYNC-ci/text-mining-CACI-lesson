---
---

## Text mining

Developing measurements of quantitative variables from unstructured information is another component of the "field-work" in research projects that rely on texts for empirical observations.

- Searching strings for patterns
- Cleaning strings of un-informative patterns
- Quantifying string occurrences and associations
- Interpretting the meaning of associated strings

===

## Isolate unstructured information

Assuming the structured data in the Enron e-mail headers has been captured, strip down the content to the unstructured message.


~~~r
for (i in seq(docs)) {
  lines <- content(docs[[i]])
  header_last <- str_match(lines, '^X-FileName:')
  header_last <- which(!is.na(header_last))
  message_begin <- header_last[[1]] + 1
  repeat_first <- str_match(lines, '--Original Message--')
  repeat_first <- which(!is.na(repeat_first))
  message_end <- c(repeat_first - 1, length(lines))[[1]]
  content(docs[[i]]) <- lines[message_begin:message_end]
}
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
content(docs[[2]])
~~~
{:.input}
~~~
[1] ""                                                                                             
[2] "\tRonnie, I just got back from vacation and wanted to follow up on the discussion below."     
[3] "\tHave you heard back from Jerry?  Do you need me to try calling Delaine again?  Thanks. Lynn"
[4] ""                                                                                             
~~~
{:.output}
===

## Functions for cleaning strings

These are some of the functions listed by `getTransformations`.


~~~r
clean_docs <- docs
clean_docs <- tm_map(clean_docs, removePunctuation)
clean_docs <- tm_map(clean_docs, removeNumbers)
clean_docs <- tm_map(clean_docs, stripWhitespace)
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
content(clean_docs[[2]])
~~~
{:.input}
~~~
[1] ""                                                                                       
[2] " Ronnie I just got back from vacation and wanted to follow up on the discussion below"  
[3] " Have you heard back from Jerry Do you need me to try calling Delaine again Thanks Lynn"
[4] ""                                                                                       
~~~
{:.output}

===

Additional transformations using base R functions can be used within a `content_transformation` wrapper.


~~~r
clean_docs <- tm_map(clean_docs, content_transformer(tolower))
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
content(clean_docs[[2]])
~~~
{:.input}
~~~
[1] ""                                                                                       
[2] " ronnie i just got back from vacation and wanted to follow up on the discussion below"  
[3] " have you heard back from jerry do you need me to try calling delaine again thanks lynn"
[4] ""                                                                                       
~~~
{:.output}

===

Customize document preparation with your own functions. The function must be wrapped in `content_transformer` if designed to accept and return strings rather than PlainTextDocuments.


~~~r
collapse <- function(x) {
  paste(x, collapse = '')
}
clean_docs <- tm_map(clean_docs, content_transformer(collapse))  
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
content(clean_docs[[2]])
~~~
{:.input}
~~~
[1] " ronnie i just got back from vacation and wanted to follow up on the discussion below have you heard back from jerry do you need me to try calling delaine again thanks lynn"
~~~
{:.output}

===

# Stopwords and stems

Stopwords are the throwaway words that don't inform content, and lists for different languages are complied within **tm**. Before removing them though, also "stem" the current words to remove plurals and other nuissances.


~~~r
clean_docs <- tm_map(clean_docs, stemDocument)
clean_docs <- tm_map(clean_docs, removeWords, stopwords("english"))
~~~
{:.input}

===

## Create Bag-Of-Words Matrix


~~~r
dtm <- DocumentTermMatrix(clean_docs)
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
as.matrix(dtm[1:6, 1:6])
~~~
{:.input}
~~~
                            Terms
Docs                         aaa aaron abacus abandon abb abba
  10001529.1075861306591.txt   0     0      0       0   0    0
  10016327.1075853078441.txt   0     0      0       0   0    0
  10025954.1075852266012.txt   0     0      0       0   0    0
  10029353.1075861906556.txt   0     0      0       0   0    0
  10042065.1075862047981.txt   0     0      0       0   0    0
  10050267.1075853166280.txt   0     0      0       0   0    0
~~~
{:.output}

===

Outliers may reduce the density of the matrix of term occurrences in each document.


~~~r
char <- sapply(clean_docs, function(x) nchar(content(x)))
hist(log10(char))
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk unnamed-chunk-12]({{ site.baseurl }}/images/unnamed-chunk-12-1.png)

===


~~~r
inlier <- function(x) {
  n <- nchar(content(x))
  n < 10^3 & n > 10
}
clean_docs <- tm_filter(clean_docs, inlier)
dtm <- DocumentTermMatrix(clean_docs)
dense_dtm <- removeSparseTerms(dtm, 0.999)
dense_dtm <- dense_dtm[rowSums(as.matrix(dense_dtm)) > 0, ]
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
as.matrix(dense_dtm[1:6, 1:6])
~~~
{:.input}
~~~
                            Terms
Docs                         abil abl abov absolut accept access
  10001529.1075861306591.txt    0   0    0       0      0      0
  10016327.1075853078441.txt    0   0    0       0      0      0
  10025954.1075852266012.txt    0   0    0       0      0      0
  10029353.1075861906556.txt    0   0    0       0      0      0
  10042065.1075862047981.txt    0   0    0       0      0      0
  10050267.1075853166280.txt    0   0    0       0      0      0
~~~
{:.output}

===

## Term correlations

The `findAssocs` function checks columns of the document-term matrix for correlations.


~~~r
assoc <- findAssocs(dense_dtm, 'fuck', 0.2)
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
assoc
~~~
{:.input}
~~~
$fuck
werent  woman   rude   hate    owe 
  0.33   0.30   0.22   0.21   0.21 
~~~
{:.output}
===

## Latent Dirichlet allocation

The LDA algorithim is conceptually similar to dimensionallity reduction techniques for numerical data, such as PCA. Although, LDA requires you to determine the number of "topics" in a corpus beforehand, while PCA allows you to choose the number of principle components needed based on their loadings.


~~~r
library(topicmodels)

seed = 12345
fit = LDA(dense_dtm, k = 4, control = list(seed=seed))
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
terms(fit, 20)
~~~
{:.input}
~~~
      Topic 1    Topic 2     Topic 3   Topic 4    
 [1,] "will"     "thank"     "will"    "can"      
 [2,] "get"      "lynn"      "thank"   "meet"     
 [3,] "ani"      "pleas"     "know"    "thank"    
 [4,] "look"     "let"       "can"     "know"     
 [5,] "let"      "get"       "pleas"   "work"     
 [6,] "know"     "like"      "want"    "will"     
 [7,] "need"     "agreement" "need"    "question" 
 [8,] "think"    "master"    "like"    "week"     
 [9,] "price"    "parti"     "ani"     "pleas"    
[10,] "email"    "just"      "group"   "lynn"     
[11,] "just"     "need"      "work"    "enron"    
[12,] "time"     "call"      "lynn"    "trade"    
[13,] "question" "back"      "dont"    "use"      
[14,] "market"   "execut"    "just"    "send"     
[15,] "send"     "receiv"    "see"     "get"      
[16,] "lynn"     "want"      "talk"    "may"      
[17,] "enron"    "servic"    "michell" "hope"     
[18,] "call"     "take"      "time"    "veri"     
[19,] "new"      "offic"     "make"    "schedul"  
[20,] "one"      "enron"     "day"     "agreement"
~~~
{:.output}

===

The topic "weights" can be assigned back to the documents for use in future analyses.


~~~r
topics <- posterior(fit, dense_dtm)$topics
topics <- as.data.frame(topics)
colnames(topics) <- c('accounts', 'meeting', 'call', 'legal')
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
head(topics)
~~~
{:.input}
~~~
                            accounts   meeting      call     legal
10001529.1075861306591.txt 0.2470315 0.2497333 0.2549814 0.2482538
10016327.1075853078441.txt 0.2505420 0.2562433 0.2522828 0.2409319
10025954.1075852266012.txt 0.2509041 0.2477392 0.2492562 0.2521004
10029353.1075861906556.txt 0.2473255 0.2525143 0.2506372 0.2495230
10042065.1075862047981.txt 0.2483039 0.2513652 0.2464095 0.2539213
10050267.1075853166280.txt 0.2439128 0.2486203 0.2573323 0.2501346
~~~
{:.output}
