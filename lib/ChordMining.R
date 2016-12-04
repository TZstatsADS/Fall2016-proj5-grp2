library(dplyr)
library(tm)

load("cleaned_data.Rdata")
Genres<-read.csv('final_genre.csv')



GenreName<-unique(Genres[,'genre'])

All_Genres_Chords<-list()

for(k in GenreName){  # k=Country/Folk/Hip-hop/Jazz/Others/Pop/R&BSoul/Rock)
  genre_id<-filter(Genres,genre==k)[,'id']
  All_Genres_Chords[[k]]<-"" #a string to store all Chords in Genre k
  j=1
  #extract the chords of kth genre 
  for(i in 1:length(all.chord.sd)){
    if(as.numeric(all.chord.sd[[i]][1]) %in% genre_id){
      tmp.str<-paste(all.chord.sd[[i]][-1], collapse=" ") #merge elements into strings
      All_Genres_Chords[[k]]<-paste(All_Genres_Chords[[k]],tmp.str)
      All_Genres_Chords[[k]]<-paste(All_Genres_Chords[[k]],"\n")
      j<-j+1
    }
  }
  
}

##convert list of strings into corpus
chord_corpus <- as.VCorpus(All_Genres_Chords)
corpus_clean <- tm_map(chord_corpus, PlainTextDocument)

BigramTokenizer <-
  function(x)
    unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)


Chord_tdm <- TermDocumentMatrix(corpus_clean, control = list(tokenize = BigramTokenizer))
#inspect(Chord_tdm)
Chord_Matrix<-t(as.matrix(Chord_tdm))
rownames(Chord_Matrix)<-GenreName

tfChord_Matrix<-tfidf(Chord_Matrix,normalize=T)

# 20 high-variance tf-idf terms
colnames(Chord_Matrix)[order(-sdev(tfidf(Chord_Matrix)))[1:20]]


