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
                         br(),
                         img(src = "4platforms.jpg"),
                         h3("About the Project"),
                         p("For our project we wanted to explore movie data among the most notable movie streaming platforms today. We wanted to analyze the data for any discernible takeaways and/or relationships between movie streaming platforms on rating, age, and year. Our interpretations will benefit the consumer audience, more precisely people who are interested in purchasing a subscription to said platforms based on their personal preferences or needs. "),
                         br(),
                         h3("Dataset"),
                         p("The dataset we utilized from Kaggle (data science community with reputable open datasets) contains movie data regarding Hulu, Disney+, Netflix, and Prime video. It is a combination of IMDb dataset, and scraped data from various streaming platforms. The csv file consists of movies from the early 1900s to 2020. The dataset can be found publicly", tags$a(href="https://www.kaggle.com/ruchi798/movies-on-netflix-prime-video-hulu-and-disney", "here!")),
                         br(),
                         h3("Questions"),
                         tags$ol(
                             tags$li("What year of movies are more prevalent on specific platforms?"), 
                             tags$li("What movie platforms feature the most movies for a certain IMBb ratings?"),
                             tags$li("What movie platforms target the most of a certain age group? "),
                             tags$li("How many movies are featured on each platform?")
                         ),
                         br(),
                         img(src = "https://cdn.shopify.com/s/files/1/1003/7610/files/Movie_Banner-01.jpg?v=1475077727")
                     )
        ),
        tabPanel("Year Filter", 
                 sidebarLayout(
                     sidebarPanel(
                         radioButtons(
                             "platform",
                             "Select what platform you want to filter:",
                             choices = c("All four platforms", "Netflix", "Hulu", "Amazon Prime" = "Prime.Video", "Disney+" = "Disney.")
                         ),
                         h3("Plot Introduction & Summary"),
                         p("Through this graph, we're able to see the relationship between the streaming platform, the production year, and the amount of movies for the corresponding categories. This graph would be very useful for viewers or directors who are trying to grasp the streaming platform that they want to subscribe or upload their work on depending on how prevalent certain movie years are for each platform. The graph answers this relationship and is useful for users as they can quickly see the graph by selecting and filtering with the widget. Here, we can see that the platforms all together have a lot more movies that are produced after 2000. Specifically, Hulu, Netflix, and Prime all seem to focus on movies produced after 2010 while Disney+ has a wider distribution, with a larger percent of movies from the 1900's.")
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
                                     value = 5),
                        h3("Plot Introduction & Summary"),
                        p("Through these 4 graphs, we are able to visualize the relationship between IMDb ratings of movies for each age group that are available on each streaming platform. This tab is useful for users who are interested in seeing whether a certain platform has more movies with higher ratings for their desired age group. The widget allows them to select a rating, modifying the bar charts to only show the movies with IMDb ratings higher than the one selected on the slider. Here, we can see that Netflix, Hulu, and Prime Video have a lot of movies with ratings higher than 7 for older age groups and Disney+ has a lot of movies with higher ratings for all ages.")
                     ),
                     mainPanel(
                         plotOutput("netflix"),
                         plotOutput("hulu"),
                         plotOutput("prime"),
                         plotOutput("disney"),
                         textOutput("RatingSummary")
                     )
                 )
        ),
        tabPanel("Age Filter", 
                 sidebarLayout(
                     sidebarPanel(
                         selectInput("ageGroup", label = "Age Group:", 
                                     choices = c("7+", "13+", "16+", "18+", "all")
                         ),
                         h3("Plot Introduction & Conclusion"),
                         textOutput("summary")
                     ),
                     mainPanel(
                         plotOutput("plot")
                     )
                 )
            ),
        tabPanel("Page Conclusion", 
                     mainPanel(
                         br(),
                         img(src = "4platforms.jpg"),
                         h3("Conclusion/Analysis"),
                         tags$ul(
                             tags$li("Referring to the years chart, we can see movie production levels grew sizable amounts in 2000 - 2010 and beyond for all platforms. Disney+ also had many older movies compared to Hulu and Netflix which really only began streaming more movies mainly after 2010."), 
                             tags$li("
From the ratings chart, all movie platforms did not have higher than an imdb rating of 9. When it comes to ratings over 8, Netflix has the most, mainly for 18+ age group. Prime Video has the most movies, around 1500, all with ratings over 1. There are roughly over 800 movies with imdb ratings over 5, proving to be quite versatile compared to the other movie platforms. 
"), 
                             tags$li("In reference to the age charts, it appears that Prime Video had the most movies out of all the other platforms provided to all of the age groups. It was surprising that Prime Video, one of the cheaper subscriptions, had more movies than almost all netflix, hulu, and Disney + combined. 
Disney+ has only one film within 16+ age group movies. They come in second behind Prime Video for all age groups despite having less movies overall.
")
                         ),
                         h3("Reflection"),
                         p("Our dataset was gathered by Ruchi Bhatia, a profound and reputable data scientist within the Kaggle community. Although her dataset consisted of data scraping in the US region and combining the imdb dataset, there were a few questions and concerns of accuracy and collection methods by other scientists who referenced and used the data. It is unclear if all of the data is correct, complete, and/or  biased."),
                        p("In the future, to further this project it would be ideal to get in touch with Ruchi to discuss the dataset and collection method. It would also be keen to screen the accuracy and finally include new/missing data and more chart visualizations that would influence consumer interest."),
                        h3("Creators"),
                        tags$ul(
                            tags$li("Andy Hoang"), 
                            tags$li("Jessica Kuo"), 
                            tags$li("Justin Lee"),
                            tags$li("Sara Hamidi")
                        ),
                        br(),
                        img(src = "https://cdn.shopify.com/s/files/1/1003/7610/files/Movie_Banner-01.jpg?v=1475077727")
                    )
                )
        )
)