library(shiny)
library(tidyverse)
library(ggplot2)
library(maps)
library(rsconnect)

data <- read.csv("Movies.csv")

ui <- fluidPage(
    
    titlePanel("Online Streaming Platform Comparison"),
    tabsetPanel(
        tabPanel("Page Introduction", 
                     mainPanel(
                         h3("About the Project"),
                         p("For our project we wanted to explore movie data among the most notable movie streaming platforms today. We wanted to analyze the data for any discernible takeaways and/or relationships between movie streaming platforms on rating, age, and year. Our interpretations will benefit the consumer audience, more precisely people who are interested in purchasing a subscription to said platforms based on their personal preferences or needs. "),
                         br(),
                         h3("Dataset"),
                         p("The dataset we utilized from Kaggle (data science community with reputable open datasets) contains movie data regarding Hulu, Disney+, Netflix, and Prime video. It is a combination of IMDb dataset, and scraped data from various streaming platforms. The csv file consists of movies from the early 1900s to 2020. The dataset can be found publicly", tags$a(href="https://www.kaggle.com/ruchi798/movies-on-netflix-prime-video-hulu-and-disney", "here!")),
                         br(),
                         h3("Creators"),
                         tags$ol(
                             tags$li("Andy Hoang"), 
                             tags$li("Jessica Kuo"), 
                             tags$li("Justin Lee"),
                             tags$li("Sara Hamidi")
                         ),
                         img(src = "https://cdn.shopify.com/s/files/1/1003/7610/files/Movie_Banner-01.jpg?v=1475077727"),
                     )
        ),
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
            ),
        tabPanel("Page Conclusion", 
                     mainPanel(
                         h3("Conclusion/Analysis"),
                         br(),
                         h3("Reflection"),
                         p("Our dataset was gathered by Ruchi Bhatia, a profound and reputable data scientist within the Kaggle community. Although her dataset consisted of data scraping in the US region and combining the imdb dataset, there were a few questions and concerns of accuracy and collection methods by other scientists who referenced and used the data. It is unclear if all of the data is correct, complete, and/or  biased."),
                        p("In the future, to further this project it would be ideal to get in touch with Ruchi to discuss the dataset and collection method. It would also be keen to screen the accuracy and finally include new/missing data and more chart visualizations that would influence consumer interest. "),
                        h3("Creators"),
                        tags$ol(
                            tags$li("Andy Hoang"), 
                            tags$li("Jessica Kuo"), 
                            tags$li("Justin Lee"),
                            tags$li("Sara Hamidi")
                        ),
                    )
                )
        )
)