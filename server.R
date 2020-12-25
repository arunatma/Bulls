library(shiny)
library(shinyjs)

calcCowsBulls = function (hiddenWord, givenWord){
    hiddenWord <- tolower(hiddenWord)
    givenWord <- tolower(givenWord)
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

shinyServer(function(input, output, session) {
    resultdf <- data.frame()
    wordFound <- FALSE
    out_message <- ""
    fourLettered <-  as.vector(read.table("words.txt")[[1]])

    hiddenWord <- sample(fourLettered, 1)
    
    observe({
        # Change when the "update" or "restart" button is pressed...
        input$update
        # ...but not for anything else
        isolate({
            validate(
                need(nchar(input$guess) == 4, "Enter only 4 lettered word!")
            )        
            this_word <- input$guess
            curVal = calcCowsBulls(hiddenWord, input$guess)
            resultdf <<- resultdf[seq(dim(resultdf)[1],1),]
            resultdf <<- rbind(resultdf, 
                data.frame(Word=input$guess, Bulls=curVal[1], Cows=curVal[2]))
            resultdf <<- resultdf[seq(dim(resultdf)[1],1),]
#            names(resultdf) <- c("Word", "Bulls", "Cows")
            if(curVal[1] == 4){
                wordFound <<- TRUE
            }
            
            if(wordFound == FALSE){
                out_message <<- ""
            }
            
            if(wordFound == TRUE){
                numTry = dim(resultdf)[1]
                print(dim(resultdf)[1])
                out_message <<- paste("Word: ", this_word,"<br>Congratulations! Found in ", 
                    numTry," attempt(s)!", sep = "")
                
                updateTextInput(session, "guess", value = "")
                hiddenWord <<- sample(fourLettered, 1)
                print(hiddenWord)
                wordFound <<- FALSE
                #resultdf <<- data.frame()
                shinyjs::hide(id="update")
            }            
            resultdf
        })
    })

    observe({
        input$restart
        out_message <<- ""
        updateTextInput(session, "guess", value = "")
        shinyjs::show(id="update")

        hiddenWord <<- sample(fourLettered, 1)
        print(hiddenWord)
        wordFound <<- FALSE
        
        resultdf <<- data.frame()        
    })
    
    output$result <- renderTable({
        input$update
        input$restart
        resultdf
    })
    
    output$hidden <- renderText({
        input$restart
        isolate({
            #hiddenWord
            ""
        })    
    })

    output$winMessage <- renderText({
        input$update
        input$restart
        out_message
    })
    
})