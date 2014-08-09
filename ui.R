library(shiny)

shinyUI(
    fluidPage(
        titlePanel("Cows and Bulls"),
        sidebarLayout(      
            sidebarPanel(
                textInput("guess", "Guess:", ""),
                helpText("Input your guess here!"),
                hr(),
                actionButton("update", "Go!"),
                actionButton("restart", "Restart!")
            ),
            mainPanel(textOutput("hidden"), 
                tableOutput("result"),
                textOutput("winMessage"))
        )
    )
)
