library(shiny)
library(plotly)
library(palmerpenguins)
library(dplyr)
library(viridis)

data(penguins)
# Remove NAs
penguins <- 
  penguins %>% 
    filter(!is.na(species),
           !is.na(bill_length_mm), 
           !is.na(bill_depth_mm)
           ) %>%
  mutate(id = row_number())

# Define color palette
palette <- viridis::inferno(n = 5)
color_map <- c(
  "Adelie" = palette[2],
  "Gentoo" = palette[3],
  "Chinstrap" = palette[4]
)

ui <- fluidPage(
  plotlyOutput("penguinPlot")
)

server <- function(input, output, session) {
  
  # Initial black point plot
  output$penguinPlot <- renderPlotly({
    plot_ly(
      data = penguins,
      x = ~bill_length_mm,
      y = ~bill_depth_mm,
      type = "scatter",
      mode = "markers",
      marker = list(color = "black", size = 8, opacity = .8),
      text = ~paste("Species:", species),
      customdata = ~species,
      source = "penguinPlot"
    ) %>%
      layout(
        title = list(
          text = "Penguin Bill Measurements<br><sup>Hover to reveal species</sup>",
          x = 0.05,
          xanchor = "left"
        ),
        xaxis = list(title = "Bill Length (mm)"),
        yaxis = list(title = "Bill Depth (mm)")
      )
  })
  
  # Update color on hover
  observe({
    hovered <- event_data("plotly_hover", source = "penguinPlot")
    
    if (is.null(hovered)) return()
    
    hovered_species <- hovered$customdata
    
    # Assign colors and shapes based on hovered species
    new_colors <- 
      ifelse(
        penguins$species == hovered_species,
        color_map[hovered_species],
        "black"
    )

    
    
    plotlyProxy("penguinPlot", session) %>%
      plotlyProxyInvoke("restyle", list(marker = list(color = new_colors)))
  })
  
  # Reset to black when hover ends
  observeEvent(event_data("plotly_unhover", source = "penguinPlot"), {
    plotlyProxy("penguinPlot", session) %>%
      plotlyProxyInvoke("restyle", list(marker = list(color = rep("black", nrow(penguins)))), list(0))
  })
}

shinyApp(ui, server)

