library(ngram)

load("cleaned_data.Rdata")

chord.str<-paste(all.chord[[1]][-1],collapse=" ")
NG<-ngram(chord.str, n=4)
get.phrasetable(NG)

chords2Gram<-list()
chords4Gram<-list()

for(k in 1:length(all.chord)){
  chord.str<-paste(all.chord[[k]][-1], collapse=" ") 
  N2G<-ngram(chord.str, n=2)
  chords2Gram[[k]]<-get.phrasetable(N2G)
  
  N4G<-ngram(chord.str, n=4)
  chords4Gram[[k]]<-get.phrasetable(N4G)
  
}

save(chords2Gram,file = "chords2Gram.rdata")
save(chords4Gram,file = "chords4Gram.rdata")
