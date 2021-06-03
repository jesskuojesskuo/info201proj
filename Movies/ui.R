library(shiny)
library(tidyverse)
library(ggplot2)
library(maps)
library(rsconnect)

data <- read.csv("Movies.csv")

ui <- fluidPage(
    
    titlePanel("Old Faithful Geyser Data"),
    tabsetPanel(
        tabPanel("Year Filter", 
                 sidebarLayout(
                     sidebarPanel(
                         radioButtons(
                             "platform",
                             "Select what platform you want to filter:",
                             choices = c("All four platforms", "Netflix", "Hulu", "Amazon Prime" = "Prime.Video", "Disney+" = "Disney.")
                         )
                     ),
                    mainPanel(
                        plotOutput("Plot"),
                        textOutput("Message")
                    )
                )
        ),
        tabPanel("Ratings Filter", 
                 sidebarLayout(
                     sidebarPanel(
                        sliderInput("Rating",
                                     "IMDb ratings for movies", 
                                     min = 0, 
                                     max = 10,
                                     value = 5)
                     ),
                     mainPanel(
                         plotOutput("netflix"),
                         plotOutput("hulu"),
                         plotOutput("prime"),
                         plotOutput("disney")
                     )
                 )
        ),
        tabPanel("Age Filter", 
                 sidebarLayout(
                     sidebarPanel(
                         selectInput("ageGroup", label = "Age Group:", 
                                     choices = c("7+", "13+", "16+", "18+", "all")
                         )
                     ),
                     # plot and summary
                     mainPanel(
                         plotOutput("plot"),
                         textOutput("summary")
                     )
                 )
            )
        )
    )