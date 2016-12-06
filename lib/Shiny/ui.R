library(shiny)
library(shinythemes)
library(networkD3)
library(shinyjs)
library(highcharter)

tagList(
  useShinyjs(),
navbarPage(strong('MelodySoup', style = "font-family: 'times'; font-size:18pt;"), theme = shinytheme('cosmo'),
  # 1. Intro tab
  tabPanel("About Us", 
          h1("MelodySoup - the base for writing melodies"),
          img(src='logo2.jpg', width="20%", align = "left"),
          h2(icon("check-circle"), "Our Mission"),
          p("Anyone can write music.", style = "font-size:14pt"),
          h2(icon("question-circle"), "How to Use MelodySoup"),
          p("  1. In 'Make Your Own Song' tab, you can choose a genre you like.", style = "font-size:14pt"),
          p("  2. Pick your starting chords, and hit 'start a new song'.", style = "font-size:14pt"), 
          p("  3. Then you can choose next chord from top hot chord list we recommend for you.", style = "font-size:14pt"),
          img(src='Background4.jpg', width="120%", align = "right")
  ),

  # 2. Songmaking tab
  tabPanel("Make Your Own Song!",
           sidebarLayout(
             sidebarPanel(
                radioButtons('Genre', 'Choose a Genre!', 
                                   choices = c('All genres', 'R&B/Soul','Rock','Pop','Country', 'Others','Hip-hop', 'Folk', 'Jazz')),
                
                selectInput('nextPitch', 'What next?', choices = list('a','b','c','d'), selected = 'a'),
                
                actionButton('start', 'click to run')
                
                ),
                mainPanel(
                h2('Make your own song!'),
                
                simpleNetworkOutput("qiu"),
                
                highchartOutput('bar'),
                
                h4('Your song:'),
                
                textOutput('text'),
                
                hr(),
                #future change into output$html_text
                #HTML('<h1>Music Player</h1><audio controls><source src="/Users/Max/Desktop/record.mp3" type="audio/mpeg"></source></audio>')
                uiOutput('html')
                #includeHTML('music_player.html')
                )
           ))
  
))
