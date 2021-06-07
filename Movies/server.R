library(shiny)
library(tidyverse)
library(ggplot2)
library(rsconnect)

#Read file
movieData <- read.csv("movies.csv")

server <- function(input, output) {
    
    #reactive data/server for the "year filter" tab 
    #depending on the radio buttons selection from the widget, the data will alter
    #if-else statements read the selection and determine which data to filter from the csv
    #we will filter so there is only the rows where the selection is = to 1
    
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
        
        #a bar chart with year on x axis and the count(of row) on the y axis is shown
        #the color of the bar chart is blue and information is from data2, which is the filter platform
        #from this graph we can determine how many movies there are from each year for platforms
        
        ggplot(data2) +
            geom_bar(aes(x = Year, y = nrow(data2)), stat = 'identity', col = "blue") +
            labs(x = "Production Year",  y = "Amount of Movies Available", title = "Amount of Movies per Production Year (for different platforms)")
    })
    
    #----------------------------------------------------------------------------
    
    #reactive data for the "rating filter" tab
    #data for the bar chart for netflix
    #for all bar charts, only movies for the United States are shown
    #IMdb is above the user input
    #exclude observations where the "Age"  variable is empty or N/A
    
    #Netflix
    netflix.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Netflix  == 1, Age != "")%>%
            drop_na(Age)
    )
    
    #Hulu
    hulu.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Hulu  == 1, Age != "")%>%
            drop_na(Age)
    )
    
    #Prime Video
    prime.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Prime.Video  == 1, Age != "")%>%
            drop_na(Age)
    )
    
    #Disney+
    disney.data <- reactive(
        filter(movieData, Country == "United States", IMDb > input$Rating, Disney. == 1, Age != "")%>%
            drop_na(Age)
    )
    
    #Create 4 bar charts, 1 for each platform
    #x-axis is the age groups
    #bars are vertical
    #hide the legend
    #title of the bar charts update based on the users' inputted rating
    
    #Netflix
    output$netflix <- renderPlot({
        ggplot(netflix.data()) +
            geom_bar(mapping = aes(x = Age, fill = Age), position = "dodge", show.legend = FALSE)+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Netflix"))
    })
    
    #Hulu
    output$hulu <- renderPlot({
        ggplot(hulu.data()) +
            geom_bar(mapping = aes(x = Age, fill = Age), position = "dodge", show.legend = FALSE)+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Hulu"))
    })
    
    #Prime Video
    output$prime <- renderPlot({
        ggplot(prime.data()) +
            geom_bar(mapping = aes(x = Age, fill = Age), position = "dodge", show.legend = FALSE)+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Prime Video"))
    })
    
    #Disney+
    output$disney <- renderPlot({
        ggplot(disney.data()) +
            geom_bar(mapping = aes(x = Age, fill = Age), position = "dodge", show.legend = FALSE)+
            labs(title = paste("The Amount of Movies with an IMDb rating higher than", input$Rating, "On Disney+"))
    })
    
    #Reactive data for Age Filter Plot and rendertext summary,
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
    
    #----------------------------------------------------------------------------
    
    #Server for Age Filter
    #uses totalData to make the components of the bar chart
    #x-axis is the 4 platforms and y axis are the amount of movies they have
    #hide the legend
    #title can alternate depending on the input of age group
    
    output$plot <- renderPlot({
        platformMovieAmount <- totalData() %>%
            pivot_longer("Netflix":"Disney+", names_to = "platform", values_to = "totalMovies")
        
        ggplot(data=platformMovieAmount, aes(x= platform, y= totalMovies, fill=platform)) +
            geom_bar(stat="identity", show.legend = FALSE) +
            labs(title = paste("Platforms that supported age", input$ageGroup,"rated movies")) +
            xlab("Platform") + ylab("Total amount of Movies")
    })
    
    #Summary for Age Plot Introduction & Conclusion
    #Uses reactive and selectInput to display results of age choice
    output$summary <- renderText(
        paste0("In this bar chart, the platform updates on par with the age selection of ",
               input$ageGroup," rated movies totalling ", sum(totalData()), " films. This lets the users find out which platforms has
     the most suitable age-rated movies, helping those who are concern about the movies with apropriate ages. The widget allows them to select age ranging 7+, 13+, 16+, 18+ and all.
     The following platforms are showing the amount of movies 
     presented within the ", input$ageGroup," age group: Disney+ has ", totalData()$"Disney+", " movies, Hulu has ", totalData()$"Hulu", " movies, Netflix has 
     ", totalData()$"Netflix", " and Prime Video has ",totalData()$"Prime Video"," movies.")
        
    )
    
}
