---
---

## Extracting relational data

Relational data are tables that establish a relationship between entities from other tables. Suppose we have a table with a record for each unique address in the Enron e-mails, then a second table with a record for each pair of e-mail addresses that exchanged a message is relational data.


~~~r
doc <- docs[[2]]
content(doc)[1:6]
~~~
{:.input}
~~~
[1] "Message-ID: <10016327.1075853078441.JavaMail.evans@thyme>"               
[2] "Date: Mon, 20 Aug 2001 16:14:45 -0700 (PDT)"                             
[3] "From: lynn.blair@enron.com"                                              
[4] "To: ronnie.brickman@enron.com, randy.howard@enron.com"                   
[5] "Subject: RE: Liquids in Region"                                          
[6] "Cc: ld.stephens@enron.com, team.sublette@enron.com, w.miller@enron.com, "
~~~
{:.output}

===

The "To:" field is slightly harder to extract, because it may include multiple recipients.


~~~r
subject <- which(!is.na(str_match(content(doc), '^Subject:')))
to <- paste(content(doc)[4:(subject[1] - 1)], collapse='')
to_list <- str_extract_all(to, '\\b\\S+@\\S+\\b')
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
to_list
~~~
{:.input}
~~~
[[1]]
[1] "ronnie.brickman@enron.com" "randy.howard@enron.com"   
~~~
{:.output}

===

Embed the above lines in a for loop to build an edge list for the network of e-mail senders and recipients.


~~~r
edgelist <- NULL
for (i in seq(docs)) {
  doc <- docs[[i]]
  from <- meta(doc, 'author')
  subject <- which(!is.na(str_match(content(doc), '^Subject:')))
  to <- paste(content(doc)[4:(subject[1] - 1)], collapse='')
  to_list <- str_extract_all(to, '\\b\\S+@\\S+\\b')
  edges <- t(rbind(from, to_list[[1]]))
  edgelist <- rbind(edgelist, edges)
}
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
dim(edgelist)
~~~
{:.input}
~~~
[1] 10431     2
~~~
{:.output}

===

The **network** package provides convenient tools for working with relational data.


~~~r
library(network)
~~~

~~~
network: Classes for Relational Data
Version 1.13.0 created on 2015-08-31.
copyright (c) 2005, Carter T. Butts, University of California-Irvine
                    Mark S. Handcock, University of California -- Los Angeles
                    David R. Hunter, Penn State University
                    Martina Morris, University of Washington
                    Skye Bender-deMoll, University of Washington
 For citation information, type citation("network").
 Type help("network-package") to get started.
~~~

~~~r
g <- network(edgelist)
plot(g)
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk unnamed-chunk-6]({{ site.baseurl }}/images/unnamed-chunk-6-1.png)

===

Question
: Is a network qualitative or quantitative data?

Answer
: It certainly doesn't fall into line with traditional statistical methods, but the variables involved are categorical. Methods for fitting models on networks (e.g. ERGMs) are an active research area.

===

## Scraping online

Scraping websites for data that, like the addresses in the Enron e-mails, are already stored as well-defined variables is a similar process. The structured data are in there, you just have to extract it. The **httr** package can assist with downloading web page content into R as a navigable HTML document.
