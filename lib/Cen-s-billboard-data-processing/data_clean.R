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
tonic[which(tonic=="C#")] <- "Db"
tonic[which(tonic=="Gb")] <- "F#"
tonic[which(tonic=="G#")] <- "Ab"
tonic[which(tonic=="Cb")] <- "B"
all.chord.original <- all.chord

############### standardize original chord to C ###############
for(i in 1:length(all.chord.original))
{
  print(i)
  for(j in 1:length(all.chord.original[[i]]))
  {
    all.chord.original[[i]][j] <- gsub("A#","Bb",all.chord.original[[i]][j])
    all.chord.original[[i]][j] <- gsub("D#","Eb",all.chord.original[[i]][j])
    all.chord.original[[i]][j] <- gsub("C#","Db",all.chord.original[[i]][j])
    all.chord.original[[i]][j] <- gsub("Gb","F#",all.chord.original[[i]][j])
    all.chord.original[[i]][j] <- gsub("G#","Ab",all.chord.original[[i]][j])
    all.chord.original[[i]][j] <- gsub("Cb","B",all.chord.original[[i]][j])
    all.chord.original[[i]][j] <- gsub("Fb","E",all.chord.original[[i]][j])
  }
}

for(i in 1:length(all.chord.original))
{
  same <- 0
  for(j in 2:length(all.chord.original[[i]]))
  {
    if(all.chord.original[[i]][j]==all.chord.original[[i]][j-1])
    {
      same <- c(same,j)
    }
  }
  
  if (length(same)>1)
  {
    same <- same[-1]
    all.chord.original[[i]] <- all.chord.original[[i]][-same]
  }
}

single <- 0
for(i in 1:length(all.chord.original))
{
  if(length(all.chord.original[[i]])==2)
  {
    single <- c(single, i)
  }
}
single <- single[-1]

all.chord.original[single] <- NULL
tonic.original <- tonic[-single]


rule <- matrix(0, nrow = 12, ncol = 12)
rule[1,] <- c("C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:")
rule[2,] <- c("Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:")
rule[3,] <- c("D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:")
rule[4,] <- c("Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:")
rule[5,] <- c("E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:")
rule[6,] <- c("F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:")
rule[7,] <- c("F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:", "F:")
rule[8,] <- c("G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:")
rule[9,] <- c("Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:")
rule[10,] <- c("A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:")
rule[11,] <- c("Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:")
rule[12,] <- c("B:", "C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:")

all.chord.original.sd <- all.chord.original

for(i in 1:length(all.chord.original))
{
  print(i)
  id <- which(gsub("\\:", "", rule[,1]) == tonic.original[i])
  for(j in 1:(length(all.chord.original[[i]])-1))
  {
    id2 <- which(gsub("\\:", "", rule[id,]) == gsub("\\:.*", "", all.chord.original[[i]][j+1]))
    
    all.chord.original.sd[[i]][j+1] <- gsub(as.character(rule[id,id2]),
                                   as.character(rule[1,id2]),
                                   as.character(all.chord.original[[i]][j+1]))
  }
}






############### standardize chord  ####################
for(i in 1:length(all.chord))
{
  print(i)
  for(j in 1:length(all.chord[[i]]))
  {
    all.chord[[i]][j] <- gsub("A#","Bb",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("D#","Eb",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("C#","Db",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("Gb","F#",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("G#","Ab",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("Cb","B",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("Fb","E",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("\\(.*", "", all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("\\/.*", "", all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("min.*", "min", all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("hdim.*","dim",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("dim.*","dim",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("aug.*","aug",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("sus.*","sus",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("\\:[[:digit:]]",":maj",all.chord[[i]][j])
    all.chord[[i]][j] <- gsub("maj.*", "maj", all.chord[[i]][j])
  }
}

########################## remove repeat chord  #########################
for(i in 1:length(all.chord))
{
  same <- 0
  for(j in 2:length(all.chord[[i]]))
  {
    if(all.chord[[i]][j]==all.chord[[i]][j-1])
    {
      same <- c(same,j)
    }
  }
  
  if (length(same)>1)
  {
    same <- same[-1]
    all.chord[[i]] <- all.chord[[i]][-same]
  }
}

##################### Remove single chord ##################
single <- 0
for(i in 1:length(all.chord))
{
  if(length(all.chord[[i]])==2)
  {
    single <- c(single, i)
  }
}
single <- single[-1]

all.chord[single] <- NULL
tonic <- tonic[-single]

chord.dictionary <- 0
for(i in 1:length(all.chord))
{
  chord.dictionary <- c(chord.dictionary, all.chord[[i]][-1])
}
chord.dictionary <- chord.dictionary[-1]
chord.dictionary <- unique(chord.dictionary)

#################### Standardize to C ####################
rule <- matrix(0, nrow = 12, ncol = 12)
rule[1,] <- c("C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:")
rule[2,] <- c("Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:")
rule[3,] <- c("D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:")
rule[4,] <- c("Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:")
rule[5,] <- c("E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:")
rule[6,] <- c("F:", "F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:")
rule[7,] <- c("F#:", "G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:", "F:")
rule[8,] <- c("G:", "Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:")
rule[9,] <- c("Ab:", "A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:")
rule[10,] <- c("A:", "Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:")
rule[11,] <- c("Bb:", "B:", "C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:")
rule[12,] <- c("B:", "C:", "Db:", "D:", "Eb:", "E:", "F:", "F#:", "G:", "Ab:", "A:", "Bb:")

all.chord.sd <- all.chord

for(i in 1:length(all.chord))
{
  print(i)
  id <- which(gsub("\\:", "", rule[,1]) == tonic[i])
  for(j in 1:(length(all.chord[[i]])-1))
  {
    id2 <- which(gsub("\\:", "", rule[id,]) == gsub("\\:.*", "", all.chord[[i]][j+1]))
    
    all.chord.sd[[i]][j+1] <- gsub(as.character(rule[id,id2]),
                                 as.character(rule[1,id2]),
                                 as.character(all.chord[[i]][j+1]))
    
  }
}

