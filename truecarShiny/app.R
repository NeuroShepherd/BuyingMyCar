#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("TrueCar"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("brand",
                        "Brand",
                        choices = c("Subaru","Toyota")),
            selectInput("model",
                        "Model",
                        choices = c("Observer fxn dependent on brand")),
            sliderInput("model_year",
                        "Model Year Range:",
                        min = 2000,
                        max = lubridate::year(Sys.Date()),
                        value = c(lubridate::year(Sys.Date())-1,lubridate::year(Sys.Date())),
                        sep = "",
                        dragRange = T),
            sliderInput("gas_mileage",
                        "Gas Mileage",
                        min = 0,
                        max = 150000,
                        value = c(0,150000),
                        post = " miles"),
            sliderInput("price",
                        "Car Price",
                        min = 0,
                        max = 60000,
                        value = c(0,60000),
                        pre = "$")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {


}

# Run the application 
shinyApp(ui = ui, server = server)
