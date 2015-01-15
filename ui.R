
library(shiny)

shinyUI(fluidPage(
  column(
    width = 8, offset = 2,
    fluidRow(
      titlePanel("Terminal App")
    ),
    fluidRow(
      textInput("cmd", "Command to run", "ls"),
      actionButton("runcmd", "Run")
    ),
    hr(),
    fluidRow(
      htmlOutput("console")
    )
  )
))

