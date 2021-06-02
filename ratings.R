
library(ggplot2)
library(dplyr)
library(tidyverse)

# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("IMDb Ratings for Movies offered on Netflix, Hulu, Prime Video, and Disney+"),
#   
#   # Sidebar with a dropdown menus to select time of day and type of bar chart
#   sidebarLayout(
#     sidebarPanel(
#       helpText("Create a plot displaying the IMDb Ratings over the years"),
#       
#       selectInput("agegroup", 
#                   label = "Choose your desired age group:",
#                   choices = c("7+", "13+", "16+", "18+", "all")
#       )
#     ),
#     
#     
#     # Show a plot of the generated distribution
#     mainPanel(
#       plotOutput("chart"),
#       textOutput("summary")
#     )
#   )
#   
# ))

movieData <- read.delim("MoviesOnStreamingPlatforms_updated.csv", sep = ",")%>%
  filter(Country == "United States", Age == "all")%>%
  drop_na(Age)

trying <- ggplot(movieData) +
  geom_point(mapping = aes(x = Year, y = IMDb))+
  labs(title = "IMDb ratings over time of movies for all")
  
  #labs(title = "Top counties with black incarcerations over time")
print(trying)

# shinyServer(function(input, output) {
#   
#   inputData <- reactive(
#     filter(movieData, Age == input$agegroup)
#   )
#   output$chart <- renderPlot({
#     ggplot(movieData) +
#       geom_point(mapping = aes(x = Year, y = IMDb)) +
#       labs(title = paste("IMDb ratings over time of movies for", input$agegroup))
#   })
#   output$summary <- renderText(
#     paste0("There are ", nrow(filter(inputData(), IMDb > 6)), " movies for ", input$agegroup, "ages with an IMDb rating higher than 6.")
#   )
#   
#   
#})

