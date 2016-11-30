---
---

## Structured Data

Structured data is a collection of multiple observations, each composed of one or more variables -- so far we have only delt with structured data.

Key to structure: information comes in well-defined variables, e.g. the columns of our tidy tabular data.

===

## Well-defined variables

![]({{ site.baseurl }}/images/variable.png){:width="30%"}  
*Cox, M. 2015. Ecology & Society 20(1):63.*
{:.captioned}

===

## Data Classes (not "data types")

Interval (or Numeric)
: Values are separated by meaningful intervals.

Ordered
: Ordered values without "distance" between them.

Categorical
: Finite set of distinct, un-ordered values.

Qualitative
: Unlimited, discrete, and un-ordered possibilities.

===

## Unstructured Data

Here "data" is a misnomer -- we mean information that has not been carved up into variables.

Suppose you need data on how businesses fail, so you download [half a million e-mails from Enron executives](https://www.cs.cmu.edu/~./enron/) that preceeded the energy company's collapse in 2001.

Structuring the data for analysis does not mean you quantify everything, although certainly some information can be quantified.
Rather, turning unstructured information into structured data is a process of identifying concepts, definining variables, and assigning their values (i.e. taking measurements) from the textual, audio or video content.

===

Possible examples for variables of different classes to associate with the Enron e-mails.

Interval / Numerical
: e.g. timestamp, e-mail length, occurrences of a given theme

Ordered
: e.g sender's position in the company, event in process-tracing sequence

Categorical
: e.g. recipient(s), sender's department, thematic code

Qualitative
: e.g. topic, greeting, sentiment

===

What distinguishes *qualitative* data from unstructured information? Remember, we're only calling something data if it's the measurement of a **variable**.

1. It is the measurement of a variable that relates to a defined concept
1. It is qualitative, i.e. categorical, un-ordered and taking any value

Processing of texts, surveys, recordings, etc. into variables (whether qualitative or not), is often part of "qualitiative data analysis".

===

## Help from a computer

- Scraping
  - Process digitized information (websites, texts, images, recordings) into structured data.
  - e.g. capture sender, date, and greeting from a batch of e-mails as variables in a data frame.
- Text mining
  - Processing text on the way to producing qual/quant data (i.e. this overlaps with scraping).
  - e.g. bag-of-words matrix
- Coding
  - Annotating a document collection with shared themes, sometimes called Computer Assisted Qualitative Data Analysis (CAQDA).
  - e.g. manually labelling sections of each e-mail with [relational] codes/themes 
- Topic modeling
  - Algorithmic approach to coding extensive document collections.
  - e.g. latent Dirichlet allocation (LDA)

These are different ways of performing "feature engineering", which requires both domain knowledge and programing skill to link concepts with variables and create structured data from different information sources.
