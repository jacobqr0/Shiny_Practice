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
    titlePanel("Hendon Inorganics Data Analysis"),

    # Sidebar with a select input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("chem",
                        "Chemical to Plot:",
                        choices = unique(offsite_detects$ChemName)),
            
            selectInput("well",
                        "Well ID: ",
                        choices= unique(offsite_detects$Location_Code))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("boxplot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$boxplot <- renderPlot({
  
        # draw the boxplot
        plot_chemdata(offsite_detects, input$well, input$chem)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
