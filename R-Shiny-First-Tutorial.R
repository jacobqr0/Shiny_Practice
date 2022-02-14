'''
==============================
HOW TO START SHINY TUTORIAL PART 1
==============================
https://shiny.rstudio.com/tutorial/

If you want to make a shiny app you need to make 2 components:

1. Create a User interface. 
2. Make a set of instructions for the server to follow so that it can handle anything that might happen with
   respect to user interactions.

When executing a user interface, the output is html code.

start every shiny app with the same template (code given in the lines below)
'''

library(shiny)

ui <- fluidPage("Hello World!")

server <- function(input, output) {}

shinyApp(ui = ui, server = server)

'''
Inputs - things that your user can toggle or use to select variables or put in values
Outputs - things that respond when your user changes the inputs.

Add elements to your app as arguments to fluidPage()
'''
ui <- fluidPage("Hello World!",
                sliderInput(inputId ="num",
                            label = "Choose a number",
                            value = 25, min = 1, max = 100))

server <- function(input, output) {}

shinyApp(ui = ui, server = server)

''' 
syntax for building inputs:

inputId (for internal use)
label to display (no label for your input would be an empty string)
there are input specific arguments as well. 
'''

'''
To display an ouput:
add it to fluidPage() with an Output function
'''
#With output
ui <- fluidPage("Hello World!",
                sliderInput(inputId ="num",
                            label = "Choose a number",
                            value = 25, min = 1, max = 100),
                            plotOutput("hist"))

server <- function(input, output) {}

shinyApp(ui = ui, server = server)

''' 
RECAP:

1. Begin each app with the template above.
2. Add elements as arguments to fluidPage()
3. Create reactive inputs with an *Input() function
4. Display reactive results with an *Output() function
5. Use the server function to assemble inputs to outputs.

Next thing you have to do: 
- you must tell the server how to display the inputs and outputs

3 rules for the server function:

1. must save objects to display to output$"<item name>"
2. What you save into output must be built with a render() function
   - these create the type of output you wish to make
3. Use input values with input$
  - sliders, check boxes, etc
  -can access your inputId with input$<inputId>


sytax of renderPlot()
- type of object to build PLOT
-code block that builds the object using the braces 

Reactivity automatically occurs whenever you use an input value to render an output object
'''
#example:

ui <- fluidPage(
      sliderInput(inputId ="num",
      label = "Choose a number",
      value = 25, min = 1, max = 100),
      plotOutput("hist")
))

server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num))
  })
}

shinyApp(ui = ui, server = server)

'''
In order for a server to run your shiny app, you must save your app in a specific format.
One directory with every file the app needs:
- app.R (your script which ends with a call to shinyApp())
- datasets, images, css, help scripts, etc
  
Sometimes it is advantageous to save your shiny app in 2 files.
server.R tells the server what to do
ui.R contains your input and output definitions using the fluidPage() function
'''

'''
Use shinyapps.io
-a server maintained by RStudio 
-free to use
