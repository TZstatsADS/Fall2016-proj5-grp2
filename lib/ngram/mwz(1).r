# library(RCurl)
# library(XML)
# get_Lyrics = function(artist, song) {
#   
#   baseurl = "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?"
#   artist = artist
#   song = song
#   url = paste0(baseurl,"artist=",artist,"&song=",song)
#   url = URLencode(url)
#   con = getURL(url)
#   doc = htmlParse(con)
#   
#   res = try({ Lyrics = xmlValue(doc[["/html/body/getlyricresult/lyric/text()"]])})
#   if(class(res) == "try-error") Lyrics = ""
#   data.frame(artist = artist, song = song, Lyrics = Lyrics)
# }
# 
# Billboard = read.csv("billboard-2.0-index.csv", stringsAsFactors = F)
# 
# 
# 
# 
# whole_data = NULL
# artists = Billboard$artist
# songs = Billboard$title
# 
# a = which(artists == "")
# b = which(songs == "")
# all.equal(a,b)
# 
# artists = artists[-a]
# songs = songs[-b]
# 
# suppressMessages(
# suppressWarnings(
# for(i in 1:length(songs)) {
#   artist = artists[i]
#   song = songs[i]
#   res = get_Lyrics(artist, song)
#   whole_data = rbind(whole_data, res)
# }
# )
# )
# 
# write.csv(whole_data, file = 'whole_data.csv', row.names = F)
# 
# lyrics = whole_data$Lyrics
# names(lyrics) = whole_data$song
# lyrics_use = as.character(lyrics[lyrics != ""])
# 
# library(NLP)
# #read file
# library(tm)
# 
# #convert encoding
# lyrics_use=enc2utf8(lyrics_use)
# 
# #generate corpus
# doc.vec = VectorSource(lyrics_use)
# doc.corpus = Corpus(doc.vec)
# 
# #pretreatment: remove stop words, numbers, spaces and messy code
# doc.corpus = tm_map(doc.corpus, tolower)
# doc.corpus = tm_map(doc.corpus, removePunctuation)
# doc.corpus = tm_map(doc.corpus, removeNumbers)
# doc.corpus = tm_map(doc.corpus, removeWords, stopwords("english"))
# 
# library(SnowballC)
# doc.corpus = tm_map(doc.corpus, stemDocument)
# doc.corpus = tm_map(doc.corpus, stripWhitespace)
# doc.corpus= tm_map(doc.corpus,PlainTextDocument)
# 
# #generate DTM
# TDM = TermDocumentMatrix(doc.corpus)
# DTM = DocumentTermMatrix(doc.corpus)
# 
# library("slam")
# #extract key words
# term_tfidf =tapply(DTM$v/row_sums(DTM)[DTM$i], DTM$j, mean) *log2(nDocs(DTM)/col_sums(DTM > 0))
# DTM = DTM[,term_tfidf >= 0.1]
# DTM = DTM[row_sums(DTM) > 0,]
# 
# library("topicmodels")
# #construct LDA model
# lda.lyrics_use= LDA(DTM, k = 5, method="VEM", control = list(seed = 1500))
# summary(lda.lyrics_use)
# 
# #topic of each song
# topic1=topics(lda.lyrics_use,1)
# data.frame(topic1)
# #key words of each topic
# terms(lda.lyrics_use, 20)
# # 
# # Topic 1     Topic 2      Topic 3                Topic 4     Topic 5     
# # [1,] "sweet"     "wait"       "kiss"                 "hot"       "people"    
# # [2,] "talking"   "bop"        "crazy"                "gettin"    "work"      
# # [3,] "buy"       "carolina"   "lonely"               "everybody" "many"      
# # [4,] "guy"       "goin"       "roll"                 "couldnt"   "home"      
# # [5,] "world"     "bopathey"   "rock"                 "heat"      "punk"      
# # [6,] "money"     "bopawe"     "hurts"                "dying"     "rock"      
# # [7,] "freedom"   "bopbe"      "list"                 "looking"   "ohh"       
# # [8,] "moving"    "bophe"      "living"               "kept"      "person"    
# # [9,] "much"      "bopshe"     "dumdumdumdumdydoowah" "rock"      "loveydovey"
# # [10,] "diamond"   "bopyou"     "two"                  "gun"       "rose"      
# # [11,] "floating"  "simply"     "lord"                 "smokin"    "times"     
# # [12,] "ahead"     "moonshine"  "refrain"              "chicago"   "worry"     
# # [13,] "drifting"  "oopshe"     "much"                 "decide"    "world"     
# # [14,] "outta"     "worth"      "half"                 "middle"    "carrie"    
# # [15,] "screamin"  "addrisi"    "indiana"              "sign"      "luckiest"  
# # [16,] "looking"   "asbury"     "miss"                 "fry"       "mashpotato"
# # [17,] "everybody" "asked"      "oohyayyayyayyeah"     "somebody"  "much"      
# # [18,] "chicago"   "cocktail"   "resist"               "sometime"  "twist"     
# # [19,] "dying"     "earthquake" "wants"                "sweat"     "woohoo"    
# # [20,] "rose"      "fancy"      "ohohohohwah"          "sweet"     "special" 
# 
# ###source code from github
# topicmodels_json_ldavis <- function(fitted, corpus, doc_term){
#   # Required packages
#   library(topicmodels)
#   library(dplyr)
#   library(stringi)
#   library(tm)
#   library(LDAvis)
#   
#   # Find required quantities
#   phi <- posterior(fitted)$terms %>% as.matrix
#   theta <- posterior(fitted)$topics %>% as.matrix
#   vocab <- colnames(phi)
#   doc_length <- vector()
#   for (i in 1:length(corpus)) {
#     temp <- paste(corpus[[i]]$content, collapse = ' ')
#     doc_length <- c(doc_length, stri_count(temp, regex = '\\S+'))
#   }
#   temp_frequency <- inspect(doc_term)
#   freq_matrix <- data.frame(ST = colnames(temp_frequency),
#                             Freq = colSums(temp_frequency))
#   rm(temp_frequency)
#   
#   # Convert to json
#   json_lda <- LDAvis::createJSON(phi = phi, theta = theta,
#                                  vocab = vocab,
#                                  doc.length = doc_length,
#                                  term.frequency = freq_matrix$Freq)
#   
#   return(json_lda)
# }
# 
# ####
# json = topicmodels_json_ldavis(lda.lyrics_use,Corpus(doc.vec),DTM)
# serVis(json, out.dir = 'vis', open.browser = FALSE)


library(ngram)

x = load("C:/Users/Administrator/Desktop/cleaned_data.RData")


# tonic: 1006段旋律各自对应的tonic
# all.chord: 1006段旋律的chord list，每段旋律的第一个元素对应歌曲编号（按文件名的编号）
# chord.dictionary: 没有normalize之前，所有chord的种类（共955种）
# song use: usde songs


chord_use_positions = sapply(all.chord, function(x) x[1])
#remove last duplicated 1300
chord_use_positions = head(chord_use_positions,-1)
chord_use_positions = as.integer(chord_use_positions)
chord_use = head(all.chord,-1)
names(chord_use) = chord_use_positions
#find the used song  chord
match_pos = match(songuse$id, chord_use_positions)
pos = na.omit(as.character(chord_use_positions[match_pos]))
chord_use = chord_use[pos]  #872 songs actual
#name use the song used id and remove the first id in list
names(chord_use) = pos
chord_use = lapply(chord_use, function(x) x[-1])

#concatenate chords
chord_use_concatenated = lapply(chord_use, concatenate, 
                                collapse = " ", rm.space = FALSE)

#2-grams   872 songs in total
chord_use_2_grams = lapply(chord_use_concatenated, ngram, n = 2, sep = " ")


#show example results
get.phrasetable(chord_use_2_grams[[1]])

#regenerate with same 2-grams chords  
babble(chord_use_2_grams[[1]], genlen = wordcount(chord_use_concatenated[[1]]),
       seed=1234)

get.phrasetable(chord_use_2_grams[[10]])

babble(chord_use_2_grams[[10]], genlen = wordcount(chord_use_concatenated[[10]]),
       seed=1234)

get.phrasetable(chord_use_2_grams[[400]])

babble(chord_use_2_grams[[400]], genlen = wordcount(chord_use_concatenated[[400]]),
       seed=1234)

#3-grams 
chord_use_3_grams = lapply(chord_use_concatenated, ngram, n = 3, sep = " ")


get.phrasetable(chord_use_3_grams[[1]])

#regenerate with same 2-grams chords  
babble(chord_use_3_grams[[1]], genlen = wordcount(chord_use_concatenated[[1]]),
       seed=1234)

get.phrasetable(chord_use_3_grams[[10]])

babble(chord_use_3_grams[[10]], genlen = wordcount(chord_use_concatenated[[10]]),
       seed=1234)

get.phrasetable(chord_use_3_grams[[400]])

babble(chord_use_3_grams[[400]], genlen = wordcount(chord_use_concatenated[[400]]),
       seed=1234)



#4-grams 
chord_use_4_grams = lapply(chord_use_concatenated, ngram, n = 4, sep = " ")


get.phrasetable(chord_use_4_grams[[1]])

#regenerate with same 2-grams chords  
babble(chord_use_4_grams[[1]], genlen = wordcount(chord_use_concatenated[[1]]),
       seed=1234)

get.phrasetable(chord_use_2_grams[[10]])

babble(chord_use_4_grams[[10]], genlen = wordcount(chord_use_concatenated[[10]]),
       seed=1234)

get.phrasetable(chord_use_2_grams[[400]])

babble(chord_use_4_grams[[400]], genlen = wordcount(chord_use_concatenated[[400]]),
       seed=1234)



#topic models for 2-grams

library(tm)
library(topicmodels)
#Manually create DocumentTermMatrix for 2-grams
total_2_grams = lapply(chord_use_2_grams, function(x) {
  
  a =  get.phrasetable(x)
  a$ngrams
})

total_2_grams = unlist(total_2_grams)
total_2_grams = unique(total_2_grams)

fill_DTM = lapply(chord_use_2_grams, function(x) {
  
  a =  get.phrasetable(x)
  pos = match(a$ngrams,total_2_grams)
  vec = rep(0, length(total_2_grams))
  vec[pos] = a$freq
  vec
})

#DTM is now 872X6432 song and 2-grams matrix, 6432 is the total unique 2 grams
DTM = do.call('rbind', fill_DTM)
colnames(DTM) = total_2_grams
rownames(DTM) = names(chord_use_2_grams)








