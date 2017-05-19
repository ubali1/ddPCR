shinyServer(
  function(input, output) {
    
    # outputting user defined parameters
    output$CPD <- renderText({input$CPD})
    output$droplets <- renderText({input$droplets})
    output$concentration <- renderText({input$concentration})
        
    # outputting fraction of empty droplets given user defined CPD
      output$Pr_0 <- renderText({
      calc <- round(exp(-input$CPD)*100, 2)
    }) #end of Pr_0 function
    #input$goButton
             
    #preparing reactive plot for outputting plot of Ki/IC50 vs Ligand/EC50
      output$cpd_plot <- renderPlot({
      library(ggplot2)
      freq <- seq(from = 0, to = 20, by = 1)
      count_pct <- round(((exp(-input$CPD)*input$CPD^freq)/factorial(freq)),4)
      count <- round(count_pct*input$droplets,4)
      mu <- input$CPD
      qplot(freq, count, geom = "smooth", xlab='Number of Target Molecules', ylab = 'Droplet Count', color='red',main='Plot of droplet distribution') + geom_vline(xintercept = mu, col = "dodgerblue3", lty="dotdash") + geom_text(aes(x=mu+0.05, label="CPD value", y=0.65), colour="blue", angle=90, text=element_text(size=11))
    })
    
    # creating a reactive data table
    output$table <- renderDataTable({
      freq <- seq(from = 0, to = 20, by = 1)
      count_pct <- round(((exp(-input$CPD)*input$CPD^freq)/factorial(freq)),4)
      count <- round(count_pct*input$droplets,4)
      df <- data.frame("Target molecules per droplet" = freq, "Percent total droplets" = count_pct, "Droplet counts" = count)},
                                    options = list(
                                      pageLength = 10,
                                      initComplete = I("function(settings, json) {alert('Done.');}"))) # end of table function      
    
    # outputting CPD based on expected concentration provided
    output$calc_CPD <- renderText({
      conc <- (input$concentration/20*0.001)
    }) #end of calc_CPD function
    
    #preparing reactive plot for outputting poisson error
    output$error_plot <- renderPlot({
      library(ggplot2)
      cpd <- seq(from = 0.05, to = 6, by = 0.05)
      cv <- sqrt(cpd)/cpd     
      conc <- (input$concentration/20*0.001)
      qplot(cpd, cv, geom = "smooth", xlab='CPD', ylab = 'Percent CV', color='red',main='ddPCR subsampling error') + geom_vline(xintercept = conc, col = "dodgerblue3", lty="dotdash") + geom_text(aes(x=conc+0.05, label="CPD value", y=0.65), colour="blue", angle=90, text=element_text(size=11))
    }) #end of error_plot function
    
  } #end of input output function
) #end of shinyServer