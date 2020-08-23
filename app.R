library(dplyr)
library(stringr)
library(rsconnect)
library(shiny)
library(shinyWidgets)
library(jsonlite)
library(tidyverse)
library(shinythemes)
library(DT)
library(gt)

fbsplayerratings <- read.csv("fbs_player_ratings.csv", as.is = TRUE)

fbsplayerratings <- fbsplayerratings %>%
    rename(Season = Year)

fbsplayerratings <- fbsplayerratings %>%
    mutate_at(vars(Passing, Rushing, Receiving, Total), funs(round(., 4)))


ui <- fluidPage(theme = shinytheme("cosmo"),
                
                titlePanel("FBS Offensive Player Ratings (2010-2019)"),
                
                fluidRow(
                    column(3,
                           selectInput("School",
                                       "School:",
                                       c("All",
                                         sort(unique(as.character(fbsplayerratings$School)))))
                    ),
                    column(3,
                           selectInput("Conference",
                                       "Conference:",
                                       c("All",
                                         sort(unique(as.character(fbsplayerratings$Conference)))))
                    ),
                    column(3,
                           selectInput("Season",
                                       "Season:",
                                       c("All",
                                         sort(unique(as.character(fbsplayerratings$Season)))))
                    )
                ),
                
                div(DT::dataTableOutput("table"), style = "font-size:75%")
)

server <- function(input, output) {
    
    # Filter data based on selections
    output$table <- DT::renderDataTable(DT::datatable({
        fbsplayerratings <- fbsplayerratings
        if (input$School != "All") {
            fbsplayerratings <- fbsplayerratings[fbsplayerratings$School == input$School,]
        }
        if (input$Conference != "All") {
            fbsplayerratings <- fbsplayerratings[fbsplayerratings$Conference == input$Conference,]
        }
        if (input$Season != "All") {
            fbsplayerratings <- fbsplayerratings[fbsplayerratings$Season == input$Season,]
        }
        fbsplayerratings
    }))
    
}

# Run the application 
shinyApp(ui = ui, server = server)
