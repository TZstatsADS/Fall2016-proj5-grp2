
### read beatles chord
filenames <- list.files("~/Documents/Columbia/ADS/Fall2016-proj5-grp2/data/Beatles/chordlab/The Beatles/", pattern="*.lab",recursive = T, full.names=TRUE)
BeatlesChord <- list()

for(i in 1:length(filenames)){
  BeatlesChord[[i]] <- read.table(filenames[i])
}


### read beatles segments

filenames2 <- list.files("~/Documents/Columbia/ADS/Fall2016-proj5-grp2/data/Beatles/seglab/The Beatles/", pattern="*.lab",recursive = T, full.names=TRUE)
BeatlesSeg <- list()

for(i in 1:length(filenames2)){
  BeatlesSeg[[i]] <- read.table(filenames2[i])
}



### combine 
for(k in 1:180){
  i=1
  BeatlesChord[[k]][,4]<-rep(NA,nrow(BeatlesChord[[k]]))
  BeatlesChord[[k]][1,4]<-'silence'
  
  for(j in 2:nrow(BeatlesChord[[k]])-1){
    if(BeatlesChord[[k]][j,2]>BeatlesSeg[[k]][i,1]&&BeatlesChord[[k]][j,2]<=BeatlesSeg[[k]][i,2]){
      BeatlesChord[[k]][j,4]=as.character(BeatlesSeg[[k]][i,3])
    }
    else{
      i<-i+1
      BeatlesChord[[k]][j,4]=as.character(BeatlesSeg[[k]][i,3])
    }
  }
  BeatlesChord[[k]][nrow(BeatlesChord[[k]]),4]<-'silence'
}
