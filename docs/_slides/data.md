---
---

## Structured Data

Structured data is a collection of multiple observations, each composed of one
or more variables. Most analyses typically begin with structured data, the kind
of tables you can view as a spreadhseet or numerical array.

The key to *structure* is that information is packaged into well-defined
variables, e.g. the columns of a tidy data frame. Typically, it took someone a
lot of effort to get information into a useful structure.
{:.notes}

===

## Well-defined Variables

![]({% include asset.html path="images/variable.png" %}){:width="30%"}  
*Cox, M. 2015. Ecology & Society 20(1):63.*  
{:.captioned}

===

## Variable Classification

Every variable fits within one of four categories---these are more general categories
than you find when enumerating "data types" as understood by R or Python.

| Category | Definition |
|----------|------------|
| *Numeric* (or *Interval*) | Values separated by meaningful intervals/distances |
| *Ordered*               | Ordered values without "distance" between them |
| *Categorical*           | Finite set of distinct, un-ordered values |
| *Qualitative*           | Unlimited, discrete, and un-ordered possibilities |

===

What we call quantitative data is actually any one of the first three.

Qustion
: What is one example of each of the three types of quantitative data (interval,
ordered, and categorical) a biological survey might produce?

Answer
: {:.fragment} For example, a fisheries survey might record size, age class
(juvenile, adult), and species.

===

Qustion
: What is an example of qualitative data the same biological survey might
collect?

Answer
: {:.fragment} Surveys often collect descriptive data, e.g. description of
micro-habitat where an organism was found.

===

## Unstructured Data

Information that has not been carved up into variables is unstructured "data"---
although some say that is a misnomer. Any field researcher knows when they are
staring down raw information, and they are usually puzzling over how to collect
or structure it.

![]({% include asset.html path="images/salmon.jpg" %}){:width="25%"} ![]({% include asset.html path="images/cards.jpg" %}){:width="41.8%"}  
*Photo by [trinisands](https://www.flickr.com/photos/50680623@N04) / [CC BY-SA](https://creativecommons.org/licenses/by-sa/2.0/) and by [Archives New Zealand](https://www.flickr.com/photos/archivesnz/) / [CC BY](https://creativecommons.org/licenses/by/2.0/)*
{:.captioned}

===

Suppose you want to collect data on how businesses fail, so you download [half a
million e-mails from Enron executives](https://www.cs.cmu.edu/~./enron/) that
preceeded the energy company's collapse in 2001.

~~~
Message-ID: <16986095.1075852351708.JavaMail.evans@thyme>
Date: Mon, 3 Sep 2001 12:24:09 -0700 (PDT)
From: greg.whalley@enron.com
To: kenneth.lay@enron.com, j..kean@enron.com
Subject: FW: Management Committee Offsite

I'm sorry I haven't been more involved is setting this up, but I think the
agenda looks kond of soft.  At a minimum, I would like to turn the schedule
around and hit the hard subjects like Q3, risk management, and ...
~~~
{:.text-document title="data/enron/16986095.1075852351708.txt"}

Structuring the data for analysis does not mean you quantify everything,
although certainly some information can be quantified. Rather, turning
unstructured information into structured data is a process of identifying
concepts, definining variables, and assigning their values (i.e. taking
measurements) from the text.
{:.notes}

===

Possible examples for variables of different classes to associate with the Enron e-mails.

| Category | Example |
|----------|---------|
| *Numeric* (or *Interval*) | timestamp, e-mail length, occurrences of a given topic |
| *Ordered* | sender's position in the company, step in process-tracing sequence of events |
| *Categorical* | sender's department in the company, sender-recipient paris (e.g. network) |
| *Qualitative* | message subject matter, sender's sentiment |

===

Question
: What distinguishes *data* from unstructured information? What distinguishes *qualitative data* from unstructured information?

Answer
: {:.fragment} Data is the measurement of a variable that relates to a well-defined concept, while information is free of any analytical framework. Data is qualitative if its measurement could give any value and no measure of distance exists for any pair of values.

Processing of texts, surveys, recordings, etc. into variables (whether qualitative or not), is often described as qualitiative data analysis.
{:.notes}

===

## Computer Assisted QDA

===

- Coding
  - Annotating a document collection by highlighting shared themes (CAQDA).
  - e.g. highlighting sections of an email collection with "codes" or "themes"
- Scraping
  - Process digitized information (websites, texts, images, recordings) into structured data.
  - e.g. capture sender, date, and greeting from emails, storing values in a data frame
- Text Mining
  - Processing text on the way to producing qualitative or quantitative data
  - e.g. bag-of-words matrix
- Topic Modeling
  - Algorithms for automatic coding of extensive document collections.
  - e.g. latent Dirichlet allocation (LDA)

These are different ways of performing "feature engineering", which requires
both domain knowledge and programing skill. The feature engineer faces the dual
challenges of linking concepts to variables and of creating structured data
about these variables from a source of raw information.
{:.notes}
