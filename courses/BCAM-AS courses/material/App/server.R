#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#








                        ###############################
                        ##### Define server logic #####
################################################################################


shinyServer(function(input, output) {
  
  # modules ====================================================================
  upload <- callModule(dataUpload, "upload")
  outputME  <- callModule(outputPanel, "outputME")
  outputM  <- callModule(outputPanel, "outputM", categorical = TRUE)
  
  # theory page ================================================================
  output$maskingEffect_plot <- renderPlot({
    create_maskingEffecPlot(200, var_error = input$var_error)
  })
  
  output$structur_systematic <- renderPlot({
    create_stochVSsysPlot(50)
  })
  
  output$structur_multiplicative <- renderPlot({
    create_stochVSsysPlot(50)
  })
  
  # determine limits for plots =================================================
  get_limits <- reactive({
    data <- simulate_data()
    
    # get extrema
    max <- round(x = max(
      max(data$x), max(data$x_classical), 
      max(data$x_linear), max(data$x_berkson)
    )) + 0.5
    
    min <- round(x = min(
      min(data$x), min(data$x_classical), 
      min(data$x_linear), min(data$x_berkson)
    )) - 0.5
    
    # save as vector for graphical parameter value
    lim <- c(min, max)
    
    return(lim)
  })

  # ÜBERARBEITEN (Inforows) =============================================================== 
  # define infoFormulas about basic model 
  output$model <- renderUI({
    withMathJax(
      sprintf(
        "\\( Y = %.01f + %.01f X + \\epsilon \\)",
        input$beta_0, input$beta_x
      )
    )
  })
  
  output$residual <- renderUI({
    fluidRow(br(), 
             withMathJax(
               sprintf(
                 "$$ \\epsilon \\sim \\ N(0, %.01f)  $$",
                 input$var_residual
               )
             ))
    
  })
  
  output$covariate <- renderUI({
    withMathJax(
      sprintf(
        "\\( X \\sim N(%.01f, %.01f) \\)", 
        input$mean_x, input$var_x
      )
    )
  })
  

  
  # define infoRow about error model 
  output$infoRow <- renderUI({
    checked_boxes <- input$show_error
    column_width <- 12 / length(checked_boxes)
    columns <- list()
    
    if (any(checked_boxes == "1")) {
      columns$column1 <- column(
        width = column_width,
        h3("Classical Error"),
        withMathJax(helpText("\\( X^* = X + U\\)"))
      )
    }
    
    if (any(checked_boxes == "2")) {
      columns$column2 <- column(
        width = column_width,
        withMathJax(),
        h3("Linear Error"),
        withMathJax(helpText("\\( X^* = \\alpha_0 + \\alpha_X X + U\\)"))
      )
    }
    
    if (any(checked_boxes == "3")) {
      columns$column3 <- column(
        width = column_width,
        h3("Berkson Error"),
        withMathJax(helpText("\\( X = X^* + U\\)"))
      )
    }
    
    fluidRow(columns)
  })
  
  
  
  
  
  
  
  
  
})
