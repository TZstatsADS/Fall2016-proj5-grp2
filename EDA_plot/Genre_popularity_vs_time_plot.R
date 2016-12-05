library(plotly)
library(quantmod)
# Download some data
genre <- read.csv("final_genre.csv")
genre <- genre[,c(2,3,10)]

time <- strsplit(as.character(genre[,2]), "-")
year <- vector()
for (i in 1:length(time))
{
  year[i] <- time[[i]][1]
}
genre[,2] <- as.numeric(year)

data <- table(genre[,2],genre[,3])
data <- cbind(as.numeric(row.names(data)),data)
data <- as.data.frame(data)
names(data)[1] <- "year"

###### 2 years
data2 <- matrix(0,17,8)
for (i in 1:17)
{
  data2[i,] <- colSums(data[(2*i-1):(2*i),-1])
}

data2 <- as.data.frame(data2)
names(data2) <- names(as.data.frame(data)[-1])
data2 <- cbind(seq(1958,1990,2),data2)
data2 <- as.data.frame(data2)
names(data2)[1] <- "year"
data2 <- data2[,-c(3,6)]

p2 <- plot_ly(data2, x = ~year) %>%
  add_lines(y = ~Country, name = "Country") %>%
  add_lines(y = ~`Hip-hop`, name = "Hip-hop") %>%
  add_lines(y = ~Jazz, name = "Jazz") %>%
  add_lines(y = ~Pop, name = "Pop") %>%
  add_lines(y = ~`R&B/Soul`, name = "R&B/Soul") %>%
  add_lines(y = ~Rock, name = "Rock") %>%


  layout(
    title = "Genre popularity from 1958 to 1991",
    yaxis = list(title = "Frequency"))

p2
