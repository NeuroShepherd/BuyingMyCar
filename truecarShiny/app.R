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
                        choices = c("","Subaru","Toyota")),
            selectInput("model",
                        "Model",
                        choices = c("","Outback")),
            sliderInput("model_year",
                        "Model Year Range:",
                        min = 2000,
                        max = lubridate::year(Sys.Date()),
                        value = c(lubridate::year(Sys.Date())-1,lubridate::year(Sys.Date())),
                        sep = "",
                        dragRange = T),
            sliderInput("car_mileage",
                        "Car Mileage",
                        min = 0,
                        max = 150000,
                        value = c(0,150000),
                        post = " miles"),
            sliderInput("price",
                        "Car Price",
                        min = 0,
                        max = 60000,
                        value = c(0,60000),
                        pre = "$"),
            textInput("location",
                      "Location"),
            sliderInput("distance",
                        "Car Distance",
                        min = 0,
                        max = 500,
                        value = 75)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           tableOutput("table")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    create_data <- reactive({
        
        scrape_truecar_data(make = input$brand,
                            model = input$model,
                            location = input$location,
                            min_year = input$model_year[[1]],
                            max_year = input$model_year[[2]],
                            searchRadius = input$distance)
        
    })
    
    output$table <- renderTable({
        
        create_data()
        
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
