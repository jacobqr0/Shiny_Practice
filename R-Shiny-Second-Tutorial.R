'''
==============================
HOW TO START SHINY TUTORIAL PART 2
==============================
https://shiny.rstudio.com/tutorial/
'''

library(shiny)

'''
What is reactivity?

example: Microsoft Excel
cells with function elements pointing to other cells will react when the inputs are changed

reactive values work together with reactive functions 
you cannot call a reactive value from outside of one.

reactive functions are a function that expects to take reactive values and know what to do with them

think of reactivity in R as a two step process 
-reactive values notify the functions that use them when they become invalid
-the objects created by the reactive function (the render function) respond

Reactive toolkit:
7 indispensible functions

reactive functions:
1. use a code chunk to build and rebuild an object
  -what code will the function use to build the object?
2. the object will respond to changes in a set of reactive values
  -which reactive values will the object respond to?

7 Render functions:
renderDataTable() - creates an interactive table
renderImage() - creates an image saed as a link to a source file
renderPlot() - creates a plot
renderPrint() - a code block of printed output
renderTable() - creates a table 
renderText() - a Character string
renderUI() - a shiny UI element

remember: that render builds reactive output to display in UI


When using the same input$<id> for multiple output objects, make sure to save your value to a variable 
before assigning them to the output objects:

'''
data <- rnorm(input$num)#need the reactive function for this

output$hist <- renderPlot({hist(data)})
output$stats <- renderPrint({summary(data)})

'''
reactive function builds a reactive object for the above example:
'''
data -reactive({rnorm(input$num)}) #object will respond to any object in the code block that changes

'''
reactive expression is special in two ways:
data()
1. You call a reactive expression like a function 
2. reactive expressions cache their values to avoid unnecessary computation

NOTE: Whenever you want to use the reactive input in an output object after assigning it to a variable, 
you must call data()
'''
data -reactive({rnorm(input$num)}) #object will respond to any object in the code block that changes

output$hist <- renderPlot({hist(data())})
output$stats <- renderPrint({summary(data())})

'''
FULL EXAMPLE BELOW
'''
library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  plotOutput("hist"),
  verbatimTextOutput("stats")
)

server <- function(input, output) {
  
  data <- reactive({
    rnorm(input$num)
  })
  
  output$hist <- renderPlot({
    hist(data())
  })
  output$stats <- renderPrint({
    summary(data())
  })
}

shinyApp(ui = ui, server = server)

'''
PREVENT REACTIONS WITH isolate()

Can we prevent the title field from updating the plot?
Yes! Use isolate()

returns the result as a non-reactive value.
'''

isolate({rnorm(input$num)})

'''
IMPLEMENTATION OF THIS IS IN THE BELOW EXAMPLE:
use isolate around the input$ for the title in the server definition
'''
library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  textInput(inputId = "title", 
            label = "Write a title",
            value = "Histogram of Random Normal Values"),
  plotOutput("hist")
)

server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num), main = isolate(input$title)) #USE ISOLATE IN THE SERVER FUNCTION
  })
}

shinyApp(ui = ui, server = server)

'''
NEW CONCEPT: observeEvent()
This triggers code to run on server 
-download data
-save data to write to files 
-pull data from database
-specify precuisely which reactive values should invalidate the observer
'''
observeEvent(input$clicks, {print(input$clicks)})

'''
EXAMPLE BELOW:
'''

# 05-actionButton

library(shiny)

ui <- fluidPage(
  actionButton(inputId = "clicks", 
    label = "Click me")
)

server <- function(input, output) {
  observeEvent(input$clicks, {
    print(as.numeric(input$clicks))
  })
}

shinyApp(ui = ui, server = server)

'''
observe()

also triggers code to run on server. 
Uses same syntax as render(), reactive(), and isolate()
'''
observe({print(input$clicks)})

'''
Delay events with eventReactive()

time:1hr 19 mins
'''
'''
Questions for review:
- In what part of the shiny template would you use the isolate() function? Why is this useful?
- How do you define output objects in the server function, using the render functionalities?
- What are the 7 indispensible render functions?
- What are the 2 main arguments in the shinyApp() function?
- What is the purpose of the observeEvent() function? What part of the shiny template is it used, and what is an
  example of what it can be used with? Where would this example item be placed in the Shiny Template?
'''

'''
Delay reactions with eventReactive()
example of implentation:
this function will make a reactive expression

unti the button is clicked, you can change the slider as much as you want until you click update.

you use eventReactive() to delay reactions
data() eventReactive creates a reactive expression

you can specify precisely which reactive values should invalidate the expression.

data <- eventReactive(input$go, {rnorm(input$num) })
''' 
# 07-eventReactive

library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  actionButton(inputId = "go", 
               label = "Update"),
  plotOutput("hist")
)

server <- function(input, output) {
  data <- eventReactive(input$go, {
    rnorm(input$num) 
  })
  
  output$hist <- renderPlot({
    hist(data())
  })
}

shinyApp(ui = ui, server = server)

'''
Manage state with reactiveValues()

reactiveValues() creates a list of reactive values to manipulate programmatically

rv <- reactiveValues(data = rnorm(100))

reactiveValues() creates a lsit of reactive values 
You can manipulate these values (usually with observeEvent)

'''
# 08-reactiveValues

library(shiny)

ui <- fluidPage(
  actionButton(inputId = "norm", label = "Normal"),
  actionButton(inputId = "unif", label = "Uniform"),
  plotOutput("hist")
)

server <- function(input, output) {
  
  rv <- reactiveValues(data = rnorm(100))
  
  observeEvent(input$norm, { rv$data <- rnorm(100) })
  observeEvent(input$unif, { rv$data <- runif(100) })
  
  output$hist <- renderPlot({ 
    hist(rv$data) 
  })
}

shinyApp(ui = ui, server = server)





