library(shiny)
library(tidyverse)
library(ggplot2)
library(maps)
library(rsconnect)

data <- read.csv("Movies.csv")
print(list.files("../jessicakuo/Desktop/Classes/INFO 201/info201proj"))

ui <- fluidPage(

    titlePanel("Old Faithful Geyser Data"),

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
)
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
    output$Message <- renderText({
        paste(input$platform)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
