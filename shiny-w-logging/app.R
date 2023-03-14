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
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {

### LOGGING SETUP
    if(Sys.getenv("R_CONFIG_ACTIVE") == "rsconnect") {
        user_name <- session$user
    } else {
        user_name <- "test"
    }
    start_time <- Sys.time()
    session_id <- runif(1, 100000, 10000000)
    
### Output a start message
    message("starting at: ", start_time, " on process: ", Sys.getpid(), 
            " for user:", user_name, 
            " with session_id: ", session_id)

    
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

### Event to log
        time1 <- Sys.time()
        message("starting plot: ", time1, " on process: ", Sys.getpid(), 
                " for user:", user_name, 
                " with session_id: ", session_id)

### Introduce some deliberate delay for illustration purposes
        Sys.sleep(5)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')

### Event to log
        time2 <- Sys.time()
        message("ending plot: ", time2, " on process: ", Sys.getpid(), 
                " for user:", user_name, 
                " with session_id: ", session_id,
                " it took: ", difftime(time2, time1), " seconds")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
