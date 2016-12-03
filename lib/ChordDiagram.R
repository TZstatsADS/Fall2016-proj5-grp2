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
chord.str<-paste(all.chord[[1]][-1], collapse=" ") 
NG<-ngram(chord.str, n=2)
get.ngrams(NG)
get.phrasetable(NG)
chords2Gram[[4]][1,1]

library(reshape2)
#df <- data.frame(transform(chords2Gram[[4]], ngrams= colsplit(ngrams, pattern = '\\s', names = c('from', 'to'))))
df <- chords2Gram[[4]]
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

x<-all.chord[[1:2]][1]


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



#rownames(tmp)[1] %in% colnames(tmp)






m <- matrix(c(11975,  5871, 8916, 2868,
              1951, 10048, 2060, 6171,
              8010, 16145, 8090, 8045,
              1013,   990,  940, 6907),
            byrow = TRUE,
            nrow = 4, ncol = 4)

chorddiag(m)
haircolors <- c("black", "blonde", "brown", "red")
dimnames(m) <- list(have = haircolors, prefer = haircolors)
chorddiag(m)

