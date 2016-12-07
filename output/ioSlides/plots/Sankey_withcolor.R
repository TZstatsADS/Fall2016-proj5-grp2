load("~/Google Drive/Columbia/5243 ADS/ADS Proj 5/Fall2016-proj5-grp2/data/Billboard/All4Grams.Rdata")
amount <- 80
para <- 250
haha <- all_chord_ngram[1:amount,c(1,2)]

data <- matrix(0,nrow = amount, ncol = 5)
data[,5] <- haha[,2]
for(i in 1:148)
{
  data[i,1:4] <- strsplit(haha[,1], " ")[[i]]
}
#data <- data[-118,]

data <- as.data.frame(data)

d1 <- cbind(paste(data[,1]),as.numeric(data[,1]),
      paste(data[,2]),as.numeric(data[,2])+max(as.numeric(data[,1])),
      paste(data[,3]),as.numeric(data[,3])+max(as.numeric(data[,1]))+max(as.numeric(data[,2])),
      paste(data[,4]),as.numeric(data[,4])+max(as.numeric(data[,1]))+max(as.numeric(data[,2]))+max(as.numeric(data[,3])))
d2 <- cbind(d1, as.numeric(paste(data[,5])))
d2 <- as.data.frame(d2)
d3 <- d2
d3[,2] <- as.numeric(paste(d3[,2]))
d3[,4] <- as.numeric(paste(d3[,4]))
d3[,6] <- as.numeric(paste(d3[,6]))
d3[,8] <- as.numeric(paste(d3[,8]))
d3[,9] <- as.numeric(paste(d3[,9]))


d4 <- as.matrix(d3)
d4 <- rbind(d4[,c(1,2)], d4[,c(3,4)], d4[,c(5,6)], d4[,c(7,8)])
d4 <- as.data.frame(d4)
d4[,2] <- as.numeric(paste(d4[,2]))
d4[,1] <- as.character(paste(d4[,1]))

nodes <- vector()
for(i in 1:max(d4[,2]))
{
  nodes[i] <- unique(d4[which(d4[,2]==i),1])
}
nodes <- as.data.frame(nodes)
names(nodes) <- "name"
nodes <- c(paste(nodes$name),"Start")
nodes <- as.data.frame(nodes)
names(nodes) <- "name"

 
d5 <- as.matrix(d3)
d5 <- rbind(d5[,c(2,4,9)],d5[,c(4,6,9)],d5[,c(6,8,9)])
start <- matrix(0,nrow = nrow(d3), ncol = 3)
start[,3] <- 1
start[,1] <- nrow(nodes)
start[,2] <- d3[,2]
st <- cbind(rep(nrow(nodes),length(table(start[,2]))), 
            1:length(table(start[,2])), 
            table(start[,2])*para)
d5 <- rbind(st,d5)
row.names(d5) <- 1:nrow(d5)

links <- as.data.frame(d5)
links[,1] <- as.numeric(paste(links[,1]))
links[,2] <- as.numeric(paste(links[,2]))
links[,3] <- as.numeric(paste(links[,3]))
links[,1] <- links[,1]-1
links[,2] <- links[,2]-1

names(links) <- c("source", "target", "value" )

d6 <- list(nodes, links)
names(d6) <- c("nodes", "links")

d6$links$type <- sub('\\:.*', '',d6$nodes[d6$links$source + 1, 'name'])
d6$nodes$hehe <- sub('\\:.*', '',d6$nodes[, 'name'])


Sankey = sankeyNetwork(Links = d6$links, Nodes = d6$nodes, Source = "source",
              Target = "target", Value = "value", NodeID = "name",
              units = "TWh", fontSize = 12, nodeWidth = 30, LinkGroup = 'type',
              NodeGroup = 'hehe', colourScale = "d3.scale.ordinal().range(['#FF4040', '#FF7F00', '#FFD700', '#82E0AA', '#99CCFF', '#9999FF', '#FF00FF','#008B8B' ])")
Sankey
save(Sankey, file = "~/Google Drive/Columbia/5243 ADS/ADS Proj 5/Fall2016-proj5-grp2/lib/ioSlides/EDA_plot/Sankey.Rdata")

