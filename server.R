library(shiny)

calcCowsBulls = function (hiddenWord, givenWord){
    if(givenWord == "") {
        return(c(-1,-1))
    }
    spl1 = strsplit(hiddenWord, "")[[1]]
    spl2 = strsplit(givenWord, "")[[1]]
    numBulls = length(spl1[(spl1 == spl2)])

    joined = paste(givenWord, givenWord, sep="")
    numCows = 0
    wordLen = length(spl1)
    for(i in 2 : wordLen){
        spl3 = strsplit(joined, "")[[1]][i : (i + wordLen - 1)]
        numCows = numCows + length(spl1[(spl1 == spl3)])
    }
    return(c(numBulls, numCows))
}

resultdf = data.frame()
wordFound = FALSE
fourLettered = as.vector(read.table("words.txt")[[1]])
hiddenWord = ""

shinyServer(function(input, output, session) {

    hiddenWord <<- sample(fourLettered, 1)
    
    processNow <- reactive({
        # Change when the "update" button is pressed...
        input$update
        # ...but not for anything else
        isolate({
            validate(
                need(nchar(input$guess) == 4, "Enter only 4 lettered word!")
            )        
            curVal = calcCowsBulls(hiddenWord, input$guess)
            resultdf <<- rbind(resultdf, 
                data.frame(input$guess, curVal[1], curVal[2]))
            names(resultdf) = c("Word", "Bulls", "Cows")
            if(curVal[1] == 4){
                wordFound <<- TRUE
            }
            resultdf
        })
    })


    restartNow <- reactive({
        # Change when the "restart" button is pressed...
        input$restart
        # ...but not for anything else
        isolate({
            hiddenWord <<- sample(fourLettered, 1)
            print(hiddenWord)
            resultdf <<- data.frame()
            wordFound <<- FALSE
        })
    })
    
    output$result <- renderTable({
        restartNow()
        processNow()
    })
    
    output$hidden <- renderText({
        input$restart
        isolate({
            #hiddenWord
        })    
    })

    outMessage <-  reactive({
        input$update
        isolate({
            msgVal = ""
            if(wordFound == TRUE){
                numTry = dim(resultdf)[1]
                print(dim(resultdf)[1])
                msgVal = paste("Congratulations! Found in ", 
                    numTry," attempt(s)!", sep = "")
            }
            msgVal
        })
    })
    
    output$winMessage <- renderText({
        outMessage()
    })
    
})