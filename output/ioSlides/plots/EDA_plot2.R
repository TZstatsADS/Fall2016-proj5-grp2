load("GenreTDM.Rdata")
final <- vector()
for(i in 1:8)
{
  top <- sort(Genre_MatrixC[i,],decreasing = T)[1:4]
  mat <- matrix(0,nrow = 4, ncol = 3)
  mat[,2] <- row.names(Genre_MatrixC)[i]
  mat[,1] <- top/sum(top)
  mat[,3] <- names(top)
  final <- rbind(final, mat) 
}
final <- data.frame(final)
final[,1] <- as.numeric(paste(final[,1]))
#final[,2] <- as.character(paste(final[,2]))
#final[,3] <- as.character(paste(final[,3]))
#final[,3] <- as.numeric(final[,3])
names(final) <- names(plotly::wind)

ID <- which(names(as.data.frame(Genre_MatrixC)) %in% unique(final[,3]))
data <- Genre_MatrixC[,ID]
data <- cbind(row.names(data),data)
data <- as.data.frame(data)


for(i in 2:ncol(data))
{
  data[,i] <- as.numeric(paste(data[,i]))
}

chord <- names(data)

haha <- data[,-1]/rowSums(data[2:ncol(data)])
chord <- names(haha)
dim(haha)

p2 <- plot_ly(data, x = ~row.names(data), y = ~haha[,1], type = 'bar', name = chord[1]) %>%
  add_trace(y = ~haha[,2], name = chord[2]) %>%
  add_trace(y = ~haha[,3], name = chord[3]) %>%
  add_trace(y = ~haha[,4], name = chord[4]) %>%
  add_trace(y = ~haha[,5], name = chord[5]) %>%
  add_trace(y = ~haha[,6], name = chord[6]) %>%
  add_trace(y = ~haha[,7], name = chord[7]) %>%
  add_trace(y = ~haha[,8], name = chord[8]) %>%
  add_trace(y = ~haha[,9], name = chord[9]) %>%
  add_trace(y = ~haha[,10], name = chord[10]) %>%
  layout(title = "Major chords across all genres",
    yaxis = list(title = 'Proportion'), 
    xaxis = list(title = 'Genre'), barmode = 'stack')
p2



