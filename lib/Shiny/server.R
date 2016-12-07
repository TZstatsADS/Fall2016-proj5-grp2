library(shiny)
library(networkD3)
library(shinyjs)
library(highcharter)

total_input= character()
total_output = character()
song = character()
last_sound = 'Nothing'

function(input, output, session) {
  
  new_end = function(input){
    return(sample(letters, 3))
  }
  
  #when user change the genre, update starting pitch and audio player
  observeEvent(input$Genre,{
    updateActionButton(session, 'start', 'Start!')
    
    output$html = renderText({'<h1>Music Player</h1><audio src="c-maj.mp3" type="audio/mp3" controls></audio>'})
    total_input <<- character()
    total_output <<- character()
    song <<- character()
    
    #start off with 4 chords
    recommend_list = start_chord(input$Genre)
    updateSelectInput(session, "nextPitch",label = 'Pick your starting chords!',
                      choices = as.list(recommend_list))
    
})
  
  
  
  
  
  observeEvent(input$start,{
    updateActionButton(session, 'start', 'Choose next chord')
    
      
    #update all previous input and output
    if (length(song) == 0){
      song <<- c(song, unlist(strsplit(input$nextPitch, ' ')))    
    }else{
      song <<- c(song, input$nextPitch)
    }
    
    len = length(song)
    three_gram = paste(song[len-2],song[len-1],song[len])
    end = next_chord(input$Genre, three_gram)
    plot_end = next_chord_with_prob(input$Genre, three_gram)
    
    #print(three_gram)
    print(input$nextPitch)
    
    for (i in seq(length(song) - 1)){
      total_input = c(total_input,song[i])
      total_output = c(total_output, song[i+1])
    }
    
    total_output = c(total_output,end)
    fill_diff = length(total_output) - length(total_input)
    total_input = c(total_input, rep(song[length(song)], fill_diff))
    
    #form a dataframe for ploting
    netData = data.frame(total_input, total_output)
    
    updateSelectInput(session, "nextPitch",label = 'Pick your next chord',
                      choices = as.list(end))
    
    
    output$text = renderText({paste(song, collapse = ' => ')})
    
    #------------------replace plotting----------------------
    output$qiu = renderSimpleNetwork({
       simpleNetwork(netData, fontSize = 20, nodeColour  = "#E34A33", textColour = 'black', zoom = T, height = 800, width = 800)  
    })
    #_______________________________________________________
    
    output$bar = renderHighchart({
      highchart() %>% 
        hc_chart(type = "column") %>% 
        hc_title(text = "Our recommendations") %>% 
        hc_xAxis(categories = plot_end$chord) %>% 
        hc_add_series(data = plot_end$prob, name = 'Next chord')
    })  
    
    src = stupid_file_name(input$nextPitch)
    #force render
    if (src == last_sound){
      src = past0(last_sound,' ')
    } 
    sound_name <<- src
    
    output$sound = renderText({paste0('<audio src= "',src,'" type="audio/mp3" autoplay></audio>')})
    
    
  })
    

}
