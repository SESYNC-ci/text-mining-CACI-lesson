---
---

## Text Mining

Developing measurements of quantitative variables from unstructured information
is another component of the "field-work" in research projects that rely on texts
for empirical observations.

- Searching strings for patterns
- Cleaning strings of un-informative patterns
- Quantifying string occurrences and associations
- Interpretting the meaning of associated strings

===

## Cleaning Text

Assuming the structured data in the Enron e-mail headers has been captured,
strip down the content to the unstructured message.



~~~r
enron <- tm_map(enron, function(email) {
  body <- content(email)
  match <- str_detect(body, '^X-FileName:')
  begin <- which(match)[[1]] + 1
  match <- str_detect(body, '^[>\\s]*[_\\-]{2}')
  match <- c(match, TRUE)
  end <- which(match)[[1]] - 1
  content(email) <- body[begin:end]
  return(email)
})
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> email <- enron[[2]]
> content(email)
~~~
{:title="Console" .input}


~~~
[1] ""                                                                                             
[2] "\tRonnie, I just got back from vacation and wanted to follow up on the discussion below."     
[3] "\tHave you heard back from Jerry?  Do you need me to try calling Delaine again?  Thanks. Lynn"
[4] ""                                                                                             
~~~
{:.output}

===

## Predefind Cleaning Functions

These are some of the functions listed by `getTransformations`.



~~~r
library(magrittr)

enron_words <- enron %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(stripWhitespace)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> email <- enron_words[[2]]
> content(email)
~~~
{:title="Console" .input}


~~~
[1] ""                                                                                       
[2] " Ronnie I just got back from vacation and wanted to follow up on the discussion below"  
[3] " Have you heard back from Jerry Do you need me to try calling Delaine again Thanks Lynn"
[4] ""                                                                                       
~~~
{:.output}


===

Customize document preparation with your own functions. The function must be
wrapped in `content_transformer` if designed to accept and return strings rather
than PlainTextDocuments.



~~~r
remove_link <- function(body) {
  match <- str_detect(body, '(http|www|mailto)')
  body[!match]
}
enron_words <- enron_words %>%
  tm_map(content_transformer(remove_link))  
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

# Stopwords and Stems

Stopwords are the throwaway words that don't inform content, and lists for
different languages are complied within **tm**. Before removing them though,
also "stem" the current words to remove plurals and other nuissances.
{:.notes}



~~~r
enron_words <- enron_words %>%
  tm_map(stemDocument) %>%
  tm_map(removeWords, stopwords("english"))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

## Document-Term Matrix

The "bag-of-words" model for turning a corpus into structured data is
to simply count the word frequency in each document.

===



~~~r
dtm <- DocumentTermMatrix(enron_words)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

## Long Form

The [tidytext](){:.rlib} package converts the (wide) Document Term Matrix
into a longer form table with a row for every document and term combination.

===



~~~r
library(tidytext)
library(dplyr)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~

Attaching package: 'dplyr'
~~~
{:.output}


~~~
The following objects are masked from 'package:stats':

    filter, lag
~~~
{:.output}


~~~
The following objects are masked from 'package:base':

    intersect, setdiff, setequal, union
~~~
{:.output}


~~~r
dtt <- tidy(dtm)
words <- dtt %>%
  group_by(term) %>%
  summarise(
    n = n(),
    total = sum(count)) %>%
  mutate(nchar = nchar(term))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

The `words` data frame is more amenable to further inspection and
cleaning, such as removing outliers.



~~~r
library(ggplot2)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~

Attaching package: 'ggplot2'
~~~
{:.output}


~~~
The following object is masked from 'package:NLP':

    annotate
~~~
{:.output}


~~~r
ggplot(words, aes(x = nchar)) +
  geom_histogram(binwidth = 1)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/mining/unnamed-chunk-9-1.png" %})
{:.captioned}

===

Words with too many characters are probably not actually words, and extremely
uncommon words won't help when searching for patterns.



~~~r
dtt_trimmed <- words %>%
  filter(
    nchar < 16,
    n > 1,
    total > 3) %>%
  select(term) %>%
  inner_join(dtt)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Joining, by = "term"
~~~
{:.output}


===

Further steps in analyzing this "bag-of-words" require returning to the
Document-Term-Matrix structure.



~~~r
dtm_trimmed <- dtt_trimmed %>%
  cast_dtm(document, term, count)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> dtm_trimmed
~~~
{:title="Console" .input}


~~~
<<DocumentTermMatrix (documents: 3756, terms: 2454)>>
Non-/sparse entries: 59821/9157403
Sparsity           : 99%
Maximal term length: 15
Weighting          : term frequency (tf)
~~~
{:.output}


===

## Term Correlations

The `findAssocs` function checks columns of the document-term matrix for
correlations. For example, words that are associated with the name of the CEO,
Ken Lay.



~~~r
word_assoc <- findAssocs(dtm_trimmed, 'ken', 0.6)
word_assoc <- data.frame(
  word = names(word_assoc[[1]]),
  assoc = word_assoc,
  row.names = NULL)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

A "wordcloud" emphasizes those words that have a high co-occurence
in the email corpus with the CEO's first name.



~~~r
> library(ggwordcloud)
> 
> ggplot(word_assoc,
+   aes(label = word, size = ken)) +
+   geom_text_wordcloud_area()
~~~
{:title="Console" .input}
![ ]({% include asset.html path="images/mining/unnamed-chunk-14-1.png" %})
{:.captioned}
