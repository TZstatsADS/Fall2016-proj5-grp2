library(shiny)
library(shinythemes)
library(networkD3)
library(shinyjs)
library(highcharter)

tagList(
  useShinyjs(),
navbarPage(strong('MelodySoup', style = "font-family: 'times'; font-size:16pt;"), theme = shinytheme('cosmo'),
  # 1. Intro tab
  tabPanel("About Us", 
          h1("MelodySoup - the base for writing melodies", style = "font-family: 'times'; font-size:16pt;"),
          img(src='logo2.jpg', width="20%", align = "left"),
          h2("How to Use MelodySoup"),
          p("In 'Make your own song' tab, you can choose a genre you like,"),
          p("pick your starting chords, and hit 'start a new song'."), 
          p("Then you can choose next chord from top hot chord list we recommend for you."),
          h2("Mission"),
          p("We want to empower everyone to write simple but elegant music"),
          img(src='Background4.jpg', width="120%", align = "right")
  ),

  # 2. Songmaking tab
  tabPanel("Make your own song!",
           sidebarLayout(
             sidebarPanel(
                radioButtons('Genre', 'Choose a Genre!', 
                                   choices = c('R&B/Soul','Rock','Pop','Country', 'Others','Hip-hop', 'Folk', 'Jazz')),
                
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
