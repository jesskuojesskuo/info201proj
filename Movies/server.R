library(shiny)
library(tidyverse)
library(ggplot2)
library(maps)
library(rsconnect)

movieData <- read.csv("Movies.csv")

server <- function(input, output) {
    
    output$Plot <- renderPlot({
        
        if(input$platform == "All four platforms"){
            data2 <- data
        }
        else if(input$platform == "Netflix") {
            data2 <- filter(data, Netflix == "1")
        }
        else if(input$platform == "Hulu") {
            data2 <- filter(data, Hulu == "1")
        }
        else if(input$platform == "Prime.Video") {
            data2 <- filter(data, Prime.Video == "1")
        }
        else if(input$platform == "Disney.") {
            data2 <- filter(data, Disney. == "1")
        }
        
        ggplot(data2) +
            geom_bar(aes(x = Year, y = nrow(data2)), stat = 'identity') 
    })
    
    netflix.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Netflix  == 1, Age != "")%>%
            drop_na(Age)
    )
    
    hulu.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Hulu  == 1, Age != "")%>%
            drop_na(Age)
    )
    
    prime.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Prime.Video  == 1, Age != "")%>%
            drop_na(Age)
    )
    
    disney.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Disney. == 1, Age != "")%>%
            drop_na(Age)
    )
    
    output$netflix <- renderPlot({
        ggplot(netflix.data()) +
            geom_bar(mapping = aes(x = Age, fill = Age), position = "dodge", show.legend = FALSE)+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Netflix"))
        
        
    })
    output$hulu <- renderPlot({
        ggplot(hulu.data()) +
            geom_bar(mapping = aes(x = Age, fill = Age), position = "dodge", show.legend = FALSE)+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Hulu"))
        
        
    })
    output$prime <- renderPlot({
        ggplot(prime.data()) +
            geom_bar(mapping = aes(x = Age, fill = Age), position = "dodge", show.legend = FALSE)+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Prime Video"))
        
        
    })
    
    output$disney <- renderPlot({
        ggplot(disney.data()) +
            geom_bar(mapping = aes(x = Agels, fill = Age), position = "dodge", show.legend = FALSE)+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Disney+"))
        
        
    })
    
    netflixData <- reactive({ 
        platformData <- movieData %>%
            select(Age, Netflix, Hulu, Prime.Video, Disney.) %>%
            filter(Age == input$ageGroup) %>%
            summarise(Netflix = sum(Netflix))
        
    })
    output$plot <- renderPlot({
        
        platformData <- movieData %>%
            select(Age, Netflix, Hulu, Prime.Video, Disney.) %>%
            filter(Age == input$ageGroup) %>%
            summarise("Netflix" = sum(Netflix), "Hulu" = sum(Hulu),"Prime Video" = sum(Prime.Video), "Disney+" = sum(Disney.))     
        
        platformMovieAmount <- platformData %>%
            pivot_longer("Netflix":"Disney+", names_to = "platform", values_to = "totalMovies")
        
        ggplot(data=platformMovieAmount, aes(x= platform, y= totalMovies, fill=platform)) +
            geom_bar(stat="identity", show.legend = FALSE)+
            labs(title = paste("Platforms that supported age", input$ageGroup,"rated movies")) +
            xlab("Platform") + ylab("Total amount of Movies")
        
        
    })
    output$summary <- renderText(
        paste0("In this bar chart, the platform updates on par with the age selection ",
               input$ageGroup," rated movies.  Netflix provides ", netflixData()," in that age range.")
    )
    
}
