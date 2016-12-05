library(shiny)
library(shinythemes)
library(networkD3)
library(shinyjs)
library(highcharter)

tagList(
  useShinyjs(),
navbarPage('MelodySoup', theme = shinytheme('cosmo'),
           
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
