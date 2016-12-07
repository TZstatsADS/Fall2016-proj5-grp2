library(ngram)
library(chorddiag)
library(reshape2)
library(hash)
library(data.table)
library(dplyr)

load("cleaned_data.Rdata")
load("GenreTDM.Rdata")
Genres<-read.csv('final_genre.csv')




##### for color matching ######
# in total 12 kinds of chords
#chord.Vec<-unique(unlist(lapply(strsplit(as.character(rownames(tmp)), split=":"),head, n=1)))
chord.Vec<-c("A","Ab","B","Bb","C","D","Db","E","Eb","F#","F","G")
color.Vec<-c("#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462",
  "#b3de69","#fccde5","#d9d9d9","#bc80bd","#ccebc5","#ffed6f")
colormap<-hash(chord.Vec,color.Vec)

#assign each matrix for chord diagram color in a consitent way

colormatch<-function(Mat){
  chords<-rownames(Mat)
  m<-unlist(lapply(strsplit(as.character(chords), split=":"),head, n=1))
 
  colorgroup<-values(colormap,keys=m)
  colorgroup<-as.vector(colorgroup)
  return (colorgroup)
}


#n<-colormatch(chordmatrix)






##################### for each song ##############
chords2Gram<-list()
#chords4Gram<-list()

for(k in 1:length(all.chord.original.sd)){
  chord.str<-paste(all.chord.original.sd[[k]][-1], collapse=" ") 
  N2G<-ngram(chord.str, n=2)
  chords2Gram[[k]]<-get.phrasetable(N2G)
  
}


# specify a song with its id
for(i in 1:length(all.chord)){
  if(as.numeric(all.chord.original.sd[[i]][1]) == 629){  #specify the song id
    mychord<-chords2Gram[[i]]
    break
  }
}

df <- mychord

X<-with(df, cbind( colsplit(df$ngrams, pattern = "\\s", names = c('from', 'to')),freq,prop))
X$to <- gsub('\\s', '', X$to) #for consistency,remove the redundant space in each element of 2nd col
tmp<-acast(X,from~to,value.var='freq',fun.aggregate = sum)
tmp[is.na(tmp)]<-0
dimnames(tmp) <- list(from = colnames(tmp), to = colnames(tmp))

chordmatrix<-tmp
chordcolors<-colormatch(chordmatrix)


BeatItChord<-chorddiag(chordmatrix,groupnameFontsize=12,showTicks = FALSE,groupnamePadding = 10,groupColors=chordcolors)
save(BeatItChord,file="BeatItChord.Rdata")



######################## for each genre #################

MyGenre<-'Jazz'   #specify a genre
genre_id<-filter(Genres,genre==MyGenre)[,'id']    #specify a genre


#Genres_Chords<-""  #a string to store all Chords in Genre k


##############################disgard###############################
###Use another version of data
#extract the chords of kth genre 
#for(i in 1:length(all.chord.original.sd)){
#  if(as.numeric(all.chord.original.sd[[i]][1]) %in% genre_id){
#    tmp.str<-paste(all.chord.original.sd[[i]][-1], collapse=" ") #merge elements into strings
#    Genres_Chords<-paste(Genres_Chords,tmp.str)
#    Genres_Chords<-paste(Genres_Chords,"\n")
#  }
#}
#NG<-ngram(Genres_Chords, n=2)
#Genre2Gram<-get.phrasetable(NG)
#
#apply(Genre_Matrix2, 1, sum)
#sum(Genre2Gram$freq)
#
#babble(NG,16,seed = getseed())
####################################################################



### use the result from ChordMining directly
g_id<-which(rownames(Genre_Matrix2_tfidf)==MyGenre)
df<-as.data.frame(Genre_Matrix2[g_id,])
setDT(df, keep.rownames = TRUE)
colnames(df)<-c("ngrams","freq")
#df<-Genre2Gram

X<-with(df, cbind( colsplit(df$ngrams, pattern = "\\s", names = c('from', 'to')),freq))
X$to <- gsub('\\s', '', X$to)
tmp<-acast(X,from~to,value.var='freq', fun.aggregate = sum)
tmp[is.na(tmp)]<-0
dimnames(tmp) <- list(from = colnames(tmp), to = colnames(tmp))

#chord diagram for all possible chords. too compicated!!!
#chorddiag(tmp,groupnameFontsize=8,groupnamePadding = 20,showTicks = FALSE)


###after filtering




## for top chords in tfidf (unique chords in this genre)
#TopC<-colnames(Genre_MatrixC_tfidf)[sort.list(Genre_MatrixC_tfidf[g_id,],decreasing = TRUE)[1:20]]
#Genre.Top.Matrix<-tmp[which(rownames(tmp) %in% TopC),which(rownames(tmp) %in% TopC)]
#Genre.Top.Color<-colormatch(Genre.Top.Matrix)

#chorddiag(Genre.Top.Matrix,groupnameFontsize=8,groupnamePadding = 20,showTicks = FALSE,chordedgeColor =NULL,palette = "Set3",groupColors =Genre.Top.Color )

## for top bigrams in tfidf (unique chords in this genre)

Top2G<-colnames(Genre_Matrix2_tfidf)[sort.list(Genre_Matrix2_tfidf[g_id,],decreasing = TRUE)[1:30]]
Top2G<-unique(unlist(strsplit(Top2G,split=" ")))
Genre.Top2G.Matrix<-tmp[which(rownames(tmp) %in% Top2G),which(rownames(tmp) %in% Top2G)]
Genre.Top2G.Color<-colormatch(Genre.Top2G.Matrix)

chorddiag(Genre.Top2G.Matrix,groupnameFontsize=8,groupnamePadding = 10,showTicks = FALSE,chordedgeColor =NULL,palette = "Set3",groupColors =Genre.Top2G.Color )


## for top bigrams (not tfidf!!! may include common chords in all genre)
#Top2G2<-colnames(Genre_Matrix2)[sort.list(Genre_Matrix2[g_id,],decreasing = TRUE)[1:30]]
#Top2G2<-unique(unlist(strsplit(Top2G2,split=" ")))
#Genre.Top2G.Matrix2<-tmp[which(rownames(tmp) %in% Top2G2),which(rownames(tmp) %in% Top2G2)]
#Genre.Top2G.Color2<-colormatch(Genre.Top2G.Matrix2)

#rock.diag<-chorddiag(Genre.Top2G.Matrix2,groupnameFontsize=8,groupnamePadding = 20,showTicks = FALSE,chordedgeColor =NULL,palette = "Set3",groupColors =Genre.Top2G.Color2)

save(rock.diag,rock.diag2,file="Diagrams.Rdata")
save(Genre.Top2G.Matrix,Genre.Top2G.Color,Genre.Top2G.Matrix2,Genre.Top2G.Color2,file="DiagramsData.Rdata")


########To do:


# other text analysis for chords!


library(networkD3)
chordNetwork(Genre.Top2G.Matrix2)





