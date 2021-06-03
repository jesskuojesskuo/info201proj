#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

movieData <- read.delim("MoviesOnStreamingPlatforms_updated.csv", sep = ",")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    netflix.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Netflix  == 1)%>%
            drop_na(Age)
    )
    
    hulu.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Hulu  == 1)%>%
        drop_na(Age)
    )
    
    prime.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Prime.Video  == 1)%>%
        drop_na(Age)
    )
    
    disney.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Disney. == 1)%>%
        drop_na(Age)
    )

    output$netflix <- renderPlot({
        ggplot(netflix.data()) +
            geom_bar(mapping = aes(x = Country, fill = Age), position = "dodge")+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Netflix"))
        

    })
    output$hulu <- renderPlot({
        ggplot(hulu.data()) +
            geom_bar(mapping = aes(x = Country, fill = Age), position = "dodge")+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Hulu"))
        
        
    })
    output$prime <- renderPlot({
        ggplot(prime.data()) +
            geom_bar(mapping = aes(x = Country, fill = Age), position = "dodge")+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Prime Video"))
        
        
    })
    
    output$disney <- renderPlot({
        ggplot(disney.data()) +
            geom_bar(mapping = aes(x = Country, fill = Age), position = "dodge")+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Disney+"))
        
        
    })

})
