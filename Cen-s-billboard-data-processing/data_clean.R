setwd("~/Desktop/Billboard")
allsong <- read.csv("billboard-2.0-index.csv")
songuse <- na.omit(allsong)
index0 <- formatC(songuse[,1], width = 4, flag = "0")
index <- index0[-c(18,31,45,76,355,
                   400,461,554,573,626,
                   640,700,721,733,748,
                   771,813,853)]

all.chord <- list(0)
chord.dictionary <- 0
tonic <- 0

for(w in 1:length(index))
{
  print(w)
  filename <- sprintf("McGill-Billboard/%s/salami_chords.txt",
                      index[w])
  data <- read.csv(filename)
  
  chord <- index[w]
  
  for(i in 1:(nrow(data)-3))
  {
    if(length(strsplit(as.character(data[i+3,1]), ":")[[1]])!=1)
    {
      a <- strsplit(as.character(data[i+3,1]), ":")
      rowchord <- rep(0, length(a[[1]])-1)
      for(j in 1:(length(a[[1]])-1))
      {
        rowchord[j] <- paste(strsplit(a[[1]][j]," ")[[1]] [length(strsplit(a[[1]][j], " ")[[1]])],
                             strsplit(a[[1]][j+1]," ")[[1]] [1], sep = ":")
      }
      chord <- c(chord, rowchord)
    }
  }
  
  for(k in 1:nrow(data))
  {
    if(length(strsplit(as.character(data[k,1]), "tonic: ")[[1]])!=1)
    {
      tonic <- c(tonic,strsplit(as.character(data[k,1]), "tonic: ")[[1]] [2])
    }
  }
  
  
  if(sum(chord == "metre:")>0)
  {
    chord <- chord[-which(chord=="metre:")]
  }
  
  if(sum(chord == "tonic:") == 0)
  {
    all.chord[[length(all.chord)+1]] <- chord
  }
  
  if(sum(chord == "tonic:") > 0)
  {
    sep <- c(1,which(chord == "tonic:"),length(chord)+1)
    for(x in 1:(length(which(chord == "tonic:"))+1) )
    {
      all.chord[[length(all.chord)+1]] <- c(chord[1],chord[(sep[x]+1):(sep[x+1]-1)])
    }
  }
}

all.chord[[1]] <- NULL
tonic <- tonic[-1]
tonic[which(tonic %in% c("3/4","4/4"))] <- c("G","C","C","Ab","C",
                                             "Eb","D","A","Eb","C",
                                             "B","E","Eb","C")
for(i in 1:length(tonic))
{
  chord.dictionary <- c(chord.dictionary, all.chord[[i]][-1])
}
chord.dictionary <- unique(chord.dictionary[-1])

