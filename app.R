# load packages –---------------------------------------------------------------

library(tidyverse)
library(shiny)

# load data –-------------------------------------------------------------------

weather <- read_csv("data/weather.csv")

# create app –------------------------------------------------------------------

shinyApp(
  ui = fluidPage(
    titlePanel("Weather Forecasts"),
    sidebarLayout(
      sidebarPanel(
        # UI input code goes here
        selectInput(
          inputId = "city",
          label = "Select city",
          choices = c("Chicago", "Durham", "Sedona", "New York", "Los Angeles")
        ),
        selectInput(
          inputId = "variable",
          label = "Select variable",
          choices = c("temp", "feelslike", "humidity")
        )
      ),
      mainPanel(
        # UI output code goes here
        tabsetPanel(
          tabPanel(title = "Plot", plotOutput("plot")),
          tabPanel(title = "Data", dataTableOutput("data"))
        )
      )
    )
  ),
  server = function(input, output, session) {

    weather_city <- reactive({
      weather |>
        filter(city == input$city)
    })

    # server code goes here
    output$plot <- renderPlot({weather_city() |>
      ggplot(aes_string(x = "time", y = input$variable)) +
      geom_line(color = "red") +
      labs(title = paste(input$city, "-", input$variable))

    })

    output$data <- renderDataTable({
      weather_city() |>
        select(city, time, input$variable)
    })
  }
)
