## RegEx

library(...)

enron <- ...(DirSource("data/enron"))

library(...)

match <- str_match(..., '^From: (.*)')


txt <- ...
str_match(txt, '...')

## Data Extraction

enron <- tm_map(enron, ... {
  body <- content(email)
  match <- str_match(body, '^From: (.*)')
  match <- na.omit(match)
  ...(email, 'author') <- match[[1, 2]]
  return(email)
})

## Relational Data Exrtraction

get_to <- function(email) {
  body <- content(email)
  match <- str_detect(body, '^To:')
  if (any(match)) {
    ... <- which(match)[[1]]
    match <- str_detect(body, '^Subject:')
    ... <- which(match)[[1]] - 1
    to <- paste(body[...:...], collapse = '')
    to <- str_extract_all(to, ...)
    return(unlist(to))
  } else {
    return(NA)
  }
}

edges <- ...(enron, FUN = function(email) {
  from <- meta(email, 'author')
  to <- get_to(email)
  return(cbind(from, to))
})
edges <- do.call(..., edges)
edges <- na.omit(edges)
attr(edges, 'na.action') <- NULL

library(...)

g <- ...
plot(...)

## Text Mining

enron <- ...(enron, function(email) {
  body <- content(email)
  match <- str_detect(body, '^X-FileName:')
  begin <- which(match)[[1]] + 1
  match <- str_detect(body, '^[>\\s]*[_\\-]{2}')
  match <- c(match, TRUE)
  end <- which(match)[[1]] - 1
  content(email) <- body[begin:end]
  return(email)
})

## Cleaning Text

library(magrittr)

enron_words <- enron %>%
  tm_map(...) %>%
  tm_map(...) %>%
  tm_map(...)

... <- function(body) {
  match <- str_detect(body, '(http|www|mailto)')
  body[!match]
}

enron_words <- enron_words %>%
  tm_map(...)

## Stopwords and Stems

enron_words <- enron_words %>%
  tm_map(stemDocument) %>%
  tm_map(removeWords, stopwords("english"))

## Bag-of-Words

dtm <- DocumentTermMatrix(enron_words)

## Long Form

library(tidytext)
library(dplyr)
dtt <- ...(dtm)
words <- dtt %>%
  group_by(...) %>%
  summarise(
    n = n(),
    total = sum(count)) %>%
  mutate(nchar = nchar(term))

library(ggplot2)
ggplot(..., aes(...)) +
  geom_histogram(binwidth = 1)

dtt_trimmed <- words %>%
  filter(
    nchar < 16,
    n > 1,
    total > 3) %>%
  select(term) %>%
  inner_join(dtt)

dtm_trimmed <- dtt_trimmed %>%
  ...(document, term, count)

## Term Correlations

word_assoc <- ...(dtm_trimmed, ..., 0.6)
word_assoc <- data.frame(
  word = names(word_assoc[[1]]),
  assoc = word_assoc,
  row.names = NULL)

## Latent Dirichlet allocation

library(topicmodels)

seed = 12345
fit = ...(dtm_trimmed, k = 5, control = list(seed=seed))
... <- as.data.frame(
  posterior(fit, dtm_trimmed)$topics)

library(ggwordcloud)

topics <- ...(fit) %>%
  filter(beta > 0.004)

ggplot(topics,
  aes(size = ..., label = ...)) +
  geom_text_wordcloud_area(rm_outside = TRUE) +
  facet_wrap(vars(topic))
