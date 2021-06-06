library(shiny)
library(tidyverse)
library(ggplot2)
library(maps)
library(rsconnect)

movieData <- read.csv("Movies.csv")

server <- function(input, output) {
    
    output$Plot <- renderPlot({
        
        if(input$platform == "All four platforms"){
            data2 <- movieData
        }
        else if(input$platform == "Netflix") {
            data2 <- filter(movieData, Netflix == "1")
        }
        else if(input$platform == "Hulu") {
            data2 <- filter(movieData, Hulu == "1")
        }
        else if(input$platform == "Prime.Video") {
            data2 <- filter(movieData, Prime.Video == "1")
        }
        else if(input$platform == "Disney.") {
            data2 <- filter(movieData, Disney. == "1")
        }
        
        ggplot(data2) +
            geom_bar(aes(x = Year, y = nrow(data2)), stat = 'identity', col = "blue") +
            labs(x = "Production Year",  y = "Amount of Movies Available", title = "Amount of Movies per Production Year (for different platforms)")
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
            geom_bar(mapping = aes(x = Age, fill = Age), position = "dodge", show.legend = FALSE)+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Disney+"))
        
        
    })
    #Reactive data for Age Filter
    totalData <- reactive({ 
        platformData <- movieData %>%
            select(Age, Netflix, Hulu, Prime.Video, Disney.) %>%
            filter(Age == input$ageGroup) %>%
            summarise("Netflix" = sum(Netflix), "Hulu" = sum(Hulu),"Prime Video" = sum(Prime.Video), "Disney+" = sum(Disney.))
        
    })
    output$ratingSummary <- renderText({
        paste0("There are ", nrow(netflix.data()), " movies on Netflix with IMDb ratings higher than", input$Rating, ",",
                                  nrow(hulu.data()), " movies on Hulu with IMDb ratings higher than", input$Rating, ",",
                                  nrow(prime.data()), " movies on Prime Video with IMDb ratings higher than", input$Rating, ",",
                                  nrow(disney.data()), " movies on Disney+ with IMDb ratings higher than", input$Rating, ".")
        })
    output$plot <- renderPlot({
        
        #Server for Age Filter
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
    
    #Summary for Age Plot Introduction & Conclusion
    output$summary <- renderText(
        paste0("In this bar chart, the platform updates on par with the age selection of ",
               input$ageGroup," rated movies totalling ", sum(totalData()), " films. This lets the users find out which platforms has
     the most suitable age-rated movies, helping those who are concern about the movies with apropriate ages. The widget allows them to select age ranging 7+, 13+, 16+, 18+ and all.
     The following platforms are showing the amount of movies 
     presented within the ", input$ageGroup," age group, Disney+ has ", totalData()$"Disney+", " movies, Hulu has ", totalData()$"Hulu", " movies, Netflix has 
     ", totalData()$"Netflix", " and Prime Video has ",totalData()$"Prime Video"," movies.")
        
    )
    
}
