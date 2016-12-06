library(ngram)

load("cleaned_data.Rdata")

#chord.str<-paste(all.chord[[1]][-1],collapse=" ")
#NG<-ngram(chord.str, n=4)
#get.phrasetable(NG)

chords2Gram<-list()
#chords4Gram<-list()

for(k in 1:length(all.chord)){
  chord.str<-paste(all.chord[[k]][-1], collapse=" ") 
  N2G<-ngram(chord.str, n=2)
  chords2Gram[[k]]<-get.phrasetable(N2G)
  
  #N4G<-ngram(chord.str, n=4)
  #chords4Gram[[k]]<-get.phrasetable(N4G)
  
}

save(chords2Gram,file = "chords2Gram.rdata")
save(chords4Gram,file = "chords4Gram.rdata")





######################################################
#devtools::install_github("mattflor/chorddiag")
library(chorddiag)

##### For each song #####

#chord.str<-paste(all.chord[[1]][-1], collapse=" ") 
#NG<-ngram(chord.str, n=2)
#get.phrasetable(NG)


library(reshape2)
#df <- data.frame(transform(chords2Gram[[4]], ngrams= colsplit(ngrams, pattern = '\\s', names = c('from', 'to'))))
df <- chords2Gram[[429]]
X<-with(df, cbind( colsplit(df$ngrams, pattern = "\\s", names = c('from', 'to')),freq))
X$to <- gsub('\\s', '', X$to) #for consistency,remove the redundant space in each element of 2nd col
tmp<-acast(X,from~to,value.var='freq')
tmp[is.na(tmp)]<-0

dimnames(tmp) <- list(from = colnames(tmp), to = colnames(tmp))
#groupColors <- c("#000000", "#FFDD89", "#957244", "#F26223")
chorddiag(tmp,groupnameFontsize=12,groupnamePadding = 20)



##### group as genre #####
Genres<-read.csv('with_genre.csv')

## classical rock as an example
library(dplyr)
rock_id<-filter(Genres,Genre=='classic rock')[,'id']


rock_chord<-list() 
j=1
for(i in 1:length(all.chord)){
  if(as.numeric(all.chord[[i]][1]) %in% rock_id){
    rock_chord[[j]]<-all.chord[[i]]
    j<-j+1
  }
}


#combine all chords in rock
for(k in 1:length(rock_chord)){

  tmp.str<-paste(rock_chord[[k]][-1], collapse=" ") 
  if(k==1){
    rock.chord.str<-tmp.str
  }
  else{
    rock.chord.str<-paste(rock.chord.str,tmp.str)
  }
  rock.chord.str<-paste(rock.chord.str,"\n")
}
#cat(rock.chord.str)

NG<-ngram(rock.chord.str, n=2)
Rock2Gram<-get.phrasetable(NG)

df<-Rock2Gram
X<-with(df, cbind( colsplit(df$ngrams, pattern = "\\s", names = c('from', 'to')),freq))
X$to <- gsub('\\s', '', X$to)
tmp<-acast(X,from~to,value.var='freq')
tmp[is.na(tmp)]<-0

######## in case the dim of row and col don't match??? 
#r<-nrow(tmp)
#c<-ncol(tmp)
#DimChord<-max(r,c)
#MChord<-matrix(0,DimChord,DimChord)

#if(c==r){
#  MChord<-tmp
#}else if(c>r){
#  rownames(MChord)<-colnames(tmp)
#  colnames(MChord)<-colnames(tmp)
#  for(i in 1:c){
#    if(rownames(tmp)[i] %in% colnames(tmp)){
#      MChord[i,]<-tmp[i,]
#    }
#  }
#}


dimnames(tmp) <- list(from = colnames(tmp), to = colnames(tmp))

#groupColors <- c("#000000", "#FFDD89", "#957244", "#F26223")
chorddiag(tmp,groupnameFontsize=8,groupnamePadding = 20,showTicks = FALSE)






################## for standardized data #################

SD2Gram<-list()


for(k in 1:length(all.chord.sd)){
  sd.str<-paste(all.chord.sd[[k]][-1], collapse=" ") 
  N2G<-ngram(sd.str, n=2)
  SD2Gram[[k]]<-get.phrasetable(N2G)
}



## for each song ##
df <- SD2Gram[[100]]
X<-with(df, cbind( colsplit(df$ngrams, pattern = "\\s", names = c('from', 'to')),freq))
X$to <- gsub('\\s', '', X$to) #for consistency,remove the redundant space in each element of 2nd col
tmp<-acast(X,from~to,value.var='freq')
tmp[is.na(tmp)]<-0

dimnames(tmp) <- list(from = colnames(tmp), to = colnames(tmp))
chorddiag(tmp,groupnameFontsize=12,groupnamePadding = 20)


## grouped by genres

rock_id<-filter(Genres,Genre=='classic rock')[,'id']

rock_chord_sd<-list() 
j=1
for(i in 1:length(all.chord.sd)){
  if(as.numeric(all.chord.sd[[i]][1]) %in% rock_id){
    rock_chord_sd[[j]]<-all.chord.sd[[i]]
    j<-j+1
  }
}

#combine all chords in rock
for(k in 1:length(rock_chord_sd)){
  
  tmp.str<-paste(rock_chord_sd[[k]][-1], collapse=" ") 
  if(k==1){
    rock.chord.sd.str<-tmp.str
  }
  else{
    rock.chord.sd.str<-paste(rock.chord.sd.str,tmp.str)
  }
  rock.chord.sd.str<-paste(rock.chord.sd.str,"\n")
}


NG<-ngram(rock.chord.sd.str, n=2)
RockSD2Gram<-get.phrasetable(NG)
#babble(NG,16,seed = getseed())

df<-RockSD2Gram
X<-with(df, cbind( colsplit(df$ngrams, pattern = "\\s", names = c('from', 'to')),freq))
X$to <- gsub('\\s', '', X$to)
tmp<-acast(X,from~to,value.var='freq')
tmp[is.na(tmp)]<-0
dimnames(tmp) <- list(from = colnames(tmp), to = colnames(tmp))


chorddiag(tmp,groupnameFontsize=8,groupnamePadding = 20,showTicks = FALSE)


#############################################################
### another package. compare ###
library(circlize)
df <- SD2Gram[[100]]
X<-with(df, cbind( colsplit(df$ngrams, pattern = "\\s", names = c('from', 'to')),freq))
X$to <- gsub('\\s', '', X$to) #for consistency,remove the redundant space in each element of 2nd col
tmp<-acast(X,from~to,value.var='freq')
tmp[is.na(tmp)]<-0

dimnames(tmp) <- list(from = colnames(tmp), to = colnames(tmp))
#static
chordDiagram(tmp)
#interactive 
chorddiag(tmp,groupnameFontsize=12,groupnamePadding = 20)





######################################################
library(textir)
data(we8there)
## 20 high-variance tf-idf terms
colnames(we8thereCounts)[order(-sdev(tfidf(we8thereCounts)))[1:20]]


#how to install package Rweka ...need java!!!
#http://justrocketscience.com/post/install-rweka-mac
#https://github.com/s-u/rJava/issues/37
install.packages("rJava","http://rforge.net/",type="source")

library(tm)
library(rJava)
library(RWeka)


data('crude')
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
#BigramTokenizer <- function(x) ngram_asweka(x, min = 2, max = 2, sep = " ")
tdm <- TermDocumentMatrix(crude,
                          control = list(removePunctuation = TRUE,
                                         stopwords = TRUE))
tdm <- TermDocumentMatrix(crude, control = list(tokenize = BigramTokenizer))



BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
tdm <- TermDocumentMatrix(crude, control = list(tokenize = BigramTokenizer))

inspect(tdm[340:345,1:10])

data("crude")

BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
BigramTokenizer <- function(x) ngram(x, 2)
BigramTokenizer <-
  function(x)
    unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
tdm <- TermDocumentMatrix(crude, control = list(tokenize = BigramTokenizer))
inspect(tdm[340:345,1:10])



crude <- as.VCorpus(crude)
crude <- tm_map(crude, stripWhitespace)
crude <- tm_map(crude, content_transformer(tolower))
crude <- tm_map(crude, removeWords, stopwords("english"))
crude <- tm_map(crude, stemDocument)
# Sets the default number of threads to use
options(mc.cores=1)

tdm <- TermDocumentMatrix(crude, control=list(tokenize = BigramTokenizer))













#######################################################################
Genres<-read.csv('with_genre.csv')

filter(Genres,id=='194')[,c(8,9,13)]
genre_1<-c("Rock","Hard rock","House","Musicals","Classic rock","Pop","Pop","Rock","Rock","soul","Blues","Hip-hop","Psychedelic rock","Folk-rock",
  "Classic rock","Hard rock","Pop","Country","Pop","Rock","R&B","World","Holiday","Blues","Pop","Country","World","R&B",
  "Pop","Pop","Country","Country","Rock","Rock","Folk","R&B","Classic rock","Jazz","Rock","Pop","Blues","R&B",
  "Jazz","Funk","Classic rock","Rock","Pop","Rock","Pop","Pop","Rock","Rock","Jazz","Rock and roll","Hard rock","Rock",
  "Disco")
length(genre_1)
save(genre_1,file="genre_1.RData")



####
rock_id<-filter(Genres,Genre=='classic rock')[,'id']


rock.chord.sd.str<-""
j=1
for(i in 1:length(all.chord.sd)){
  if(as.numeric(all.chord.sd[[i]][1]) %in% rock_id){
    tmp.str<-paste(all.chord.sd[[i]][-1], collapse=" ") 
    rock.chord.sd.str<-paste(rock.chord.sd.str,tmp.str)
    rock.chord.sd.str<-paste(rock.chord.sd.str,"\n")
    j<-j+1
  }
}

#


