library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Modeling distribution of positive droplets in ddPCR"),
  sidebarPanel(
    tabsetPanel(
      tabPanel("CPD Plot", 
        sliderInput('CPD', 'Slide to change Copies per Droplet',value = 0.25, min = 0, max = 10, step = 0.005),
        sliderInput('droplets', 'Slide to change the number of droplets analyzed',value = 20000, min = 50, max = 50000, step = 50),
        actionButton("goButton", "Calculate")
      ), #end tabPanel 1
      tabPanel("Poisson Error Plot",
        sliderInput('concentration', 'Slide to enter the expected concentration of your sample in a 20 microlitre volume',value = 5000, min = 0, max = 100000, step = 10)
        )#end tabPanel 2
    )#end tabsetPanel
  ),#end sidebarPanel
  
  mainPanel(
    tabsetPanel(
      tabPanel("CPD Plot",
        p('The following mean value of lambda was chosen (CPD):'),
        textOutput('CPD'),
        p('Total number of QC passed droplets:'),
        textOutput('droplets'),
        p('Fraction of Empty Droplets is:'),
        textOutput('Pr_0'),
        p('Plot of droplet distribution'),
        plotOutput('cpd_plot'),
        p('Table of density plot'),
        dataTableOutput('table')
      ), #end tabPanel
      tabPanel("Poisson Error Plot",
        p('You entered the following expected concentration of the test sample:'),
        textOutput('concentration'),
        p('CPD based on the expected concentration of your sample that you entered is:'),
        textOutput('calc_CPD'),
        p('Plot of Poisson Errors'),
        plotOutput('error_plot')
      ) #end tabPanel
    )#end tabsetPanel
  ) #end mainPanel
))#end sidebar and shiny panel