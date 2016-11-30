---
---

## Text mining

Extracting measurements of quantitative varialbes from unstructured information is the "field-work" component of research projects that rely on texts for empirical observations.

- Searching strings for patterns.
- Cleaning documents of un-informative strings.
- Quantifying string occurrences and associations.

===

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

===

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

===

## Create Bag-Of-Words Matrix


~~~r
dtm <- DocumentTermMatrix(docs)
inspect(dtm[1:5, 1:10])
~~~

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
{:.text-document title="lesson-8.R"}

===


~~~r
dense_dtm <- removeSparseTerms(dtm, 1 - 10 / length(docs))
inspect(dense_dtm[1:5, 1:10])
~~~

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
{:.text-document title="lesson-8.R"}

===


~~~r
freq <- findFreqTerms(dtm, 360)
freq
~~~

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
{:.text-document title="lesson-8.R"}

===

## Associations


~~~r
assoc <- findAssocs(dtm, "houston", 0.5)
assoc
~~~

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
{:.text-document title="lesson-8.R"}


~~~r
cor(as.matrix(dtm[, c("houston", "anderson")]))
~~~

~~~
           houston  anderson
houston  1.0000000 0.4641603
anderson 0.4641603 1.0000000
~~~
{:.text-document title="lesson-8.R"}
