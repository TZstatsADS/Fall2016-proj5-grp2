library(dplyr)
library(highcharter)

load("~/Google Drive/Columbia/5243 ADS/ADS Proj 5/Fall2016-proj5-grp2/data/Billboard/cut_GM4.RData")

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
