---
---

## Structured Data (not "data structures")

Structured data is a collection of multiple observations, each composed of one or more variables -- so far we have only delt with structured data.

Key to structure: information comes in well-defined variables, i.e. the columns of our tidy tabular data.

<!--split-->

## Well-defined variables

![]({{ site.baseurl }}/images/variable.png){:width="30%"}  
*Cox, M. 2015. Ecology & Society 20(1):63.*
{:.captioned}

<!--split-->

## Data Classes (not "data types")

Interval (or Numeric)
: Values are separated by meaningful intervals.

Ordered
: Ordered values without "distance" between them.

Categorical
: Finite set of distinct, un-ordered values.

Qualitative
: Unlimited, discrete, and un-ordered possibilities.

<!--split-->

## Unstructured Data

Here "data" is a misnomer -- we mean information that has not been carved up into variables.

Suppose you need data on how businesses fail, so you download [half a million e-mails from Enron executives](https://www.cs.cmu.edu/~./enron/) that preceeded the energy company's collapse in 2001.

Structuring the data for analysis does not mean you quantify everything, although certainly some information can be quantified.
Rather, turning unstructured information in structured data is a process of identifying concepts, definining variables, and assigning their values (i.e. taking measurements) from the textual, audio or video content.

<!--split-->

Possible examples for variables of different classes to associate with the Enron e-mails.

Interval / Numerical
: e.g. timestamp, e-mail length, occurrences of a given theme

Ordered
: e.g sender's position in the company, event in process-tracing sequence

Categorical
: e.g. recipient(s), sender's department, thematic code

Qualitative
: e.g. topic, greeting, sentiment

<!--split-->

What distinguishes *qualitative* data from unstructured information? Remember, we're only calling something data if it's the measurement of a **variable**.

1. It is the measurement of a variable that relates to a defined concept
1. It is qualitative, i.e. categorical, un-ordered and taking any value

Processing of texts, surveys, recordings, etc. into variables (whether qualitative or not), is often part of "qualitiative data analysis".

<!--split-->

## Help from a computer

- Scraping
  - Process digitized information (tables, texts, images, recordings) into structured data.
  - e.g. capture sender, date, greeting, etc. as values in a data frame.
- Text mining
  - Processing text on the way to producing qual/quant data (i.e. this overlaps with scraping).
  - e.g. bag-of-words matrix
- Coding
  - Annotating a document collection with shared themes, sometimes called Computer Assisted Qualitative Data Analysis (CAQDA).
  - e.g. manually labelling sections of each e-mail with [relational] codes/themes 
- Topic modeling
  - Algorithmic approach to coding extensive document collections.
  - e.g. latent Dirichlet allocation (LDA)

<!--split-->

## Scraping

![Text](http://imgs.xkcd.com/comics/regular_expressions.png "Wait, forgot to escape a space. Wheeeeee[taptaptap]eeeeee.")  
*by Randall Munroe / [CC BY-NC](http://xkcd.com/license.html)*
{:.captioned}

<!--split-->

RegEx is a very flexible, and very fast, program for parsing text.

| Pattern     | Match                                                                 |
|-------------+-----------------------------------------------------------------------|
| Subject:.\* | <span style="color:red;">Subject: Re: TPS Reports</span>              |
| \$[0-9,]+   | The ransom of <span style="color:red;">$1,000,000</span> to Dr. Evil. |
| \b\S+@\S+\b | Send comments to <span style="color:red;">info@sesync.org</span>.     |

Note that "\" must be escaped in R, so the first pattern would be scripted as `"\\$[0-9,]+"`.

<!--split-->


~~~r
install.packages(c("tm", "SnowballC", "stringr"))
~~~
{:.input}

Also, download text files with a mix of structured and unstructurd information from <http://sesync.us/g5>.

<!--split-->


~~~r
library(tm)
library(SnowballC)
library(stringr)

docs <- Corpus(DirSource("data/texts"))  # Put your texts here via your file explorer/finder
meta(docs[[1]])
~~~
{:.text-document title="lesson-8.R"}
~~~
  author       : character(0)
  datetimestamp: 2016-09-23 21:25:20
  description  : character(0)
  heading      : character(0)
  id           : 1.txt
  language     : en
  origin       : character(0)
~~~
{:.output}

<!--split-->


~~~r
content(docs[[1]])
~~~
{:.input}
~~~
 [1] "Message-ID: <4102090.1075845189404.JavaMail.evans@thyme>"                    
 [2] "Date: Mon, 14 May 2001 19:36:00 -0700 (PDT)"                                 
 [3] "From: vmartinez@winstead.com"                                                
 [4] "To: kenneth.lay@enron.com"                                                   
 [5] "Subject: Request for meeting -- Subject: short speech to US Olympic Commit"  
 [6] "\ttee 7.16-19.01"                                                            
 [7] "Mime-Version: 1.0"                                                           
 [8] "Content-Type: text/plain; charset=us-ascii"                                  
 [9] "Content-Transfer-Encoding: 7bit"                                             
[10] "X-From: Martinez, Vidal  <VMartinez@winstead.com>"                           
[11] "X-To: Kenneth L. Lay (E-mail)  <kenneth.lay@enron.com>"                      
[12] "X-cc: "                                                                      
[13] "X-bcc: "                                                                     
[14] "X-Folder: \\Lay, Kenneth\\Lay, Kenneth\\Inbox"                               
[15] "X-Origin: LAY-K"                                                             
[16] "X-FileName: Lay, Kenneth.pst"                                                
[17] ""                                                                            
[18] "Ken,"                                                                        
[19] ""                                                                            
[20] "Houston's bid for the 2012 Olympic Games is entering the final phase of the" 
[21] "domestic bid process.  This summer, the United States Olympic Committee"     
[22] "(USOC) will conduct initial site visits and evaluations of the eight U.S."   
[23] "bid cities with the goal being to cut the number of cities to three or four."
[24] "This cut will occur in December of this year.  The USOC will be conducting"  
[25] "Houston's site visit July 16-19, 2001."                                      
[26] ""                                                                            
[27] "This site visit is critical to our ultimate success in bringing the Olympic" 
[28] "Games to Houston.  Over the four-day period in which the USOC site"          
[29] "evaluation team is in Houston, two days will be devoted to venue tours and"  
[30] "presentations.  There are eight presentation topics predetermined by the"    
[31] "USOC, one of which is International Strategy. Simply stated, this is where"  
[32] "we show why we think Houston can win on the international level."            
[33] ""                                                                            
[34] "As a Port Commissioner and a board member of Houston 2012, I will be part of"
[35] "the team that presents this section to the USOC site evaluation team.  As"   
[36] "arguably the most identifiable international corporate leader in Houston and"
[37] "as the Chairman of the 1990 Economic Summit and the 1992 Republican National"
[38] "Convention, both of which you left with a positive surplus (very important"  
[39] "to the Olympics), you are in an excellent position to discuss Houston's"     
[40] "international status."                                                       
[41] ""                                                                            
[42] "George DeMontrond, Susan Bandy (the Houston 2012 Exec Director) and I would" 
[43] "very much appreciate 15 minutes or so of your time to update you on"         
[44] "Houston's bid efforts and discuss your potential participation in the"       
[45] "upcoming site visit. You are our first and only choice, and I'd like the"    
[46] "opportunity to show you how important this is for Houston. We expect the"    
[47] "number of U.S. bid cities to be reduced to four finalists by this December"  
[48] "as a result of these meetings.  I will call Rosalee to schedule a time for a"
[49] "visit at your offices. All the best and I look forward to catching up with"  
[50] "you soon. I'm attaching my bio, which details the last few years of activity"
[51] "I've been involved with, most of which emanated from your support for me on" 
[52] "the UH Board of Regents, the 1990 Economic Summit Host Committee, the 1992"  
[53] "RNC Convention and later the GHP. Thank you for everything you've done for"  
[54] "Sarah and me -- hopefully I've reciprocated by doing a good job for you each"
[55] "time."                                                                       
[56] ""                                                                            
[57] "All the best, Vidal"                                                         
[58] ""                                                                            
[59] "Vidal G. Martinez"                                                           
[60] "Winstead Sechrest & Minick P.C."                                             
[61] "910 Travis"                                                                  
[62] "2400 Bank One Center"                                                        
[63] "Houston, Texas 77002"                                                        
[64] "E-mail: vidal@martinez.net"                                                  
[65] "Direct Tel:  713.650.2737"                                                   
[66] "Fax:  713.650.2400"                                                          
[67] "Cellular:  713.705.1310"                                                     
[68] "Mobile PDA E-mail: vidal@goamerica.net"                                      
~~~
{:.output}

<!--split-->


~~~r
str_match(content(docs[[1]])[1:10], '^From: (.*)$')
~~~
{:.text-document title="lesson-8.R"}
~~~
      [,1]                           [,2]                    
 [1,] NA                             NA                      
 [2,] NA                             NA                      
 [3,] "From: vmartinez@winstead.com" "vmartinez@winstead.com"
 [4,] NA                             NA                      
 [5,] NA                             NA                      
 [6,] NA                             NA                      
 [7,] NA                             NA                      
 [8,] NA                             NA                      
 [9,] NA                             NA                      
[10,] NA                             NA                      
~~~
{:.output}

<!--split-->

## Extract structured data


~~~r
for (idx in seq(docs)) {
  match <- str_match(content(docs[[idx]]), '^From: (.*)$')
  from <- match[!is.na(match[, 1]), 2]
  meta(docs[[idx]], "author") <- from[[1]]
}
~~~
{:.text-document title="lesson-8.R"}


~~~r
meta(docs[[1]])
~~~
{:.input}
~~~
  author       : vmartinez@winstead.com
  datetimestamp: 2016-09-23 21:25:20
  description  : character(0)
  heading      : character(0)
  id           : 1.txt
  language     : en
  origin       : character(0)
~~~
{:.output}

<!--split-->

## Text mining

Extracting measurements of quantitative varialbes from unstructured information is the "field-work" component of research projects that rely on texts for empirical observations.

- Searching strings for patterns.
- Cleaning documents of un-informative strings.
- Quantifying string occurrences and associations.

<!--split-->

## Isolate the unstructured information


~~~r
for (idx in seq(docs)) {
  header_last <- str_match(content(docs[[idx]]), '^X-FileName:')
  header_last_idx <- which(!is.na(header_last))
  header_last_idx <- header_last_idx[[1]]
  content(docs[[idx]]) <- content(docs[[idx]])[-(1:header_last_idx)]
}
~~~
{:.text-document title="lesson-8.R"}

<!--split-->

## Functions for cleaning strings


~~~r
docs <- tm_map(docs, removePunctuation)

docs <- tm_map(docs, removeNumbers)

docs <- tm_map(docs, content_transformer(tolower))

docs <- tm_map(docs, removeWords, stopwords("english"))

docs <- tm_map(docs, removeWords, c("department", "email"))

docs <- tm_map(docs, stemDocument)

docs <- tm_map(docs, stripWhitespace)
~~~
{:.text-document title="lesson-8.R"}

<!--split-->

## Create Bag-Of-Words Matrix


~~~r
dtm <- DocumentTermMatrix(docs)
inspect(dtm[1:5, 1:10])
~~~
{:.text-document title="lesson-8.R"}
~~~
<<DocumentTermMatrix (documents: 5, terms: 10)>>
Non-/sparse entries: 0/50
Sparsity           : 100%
Maximal term length: 26
Weighting          : term frequency (tf)

          Terms
Docs       aacddacadbccbbdfdhcppdqnet aacrncieortc aaikinhoustonorg
  1.txt                             0            0                0
  10.txt                            0            0                0
  100.txt                           0            0                0
  1001.txt                          0            0                0
  1002.txt                          0            0                0
          Terms
Docs       aaimmgm aama aanstoo aanstoosaliceenroncom aapl aarhus aaron
  1.txt          0    0       0                     0    0      0     0
  10.txt         0    0       0                     0    0      0     0
  100.txt        0    0       0                     0    0      0     0
  1001.txt       0    0       0                     0    0      0     0
  1002.txt       0    0       0                     0    0      0     0
~~~
{:.output}

<!--split-->


~~~r
dense_dtm <- removeSparseTerms(dtm, 1 - 10 / length(docs))
inspect(dense_dtm[1:5, 1:10])
~~~
{:.text-document title="lesson-8.R"}
~~~
<<DocumentTermMatrix (documents: 5, terms: 10)>>
Non-/sparse entries: 2/48
Sparsity           : 96%
Maximal term length: 7
Weighting          : term frequency (tf)

          Terms
Docs       abil abl abraham absenc absolut abus academ acceler accept
  1.txt       0   0       0      0       0    0      0       0      0
  10.txt      0   0       0      0       0    0      0       0      0
  100.txt     0   0       0      0       0    0      0       0      0
  1001.txt    0   0       0      0       0    0      0       0      1
  1002.txt    0   0       0      0       0    0      0       0      0
          Terms
Docs       access
  1.txt         0
  10.txt        0
  100.txt       0
  1001.txt      4
  1002.txt      0
~~~
{:.output}

<!--split-->


~~~r
freq <- findFreqTerms(dtm, 360)
freq
~~~
{:.text-document title="lesson-8.R"}
~~~
 [1] "also"                         "bit"                         
 [3] "board"                        "busi"                        
 [5] "call"                         "can"                         
 [7] "center"                       "charsetusascii"              
 [9] "compani"                      "contenttransferencod"        
[11] "contenttyp"                   "date"                        
[13] "day"                          "develop"                     
[15] "employe"                      "energi"                      
[17] "enron"                        "get"                         
[19] "help"                         "houston"                     
[21] "inform"                       "issu"                        
[23] "javamailevansthym"            "john"                        
[25] "just"                         "ken"                         
[27] "kenneth"                      "kennethinbox"                
[29] "kennethlayenroncom"           "kennethlaymarlay"            
[31] "klay"                         "klayenroncom"                
[33] "know"                         "lay"                         
[35] "layk"                         "like"                        
[37] "make"                         "manag"                       
[39] "mani"                         "mark"                        
[41] "market"                       "may"                         
[43] "meet"                         "messag"                      
[45] "messageid"                    "mimevers"                    
[47] "need"                         "new"                         
[49] "nonprivilegedinbox"           "nonprivilegedpst"            
[51] "now"                          "oct"                         
[53] "oenronounacnrecipientscnklay" "offic"                       
[55] "one"                          "pdt"                         
[57] "peopl"                        "pleas"                       
[59] "power"                        "provid"                      
[61] "pst"                          "receiv"                      
[63] "report"                       "see"                         
[65] "sent"                         "servic"                      
[67] "subject"                      "take"                        
[69] "textplain"                    "thank"                       
[71] "time"                         "use"                         
[73] "want"                         "will"                        
[75] "work"                         "xbcc"                        
[77] "xcc"                          "xfilenam"                    
[79] "xfolder"                      "xfrom"                       
[81] "xorigin"                      "xto"                         
[83] "year"                        
~~~
{:.output}

<!--split-->

## Associations


~~~r
assoc <- findAssocs(dtm, "houston", 0.5)
assoc
~~~
{:.text-document title="lesson-8.R"}
~~~
$houston
                            center                    hgeeharrygeecom 
                              0.54                               0.54 
                             medic               phobbygenesisparkcom 
                              0.54                               0.54 
                              texa                          methodist 
                              0.54                               0.53 
                               gee                             regent 
                              0.52                               0.51 
                           smalley                brendajblackfemagov 
                              0.51                               0.50 
                brentkinguthtmcedu                      custocoaircom 
                              0.50                               0.50 
               dwangmetrobanknacom                      jlynchslehcom 
                              0.50                               0.50 
         jporrettadminhscuthtmcedu                      laurapflfwcom 
                              0.50                               0.50 
                 mariamicompctrcom                  mdebakeybcmtmcedu 
                              0.50                               0.50 
mdesvigneskendrickcityofhoustonnet                    mhalboutyaolcom 
                              0.50                               0.50 
                    nrapoportuhedu                 skarffsphuthtmcedu 
                              0.50                               0.50 
             thomashorvathmedvagov 
                              0.50 
~~~
{:.output}


~~~r
cor(as.matrix(dtm[, c("houston", "anderson")]))
~~~
{:.text-document title="lesson-8.R"}
~~~
           houston  anderson
houston  1.0000000 0.4641603
anderson 0.4641603 1.0000000
~~~
{:.output}

<!--split-->

## Content analysis

RQDA
: A GUI tool (like NVivo, Atlas.ti) to assist manual coding of text.

<!--split-->

## Topic modeling

This involves machine learning. We have not found an R package yet that has good turnkey algorithms for topic modeling.

<!--split-->

## Analysis of Qualitative Data

Methods of analysis for qualitative data -- as defined in this lesson -- fall outside the scope of machine learning tools we are familiar with. In the future, we hope to address vizualization tools for qualitative data and are learning about relavant analytical methods.

"Analysis is the process of describing and then making inferences based on a set of data. To make an inference means to combine data with something else, say a set of assumptions or theories or more general knowledge, and draw a conclusion that goes beyond what the data themselves present." ~ Cox, M. 2015.
