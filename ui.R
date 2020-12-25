library(shinydashboard)
library(shiny)
library(data.table)
library(shinyjs)


dashboardPage(
    dashboardHeader(title = "GuessMe"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Game Play", tabName = "game_area", icon = icon("barcode")),
            menuItem("Game Controls", tabName = "game_ctrl", icon = icon("th"))
        )
    ),
    dashboardBody(
        tabItems(
            # First Tab 
            tabItem(tabName = "game_area",
                pageWithSidebar(
                    # Application title
                    headerPanel("Game Arena"),
                  
                    sidebarPanel(
                        useShinyjs(),
                        actionButton("restart", "Restart!"),
                        helpText("Bull: The letter is correct and placed in the right position"),
                        helpText("Cow: The letter is correct but placed in a wrong position"),
                        helpText("Input your guess here (4 letter word)!"),
                        textInput("guess", "Guess:", ""),
                        actionButton("update", "Go!")
                    ),
                  
                    mainPanel(
                        textOutput("hidden"), 
                        tableOutput("result"),
                        htmlOutput("winMessage")
                    )
                )
            ),
            tabItem(tabName = "game_ctrl",
                fluidPage(
                    # Application title
                    h2("Game Controls")
                )
            )
        )
    )
)



