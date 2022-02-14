'''
==============================
HOW TO START SHINY TUTORIAL PART 3
==============================
https://shiny.rstudio.com/tutorial/
'''

library(shiny)

'''
The user interface of your app is really just HTML.

'''

'''
How do you add content to a web page? 

When writing R, you add content with tags functions.

tags$h1() same as <h1></h1>

tags objects- each element of the tags list is a function that recreates an html tag.

A list of functions. 

tags$h1 tells you the html function that builds the object youre creating
tags$h1() runs the fucntion

tags$a(href = "www.rstudio.com", "RStudio")
arguments: the list of name tags, function/tag name, named arguments appear as tag attributes, unamed arguments appear
inside the tags.

character strings do not need a tag. 

nesting: you can nest tags inside of other tags, example: bold in text

Adding images from an image saved on your file:
must save the file in a subdirectory in your App-Directory called www
then you use the file name as the source argument in your tags$ function
you dont need to put www in front of your image file name
'''
# 02-tags.R

library(shiny)

ui <- fluidPage(
  h1("My Shiny App"),
  p(style = "font-family:Impact",
    "See other apps in the",
    a("Shiny Showcase",
      href = "http://www.rstudio.com/
      products/shiny/shiny-user-showcase/")
  )
)

server <- function(input, output){}

shinyApp(ui = ui, server = server)

'''
Some tags functions come with a wrapper function, so you do not need to call tags$

h1() rather than tags$h1()

You can pass html directly within a character string in the html function, and pass that html function to the 
fluid page function.

REcap: 
add elements with the tags$ function
unnamed arguments are passed into HTML tags
named arguments are passed as HTML tag attributes 
add raw html with HTML
'''

''' 
Create a Layout

Use Layout functions to position elements within your app.

can move elements within the x,y dimensions
can stack elements by placing them on the z dimension 

Layout functions:
-add html that divides the UI into a grid 

fluidRow()

column(width = 2)

FluidRow() adds rows to te grid
each new row goes below the previous rows.

fluid rows work together with the column functions to place objects within the layout

column adds columns within a row, each new column goes to the left of the previous column
specify the width and offset of each column out of 12

within the columns that are occurring in the fluidRow() function, you can pass your input or output objects

REcap Layout functions:

-position elements in a grid or stack them in layers

-use fluidRow() to arrange elements in rows 
-use colukn() to arrange elements in columns 

-column take width and offset arguments

'''
# 03-layout.R

library(shiny)

ui <- fluidPage(
  fluidRow(
    column(3),
    column(5, sliderInput(inputId = "num", 
                          label = "Choose a number", 
                          value = 25, min = 1, max = 100))
  ),
  fluidRow(
    column(4, offset = 8,
           plotOutput("hist")
    )
  )
)

server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num))
  })
}

shinyApp(ui = ui, server = server)
'''
How to Stack Layers

Panels - basic unit in shiny
Panels to group multiple elements into a single unit with its own properties

WellPanel() 
- group elements into a grey "well"

Shiny contains many different functions to create different panels

Use the tabPanel() function to create a stackable layer of elements. Each tab is like a small UI of its own.

tabsetPanel() combines tabs into a singal panel. Use tabs to navigate between tabs

navlistPanel() combines tabs into a single panel. USe links to navigate between tabs

REcap: Panels

-Panels group elements into a single unit for aesthetic or functional reasons
-Use tabPanel() to create a stackable panel
-Use tabsetPanel() to arrange tab panels into a stack with tab navigation
-Use navlistPanel() toarrange tab panels into a stack with sidebar navigation

See the shiny layout guide to help you build sophisticated, customized layouts with Shinys grid system:

http://shiny.rstudio.com/articles/layout-guide.html

'''
# 04-well.R

library(shiny)

ui <- fluidPage(
  wellPanel(
    sliderInput(inputId = "num", 
                label = "Choose a number", 
                value = 25, min = 1, max = 100),
    textInput(inputId = "title", 
              label = "Write a title",
              value = "Histogram of Random Normal Values")
  ),
  plotOutput("hist")
)

server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num), main = input$title)
  })
}

shinyApp(ui = ui, server = server)

''' 
Panels are a way that you can group together elements in an app
'''

# 05-tabs.R

library(shiny)

ui <- fluidPage(title = "Random generator",
                tabsetPanel(              
                  tabPanel(title = "Normal data",
                           plotOutput("norm"),
                           actionButton("renorm", "Resample")
                  ),
                  tabPanel(title = "Uniform data",
                           plotOutput("unif"),
                           actionButton("reunif", "Resample")
                  ),
                  tabPanel(title = "Chi Squared data",
                           plotOutput("chisq"),
                           actionButton("rechisq", "Resample")
                  )
                )
)

server <- function(input, output) {
  
  rv <- reactiveValues(
    norm = rnorm(500), 
    unif = runif(500),
    chisq = rchisq(500, 2))
  
  observeEvent(input$renorm, { rv$norm <- rnorm(500) })
  observeEvent(input$reunif, { rv$unif <- runif(500) })
  observeEvent(input$rechisq, { rv$chisq <- rchisq(500, 2) })
  
  output$norm <- renderPlot({
    hist(rv$norm, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard normal distribution")
  })
  output$unif <- renderPlot({
    hist(rv$unif, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard uniform distribution")
  })
  output$chisq <- renderPlot({
    hist(rv$chisq, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a Chi Square distribution with two degree of freedom")
  })
}

shinyApp(server = server, ui = ui)

# 06-navlist.R

library(shiny)

ui <- fluidPage(title = "Random generator",
                navlistPanel(              
                  tabPanel(title = "Normal data",
                           plotOutput("norm"),
                           actionButton("renorm", "Resample")
                  ),
                  tabPanel(title = "Uniform data",
                           plotOutput("unif"),
                           actionButton("reunif", "Resample")
                  ),
                  tabPanel(title = "Chi Squared data",
                           plotOutput("chisq"),
                           actionButton("rechisq", "Resample")
                  )
                )
)

server <- function(input, output) {
  
  rv <- reactiveValues(
    norm = rnorm(500), 
    unif = runif(500),
    chisq = rchisq(500, 2))
  
  observeEvent(input$renorm, { rv$norm <- rnorm(500) })
  observeEvent(input$reunif, { rv$unif <- runif(500) })
  observeEvent(input$rechisq, { rv$chisq <- rchisq(500, 2) })
  
  output$norm <- renderPlot({
    hist(rv$norm, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard normal distribution")
  })
  output$unif <- renderPlot({
    hist(rv$unif, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard uniform distribution")
  })
  output$chisq <- renderPlot({
    hist(rv$chisq, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a Chi Square distribution with two degree of freedom")
  })
}

shinyApp(server = server, ui = ui)

'''
Alternatively, you can use a prepackaged layout:

sidebarLayout() - use with sidebarPanel() and mainPage() to divide app into two sections 
'''
# 07 sidebarLayout

library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "num", 
                  label = "Choose a number", 
                  value = 25, min = 1, max = 100),
      textInput(inputId = "title", 
                label = "Write a title",
                value = "Histogram of Random Normal Values")
    ),
    mainPanel(
      plotOutput("hist")
    )
  )
)

server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num), main = input$title)
  })
}

shinyApp(ui = ui, server = server)

'''
fixedPage() creates a page that defaults to a width of 724, 940, or 1170 pixels. Use with fixedRow() instead of fluidRow()

navbarPage() - combines tabs into a single page.This replaces fluidPage(). Requires title.
'''
# 06-navlist.R

library(shiny)

ui <- navbarPage(title = "Random generator",
                 tabPanel(title = "Normal data",
                          plotOutput("norm"),
                          actionButton("renorm", "Resample")
                 ),
                 tabPanel(title = "Uniform data",
                          plotOutput("unif"),
                          actionButton("reunif", "Resample")
                 ),
                 tabPanel(title = "Chi Squared data",
                          plotOutput("chisq"),
                          actionButton("rechisq", "Resample")
                 )
                 
)

server <- function(input, output) {
  
  rv <- reactiveValues(
    norm = rnorm(500), 
    unif = runif(500),
    chisq = rchisq(500, 2))
  
  observeEvent(input$renorm, { rv$norm <- rnorm(500) })
  observeEvent(input$reunif, { rv$unif <- runif(500) })
  observeEvent(input$rechisq, { rv$chisq <- rchisq(500, 2) })
  
  output$norm <- renderPlot({
    hist(rv$norm, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard normal distribution")
  })
  output$unif <- renderPlot({
    hist(rv$unif, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard uniform distribution")
  })
  output$chisq <- renderPlot({
    hist(rv$chisq, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a Chi Square distribution with two degree of freedom")
  })
}

shinyApp(server = server, ui = ui)

'''
navbarMenu() - is a tab with a dropdown menu with the tiles in the tabs you place in the function
'''
# 06-navlist.R

library(shiny)

ui <- navbarPage(title = "Random generator",
                 tabPanel(title = "Normal data",
                          plotOutput("norm"),
                          actionButton("renorm", "Resample")
                 ),
                 navbarMenu(title = "Other data",
                            tabPanel(title = "Uniform data",
                                     plotOutput("unif"),
                                     actionButton("reunif", "Resample")
                            ),
                            tabPanel(title = "Chi Squared data",
                                     plotOutput("chisq"),
                                     actionButton("rechisq", "Resample")
                            )
                 )
)

server <- function(input, output) {
  
  rv <- reactiveValues(
    norm = rnorm(500), 
    unif = runif(500),
    chisq = rchisq(500, 2))
  
  observeEvent(input$renorm, { rv$norm <- rnorm(500) })
  observeEvent(input$reunif, { rv$unif <- runif(500) })
  observeEvent(input$rechisq, { rv$chisq <- rchisq(500, 2) })
  
  output$norm <- renderPlot({
    hist(rv$norm, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard normal distribution")
  })
  output$unif <- renderPlot({
    hist(rv$unif, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard uniform distribution")
  })
  output$chisq <- renderPlot({
    hist(rv$chisq, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a Chi Square distribution with two degree of freedom")
  })
}

shinyApp(server = server, ui = ui)

'''
dashboardPage() dashboardPage() comes with the shinydashboard package
'''

'''
Styling with CSS

What is CSS?

Cascading Style Sheets (SS) area framework for customizing the appearance of elements in a webpage

Can style a webpage in three ways:
1. link to an external CSS file 
2. write global CSS in header
3 Write individual CSS in a tags style attribute 

Shiny uses the Bootstrap 3 CSS framework, getbootstrap.com

If you want to use an external CSS file in your shiny app, make sure you put it in the www folder in your working
directory.

set the theme argument in the fluidPage() function to the name of your CSS file that you wish to style with
'''
