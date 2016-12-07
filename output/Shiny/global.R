library(dplyr)
library(highcharter)
library(stringi)
library(networkD3)
library(visNetwork)


load("www/cut_GM4.RData")

for(i in 1:length(GM4.prob))
{
  GM4.prob[[i]][,1] <- stri_trans_totitle(GM4.prob[[i]][,1])
  GM4.prob[[i]][,2] <- stri_trans_totitle(GM4.prob[[i]][,2])
}

#get start off chord for the song
start_chord = function(genre){
  temp = GM4.prob[[genre]]
  output_list = character()
  for (i in seq(6)){
    temp_choice = paste(temp[i,]$V1, temp[i,]$V2)
    output_list = c(output_list, temp_choice)
  }
  return(output_list)
}

#get next chord
next_chord = function(genre, previous_chord){
  temp = GM4.prob[[genre]]
  recommend_df = temp %>%
        filter(V1 == previous_chord) %>%
        arrange(desc(V3)) %>% 
        slice(1:6)
  return(as.character(recommend_df$V2))
}


next_chord_with_prob = function(genre, previous_chord){
  temp = GM4.prob[[genre]]
  recommend_df = temp %>%
    filter(V1 == previous_chord) %>%
    arrange(desc(V3)) %>% 
    slice(1:6)
  output = recommend_df[,2:3]
  names(output) = c('chord','prob')
  return(output)
}

stupid_file_name = function(chord){
  #remove / sign
  pos = gregexpr('/', chord)[[1]][1]
  if (pos > 0){
    output = substr(chord, 1, pos-1)
  } else {
    output = chord
  }
  return(paste0(gsub(':','-', output),'.mp3'))
}

