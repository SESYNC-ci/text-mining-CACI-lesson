---
---

## Scraping

![Text](http://imgs.xkcd.com/comics/regular_expressions.png "Wait, forgot to escape a space. Wheeeeee[taptaptap]eeeeee.")  
*by Randall Munroe / [CC BY-NC](http://xkcd.com/license.html)*
{:.captioned}

===

RegEx is a very flexible, and very fast, program for parsing text.

| Pattern     | Match                                                                 |
|-------------+-----------------------------------------------------------------------|
| Subject:.\*  | <span style="color:red;">Subject: Re: TPS Reports</span>              |
| \\$[0-9,]+   | The ransom of <span style="color:red;">$1,000,000</span> to Dr. Evil. |
| \b\S+@\S+\b  | Send comments to <span style="color:red;">info@sesync.org</span>.     |

Note that "\\" must be escaped in R, so the first pattern would be scripted as `"\\$[0-9,]+"`.

===


~~~r
install.packages(c("tm", "SnowballC", "stringr"))
~~~
{:.input}

Also, download text files with a mix of structured and unstructurd information from <http://sesync.us/g5>.

===


~~~r
library(tm)
library(SnowballC)
library(stringr)

docs <- Corpus(DirSource("data/texts"))  # Put your texts here via your file explorer/finder
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
meta(docs[[1]])
~~~
{:.input}
~~~
  author       : character(0)
  datetimestamp: 2016-12-01 20:41:31
  description  : character(0)
  heading      : character(0)
  id           : 1.txt
  language     : en
  origin       : character(0)
~~~
{:.output}

===


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

===


~~~r
str_match(content(docs[[1]])[1:10], '^From: (.*)$')
~~~
{:.input}
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

===

## Extract structured data


~~~r
for (idx in seq(docs)) {
  match <- str_match(content(docs[[idx]]), '^From: (.*)$')
  from <- match[!is.na(match[, 1]), 2]
  meta(docs[[idx]], "author") <- from[[1]]
}
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
meta(docs[[1]])
~~~
{:.input}
~~~
  author       : vmartinez@winstead.com
  datetimestamp: 2016-12-01 20:41:31
  description  : character(0)
  heading      : character(0)
  id           : 1.txt
  language     : en
  origin       : character(0)
~~~
{:.output}
