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

offensiveplayerratings <- read.csv("fbs_offensive_player_ratings.csv", as.is = TRUE)

offensiveplayerratings <- offensiveplayerratings %>%
    rename(Season = Year)

offensiveplayerratings <- offensiveplayerratings %>%
    mutate_at(vars(Passing, Rushing, Receiving, Total), funs(round(., 4)))

defensiveplayerratings <- read.csv("fbs_defensive_player_ratings.csv", as.is = TRUE)

ui <- fluidPage(
    navbarPage("Free Shoes U", theme = shinytheme("cosmo"),
        tabPanel("Home", 
                 fluidRow(
                     column(6,
                            h4(p("Welcome to Free Shoes U")),
                            h5(p("A College Football Website featuring Advanced Stats by Geoff Hutchinson.")))
               )),
               navbarMenu("Player Ratings",
                          tabPanel("Offense",
                    fluidRow(
                    column(3,
                           selectInput("School",
                                       "School:",
                                       c("All",
                                         sort(unique(as.character(offensiveplayerratings$School)))))
                    ),
                    column(3,
                           selectInput("Conference",
                                       "Conference:",
                                       c("All",
                                         sort(unique(as.character(offensiveplayerratings$Conference)))))
                    ),
                    column(3,
                           selectInput("Season",
                                       "Season:",
                                       c("All",
                                         sort(unique(as.character(offensiveplayerratings$Season)))))
                    )
                ),
                
                div(DT::dataTableOutput("table"), style = "font-size:85%")
),
                    tabPanel("Defense",
                        fluidRow(
                    column(3,
                    selectInput("School",
                                "School:",
                                c("All",
                                  sort(unique(as.character(defensiveplayerratings$School)))))
             ),
                    column(3,
                    selectInput("Conference",
                                "Conference:",
                                c("All",
                                  sort(unique(as.character(defensiveplayerratings$Conference)))))
             ),
                    column(3,
                    selectInput("Season",
                                "Season:",
                                c("All",
                                  sort(unique(as.character(defensiveplayerratings$Season)))))
             )
         ),
         
         div(DT::dataTableOutput("table1"), style = "font-size:85%")
)
        
    )
)
)


server <- function(input, output) {
    
    # Filter data based on selections
    output$table <- DT::renderDataTable(DT::datatable({
        offensiveplayerratings <- offensiveplayerratings
        if (input$School != "All") {
            offensiveplayerratings <- offensiveplayerratings[offensiveplayerratings$School == input$School,]
        }
        if (input$Conference != "All") {
            offensiveplayerratings <- offensiveplayerratings[offensiveplayerratings$Conference == input$Conference,]
        }
        if (input$Season != "All") {
            offensiveplayerratings <- offensiveplayerratings[offensiveplayerratings$Season == input$Season,]
        }
        offensiveplayerratings
    }))
    
    output$table1 <- DT::renderDataTable(DT::datatable({
        defensiveplayerratings <- defensiveplayerratings
        if (input$School != "All") {
            defensiveplayerratings <- defensiveplayerratings[defensiveplayerratings$School == input$School,]
        }
        if (input$Conference != "All") {
            defensiveplayerratings <- defensiveplayerratings[defensiveplayerratings$Conference == input$Conference,]
        }
        if (input$Season != "All") {
            defensiveplayerratings <- defensiveplayerratings[defensiveplayerratings$Season == input$Season,]
        }
        defensiveplayerratings
    }))
   
}

# Run the application 
shinyApp(ui = ui, server = server)
