---
---

## Solutions

===

### Solution 1



~~~r
str_extract_all(content(email), '\\$\\S+\\b')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
[[1]]
character(0)

[[2]]
character(0)

[[3]]
character(0)

[[4]]
character(0)
~~~
{:.output}


[Return](#exercise-1)
{:.notes}

===

### Solution 2



~~~r
ggplot(words, aes(x = total)) +
  geom_histogram(binwidth = 1)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/solutions/unnamed-chunk-2-1.png" %})
{:.captioned}

The frequency of some words isn't very informative.  You can filter by term or by total number of occurrences. 



~~~r
words_trim <- filter(words, total < 250)

ggplot(words_trim, aes(x = total)) +
  geom_histogram(binwidth = 1)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/solutions/unnamed-chunk-3-1.png" %})
{:.captioned}

[Return](#exercise-2)
{:.notes}

===

### Solution 3



~~~r
word_assoc <- findAssocs(dtm_trimmed, 'pipelin', 0.6)
word_assoc <- data.frame(
  word = names(word_assoc[[1]]),
  assoc = word_assoc,
  row.names = NULL)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
ggplot(word_assoc,
       aes(label = word, size = pipelin)) +
       geom_text_wordcloud_area()
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/solutions/unnamed-chunk-5-1.png" %})
{:.captioned}

[Return](#exercise-3)
{:.notes}
