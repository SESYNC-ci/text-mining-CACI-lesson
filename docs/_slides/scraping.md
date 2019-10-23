---
---

## Scraping

For text analysis, whether online or following document OCR, few tools are as useful for pulling
out strings that represent a value than "regular expressions".

===

![Text](https://imgs.xkcd.com/comics/regular_expressions.png "Wait, forgot to escape a space. Wheeeeee[taptaptap]eeeeee.")  
*by Randall Munroe / [CC BY-NC](http://xkcd.com/license.html)*
{:.captioned}

===

RegEx is a very flexible, and very fast, program for finding bits of text within
a document that has particular features defined as a "pattern".

| Pattern      | String with <span style="color:red;">match</span>                                    |
|--------------+--------------------------------------------------------------------------------------|
| Subject:.\*  | <span style="color:red;">Subject: Re: TPS Reports</span>                             |
| \\$[0-9,]+   | The ransom of <span style="color:red;">$1,000,000</span> to Dr. Evil.                |
| \b\S+@\S+\b  | E-mail <span style="color:red;">info@sesync.org</span> or tweet @SESYNC for details! |

===

Note that "\" must be escaped in R, so the third pattern does not look very
nice in a R string.



~~~r
library(stringr)

str_extract_all(
  'Email info@sesync.org or tweet @SESYNC for details!',
  '\\b\\S+@\\S+\\b')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
[[1]]
[1] "info@sesync.org"
~~~
{:.output}


===

Continuing with the Enron emails theme, begin by collecting the documents for
analysis with the **tm** package.



~~~r
library(tm)

enron <- VCorpus(DirSource("data/enron"))
email <- enron[[1]]
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> meta(email)
~~~
{:title="Console" .input}


~~~
  author       : character(0)
  datetimestamp: 2019-10-23 18:10:02
  description  : character(0)
  heading      : character(0)
  id           : 10001529.1075861306591.txt
  language     : en
  origin       : character(0)
~~~
{:.output}


===



~~~r
> content(email)
~~~
{:title="Console" .input}


~~~
 [1] "Message-ID: <10001529.1075861306591.JavaMail.evans@thyme>"                                        
 [2] "Date: Wed, 7 Nov 2001 13:58:24 -0800 (PST)"                                                       
 [3] "From: dutch.quigley@enron.com"                                                                    
 [4] "To: frthis@aol.com"                                                                               
 [5] "Subject: RE: seeing as mark won't answer my e-mails...."                                          
 [6] "Mime-Version: 1.0"                                                                                
 [7] "Content-Type: text/plain; charset=us-ascii"                                                       
 [8] "Content-Transfer-Encoding: 7bit"                                                                  
 [9] "X-From: Quigley, Dutch </O=ENRON/OU=NA/CN=RECIPIENTS/CN=DQUIGLE>"                                 
[10] "X-To: 'Frthis@aol.com@ENRON'"                                                                     
[11] "X-cc: "                                                                                           
[12] "X-bcc: "                                                                                          
[13] "X-Folder: \\DQUIGLE (Non-Privileged)\\Quigley, Dutch\\Sent Items"                                 
[14] "X-Origin: Quigley-D"                                                                              
[15] "X-FileName: DQUIGLE (Non-Privileged).pst"                                                         
[16] ""                                                                                                 
[17] "yes please on the directions"                                                                     
[18] ""                                                                                                 
[19] ""                                                                                                 
[20] " -----Original Message-----"                                                                      
[21] "From: \tFrthis@aol.com@ENRON  "                                                                   
[22] "Sent:\tWednesday, November 07, 2001 3:57 PM"                                                      
[23] "To:\tsiva66@mail.ev1.net; MarkM@cajunusa.com; Wolphguy@aol.com; martier@cpchem.com; klyn@pdq.net" 
[24] "Cc:\tRs1119@aol.com; Quigley, Dutch; john_riches@msn.com; jramirez@othon.com; bwdunlavy@yahoo.com"
[25] "Subject:\tRe: seeing as mark won't answer my e-mails...."                                         
[26] ""                                                                                                 
[27] "Kingwood Cove it is! "                                                                            
[28] "Sunday "                                                                                          
[29] "Tee Time(s):  8:06 and 8:12 "                                                                     
[30] "Cost - $33 (includes cart) - that will be be $66 for Mr. 2700 Huevos. "                           
[31] "ernie "                                                                                           
[32] "Anyone need directions?"                                                                          
~~~
{:.output}


===

The RegEx pattern `^From: .*` matches any whole line that begins with "From: ".
Parentheses cause parts of the match to be captured for substitution or
extraction.



~~~r
match <- str_match(content(email), '^From: (.*)')
head(match)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
     [,1]                            [,2]                     
[1,] NA                              NA                       
[2,] NA                              NA                       
[3,] "From: dutch.quigley@enron.com" "dutch.quigley@enron.com"
[4,] NA                              NA                       
[5,] NA                              NA                       
[6,] NA                              NA                       
~~~
{:.output}


===

## Data Extraction

The `meta` object for each e-mail was sparsely populated, but some of those
variables can be extracted from the `content`.

===



~~~r
enron <- tm_map(enron, function(email) {
  body <- content(email)
  match <- str_match(body, '^From: (.*)')
  match <- na.omit(match)
  meta(email, 'author') <- match[[1, 2]]
  return(email)
})
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> email <- enron[[1]]
> meta(email)
~~~
{:title="Console" .input}


~~~
  author       : dutch.quigley@enron.com
  datetimestamp: 2019-10-23 18:10:02
  description  : character(0)
  heading      : character(0)
  id           : 10001529.1075861306591.txt
  language     : en
  origin       : character(0)
~~~
{:.output}

