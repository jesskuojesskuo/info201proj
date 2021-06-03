

library(shiny)

shinyUI(fluidPage(

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("Rating",
                "IMDb ratings for movies", 
                min = 0, 
                max = 10,
                value = 5)
        ),
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("netflix"),
            plotOutput("hulu"),
            plotOutput("prime"),
            plotOutput("disney")
        )
    )
))

