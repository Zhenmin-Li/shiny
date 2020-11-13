library(shiny)
library(tidyverse)
library(plotly)
library(dplyr)
library(tibble)

args <- commandArgs(trailingOnly=T);

port <- as.numeric(args[[1]]);

data <- read_csv("derived_data/sentiment_afinn_ran.csv")


# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Superhero Powers and Alignment"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      div("Sentiments of COVID related tweets"),
      
      # Input: Slider for the number of bins ----
      sliderInput("slider", "Time", min = as.Date("2020-02-01"), max =as.Date("2020-10-18"),value=as.Date("2020-02-01"),timeFormat="%Y-%m-%d"),
      
      selectInput(inputId = "plotType",
                  label = "Plot Type",
                  choices=c("USmap","Histogram"))
      
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotlyOutput(outputId = "distPlot")
      
    )
  )
)



server <- function(input, output) {
  
  output$distPlot <- renderPlotly({
    
    curr <- subset(data %>% filter(date == input$slider),select=c(location, polarity))
    polarity <- tibble::deframe(curr)
    
    if(input$plotType=="Histogram"){
      ggplot(curr, aes(reorder(location, polarity), polarity)) + 
        geom_col(aes(fill = location)) + coord_flip() + 
        labs(x = "Team", y = "PTS") + 
        geom_hline(aes(yintercept = mean(polarity)), color = "red")
    }
    else{
      g <- list(
        scope = 'usa',
        projection = list(type = 'albers usa'),
        lakecolor = toRGB('white')
      )
      
      plot_geo() %>%
        add_trace(
          z = ~polarity, text = state.name, span = I(0),
          locations = state.abb, locationmode = 'USA-states'
        ) %>%
        layout(title = input$slider,
               geo = g)  
    }
    
    
  })
  
}

print(sprintf("Starting shiny on port %d", port));

shinyApp(ui = ui, server = server, options = list(port=port,
host="0.0.0.0"));




