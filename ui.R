library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(

  #  Application title
  headerPanel("Production Profiles, Exponential Decline Rate, Field-Based"),

  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    # Simple integer interval

   sliderInput("initialVolume", "Initial volume",
                  min = 1, max = 100, step = 1, value = 10),

   sliderInput("fractionPlateau", "Fraction Plateau",
                  min = 0, max = 1, step = 0.01, value = 0.1),

   sliderInput("fractionEOP", "Fraction End Of Plateau",
                  min = 0, max = 1, step = 0.01, value = 0.5),

   sliderInput("declineRate", "Decline Rate",
                  min = 0, max = 1, step = 0.01, value = 0.1),

   sliderInput("peakWellRate", "Peak Well Rate",
                  min = 0, max = 10, step = 0.1, value = 3.5),

   sliderInput("wellPlateauFactor", "Well Plateau Factor",
                  min = 0, max = 1, step = 0.01, value = 0)

  ),

  # Show a table summarizing the values entered
  mainPanel(
	plotOutput("mainplot")
#    tableOutput("values")
  )
))