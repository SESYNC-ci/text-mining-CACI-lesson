library(tm)
library(SnowballC)
library(stringr)

## Load texts into a Corpus

docs <- Corpus(DirSource("data/texts"))
meta(docs[[1]])
content(docs[[1]])

## Simple regex pattern matching

str_match(content(docs[[1]]), '^From: (.*)$')

## Update metadata with extracted string

for (idx in seq(docs)) {
  match <- str_match(content(docs[[idx]]), '^From: (.*)$')
  from <- match[!is.na(match[, 1]), 2]
  meta(docs[[idx]], "author") <- from[[1]]
}

## Isolate unstructured information

for (idx in seq(docs)) {
  header_last <- str_match(content(docs[[idx]]), '^X-FileName:')
  header_last_idx <- which(!is.na(header_last))
  header_last_idx <- header_last_idx[[1]]
  content(docs[[idx]]) <- content(docs[[idx]])[-(1:header_last_idx)]
}

## Preprocessing

docs <- tm_map(docs, removePunctuation)

docs <- tm_map(docs, removeNumbers)

docs <- tm_map(docs, content_transformer(tolower))

docs <- tm_map(docs, removeWords, stopwords("english"))

docs <- tm_map(docs, removeWords, c("department", "email"))

docs <- tm_map(docs, stemDocument)

docs <- tm_map(docs, stripWhitespace)

## Bag-of-words Quantification

dtm <- DocumentTermMatrix(docs)
inspect(dtm[1:5, 1:10])

dense_dtm <- removeSparseTerms(dtm, 1 - 10 / length(docs))
inspect(dense_dtm[1:5, 1:10])

## High frequency terms

freq <- findFreqTerms(dtm, 360)
freq

## Associations

assoc <- findAssocs(dtm, "houston", 0.5)
assoc

cor(as.matrix(dtm[, c("houston", "anderson")]))
