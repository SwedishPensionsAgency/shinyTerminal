
library(shiny)

robust.system <- function (cmd) {
  stderrFile = tempfile(pattern="R_robust.system_stderr", fileext=as.character(Sys.getpid()))
  stdoutFile = tempfile(pattern="R_robust.system_stdout", fileext=as.character(Sys.getpid()))
  
  retval = list()
  retval$exitStatus = system(paste0(cmd, " 2> ", shQuote(stderrFile), " > ", shQuote(stdoutFile)))
  retval$stdout = readLines(stdoutFile)
  retval$stderr = readLines(stderrFile)
  
  unlink(c(stdoutFile, stderrFile))
  return(retval)
}

shinyServer(function(input, output) {
  
  ## Invoke system command fetched from input$cmd and print the results
  output$console <- renderUI({
    input$runcmd
    if(is.na(input$runcmd)) return()
    if(input$runcmd == 0) return()
    
    isolate({
      # Get cmd
      cmd <- input$cmd
      
      # Separate command from args
      parts <- stringr::str_split(cmd, " ")[[1]]
      command <- parts[[1]]
      if (length(parts) > 1) {
        args <- paste(parts[2:length(parts)], collapse = " ")
      } else {
        args <- character()
      }
      
      # Invoke cmd ant store results
      #       log <- capture.output(
      #         out <- tryCatch(
      #           system2(command, args, stdout=TRUE, stderr=TRUE),
      #           message = function(m) {m},
      #           warning = function(w) {w},
      #           error = function(e) {e}
      #         )
      #       )
      
      # Return results as text
      #       text <- paste(out, collapse = "<br/>")
      
      #       HTML(text)
      
      out <- robust.system(cmd)
      out$stdout <- paste(out$stdout, collapse="<br/>")
      
      text <- paste(c("Exit status:", "Stdout:", "Stderr:"), out, sep = "<br/>", collapse = "<br/><br/>")
      tags$code(HTML(text))
    })
    
  })
  
})

