
library(tm)
library(textir)
library(dplyr)
library(stringi)


load("cleaned_data.Rdata")
Genres<-read.csv('final_genre.csv')

### chord in genre processing

GenreName<-unique(Genres[,'genre'])

All_Genres_Chords<-list()

for(k in GenreName){  # k=R&BSoul/Rock?Pop?Country/Others/Hip-hop/Folk/Jazz)
  genre_id<-filter(Genres,genre==k)[,'id']
  All_Genres_Chords[[k]]<-"" #a string to store all Chords in Genre k
  
  #extract the chords of kth genre 
  for(i in 1:length(all.chord.original.sd)){
    if(as.numeric(all.chord.original.sd[[i]][1]) %in% genre_id){
      tmp.str<-paste(all.chord.original.sd[[i]][-1], collapse=" ") #merge elements into strings
      All_Genres_Chords[[k]]<-paste(All_Genres_Chords[[k]],tmp.str)
      All_Genres_Chords[[k]]<-paste(All_Genres_Chords[[k]],"\n")
      
    }
  }
  
}

#####################################################################
################ TermDocumentMatrix for genres ##################


##convert list of strings into corpus
chord_corpus <- as.VCorpus(All_Genres_Chords)
corpus_clean <- tm_map(chord_corpus, PlainTextDocument)




#####2 Gram
BigramTokenizer <-
  function(x)
    unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)

Genre_tdm2 <- TermDocumentMatrix(corpus_clean, control = list(tokenize = BigramTokenizer))
#tdm2 <- DocumentTermMatrix(corpus_clean, control = list(tokenize = BigramTokenizer, weighting=weightTfIdf))
#inspect(Genre_tdm2)
Genre_Matrix2<-t(as.matrix(Genre_tdm2))
rownames(Genre_Matrix2)<-GenreName
colnames(Genre_Matrix2)<-stri_trans_totitle(colnames(Genre_Matrix2)) #cconvert back the first letter of chord to capital!!!
#apply(Genre_Matrix2, 1, sum)

Genre_Matrix2_tfidf<-tfidf(Genre_Matrix2,normalize=T)

# 20 high-variance tf-idf terms
#colnames(Chord_Matrix)[order(-sdev(tfidf(Chord_Matrix)))[1:20]]

## comparing different version of tfidf
#colnames(Genre_Matrix2_tfidf)[sort.list(Genre_Matrix2_tfidf[3,],decreasing = TRUE)[1:10]]
#colnames(matrix2)[sort.list(matrix2[3,],decreasing = TRUE)[1:10]]
#colnames(Genre_Matrix2)[sort.list(Genre_Matrix2[3,],decreasing = TRUE)[1:10]]



#####4 Gram
FourgramTokenizer <-
  function(x)
    unlist(lapply(ngrams(words(x), 4), paste, collapse = " "), use.names = FALSE)

Genre_tdm4 <- TermDocumentMatrix(corpus_clean, control = list(tokenize = FourgramTokenizer))
Genre_Matrix4<-t(as.matrix(Genre_tdm4))
rownames(Genre_Matrix4)<-GenreName
colnames(Genre_Matrix4)<-stri_trans_totitle(colnames(Genre_Matrix4)) #cconvert back the first letter of chord to capital!!!

Genre_Matrix4_tfidf<-tfidf(Genre_Matrix4,normalize=T)

#colnames(Genre_Matrix4_tfidf)[sort.list(Genre_Matrix4_tfidf[3,],decreasing = TRUE)[1:10]]



#####Chord
Genre_tdmC <- TermDocumentMatrix(corpus_clean)
Genre_MatrixC<-t(as.matrix(Genre_tdmC))
rownames(Genre_MatrixC)<-GenreName
colnames(Genre_MatrixC)<-stri_trans_totitle(colnames(Genre_MatrixC)) #cconvert back the first letter of chord to capital!!!

Genre_MatrixC_tfidf<-tfidf(Genre_MatrixC,normalize=T)

save(Genre_tdm2,Genre_Matrix2,Genre_Matrix2_tfidf,Genre_tdm4,Genre_Matrix4,Genre_Matrix4_tfidf,
     Genre_tdmC,Genre_MatrixC,Genre_MatrixC_tfidf,file='GenreTDM.Rdata')



################ TermDocumentMatrix for individual songs #################

All.Chords.Str<-list()

for(k in 1:length(all.chord.original.sd)){
  chord.str<-paste(all.chord.original.sd[[k]][-1], collapse=" ") 
  All.Chords.Str[[k]]<-chord.str
}

song_chord_corpus <- as.VCorpus(All.Chords.Str)
song_chord_corpus <- tm_map(song_chord_corpus, PlainTextDocument)
song_tdm <- TermDocumentMatrix(song_chord_corpus)
song_Matrix<-t(as.matrix(song_tdm))


song_tdm2 <- TermDocumentMatrix(song_chord_corpus, control = list(tokenize = BigramTokenizer))
song_Matrix2<-t(as.matrix(song_tdm2))

save(song_tdm,song_Matrix,song_tdm2,song_Matrix2,file='SongTDM.Rdata')



################### for all songs ##################

All_Chords<-""
for(i in 1:length(all.chord.original.sd)){
  tmp.str<-paste(all.chord.original.sd[[i]][-1], collapse=" ") #merge elements into strings
  All_Chords<-paste(All_Chords,tmp.str)
  All_Chords<-paste(All_Chords,"\n")
}

all_NG <- ngram(All_Chords,4)
all_chord_ngram <- get.phrasetable(all_NG)

save(all_chord_ngram,file="All4Grams.Rdata")



