#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


path_htmlFiles <- 
  paste(path_project,"/Rmd-files/",sep="")



                         ####################
                         #### Define UI #####
################################################################################

shinyUI(navbarPage(
  title = "MEM-Explorer",
  #selected = "Missclassification",
  #selected = "Measurement Error",
  #selected = "Examples",
  #selected = "Overview",
  #selected = "Home",
  
  # 'Home'-Page ----------------------------------------------------------------
  tabPanel(
    title = "Home",
    
    # logo
    fluidRow(
      column(width = 8,
        includeMarkdown(
          paste0(path_htmlFiles, "home_logo.Rmd")
        )
      )
    ),
    
    column(width = 8, offset = 2,
      includeMarkdown(
        paste0(path_htmlFiles, "home.Rmd")
      )
    )
    
    
    # ,column(width = 6,
    #        includeHTML("C:/Users/judit/Documents/Studium/Statistik/7. Semester/Generalisierte Regressionsmodelle/Übung/Blatt 2/Blatt2_solution.html")
    # )
  ),
  
  # 'Overview'-Page ------------------------------------------------------------
  tabPanel(
    "Overview",
    
    # Page-title
    titlePanel("Measurement Error and Missclassification theory"), 
    
    em(paste(
      "This page serves as an overview about the fundamentals of MEM theory",
      "and is mainly based on the Guidance Document developed by STRATOS-Initive."
      ) 
    ), br(), br(),
    
    # Page-content
    tabsetPanel(
      selected = "Introduction",
      #selected = "Error Models",
      #selected = "Effect on Outcome Model",
      
      # introduction ----
      tabPanel(
        title = "Introduction", br(),

        # sidebar panel
        fluidRow(
          column(width = 4,
            wellPanel(
              includeMarkdown(
                paste0(path_htmlFiles, "overview-introduction_basics.Rmd")
              )
            )
            
        ),
        
        # main panel with 2 columns
          # error structure
          column(width = 4,
                 h3("Error Structure"),
                 
                 navlistPanel(widths = c(7, 12), well = FALSE,
                              tabPanel(
                                title = "(a) stochastic vs. systematic",
                                
                                column(width = 12,
                                       br(),
                                       
                                       h4("Stochastic vs. Systematic Error"),
                                       
                                       paste(
                                         "Measurement Errors could be random (stochastic) or systematic errors.", 
                                         "See the following graphic to compare random error (left)", 
                                         "and systematic error with linear structure (right)."
                                       ),
                                       br(), br(),
                                       
                                       plotOutput("structur_systematic", 
                                                  width = "100%", height = "350px")
                                )
                              ),
                              
                              tabPanel(
                                title = "(b) additive vs. multiplicative",
                                
                                column(width = 12,
                                       br(),
                                       
                                       h4("Additive vs. Multiplicative Error"),
                                       
                                       paste(
                                         "The structure of errors could be multiplicative or additive."
                                       ),
                                       br(), br()
                                )
                              ),
                              
                              tabPanel(
                                title = "(c) differential vs. non-differential",
                                
                                column(width = 12,
                                       br(),
                                       
                                       h4("Differential vs. Non-differential Error"),
                                       
                                       paste(
                                         ""
                                       ),
                                       br(), br()
                                )
                              )
                 )
                 
                 # includeHTML(
                 #   paste0(path_htmlFiles, "overview-introduction_structure.html")
                 # )
          ),

          # impact on regression
          column(width = 4,
                 
           includeMarkdown(
             paste0(path_htmlFiles, "overview-introduction_impact.Rmd")
           ), br(),
           
           column(width = 6, offset = 3,
             sliderInput(inputId = "var_error", label = "Error variance Var(U)",
                         min = 0, max = 1, value = 0, step = 0.01)
           ),
           
           plotOutput("maskingEffect_plot")
          )
          #
        )

      ),
      
      # Error Models ---------
      tabPanel(
        title = "Error Models", br(),
        
        
        # sidebar
        column(width = 3,
               wellPanel(
                 includeMarkdown(
                   paste0(path_htmlFiles, "overview-errorModels.Rmd")
                 ) ,
                 br(), br(), br(), br(), br(), br(), br(), br(), br(), 
                 br(), br(), br(), br(), br(), br(), br(), br(), br()
               )
        ),
        
        # main panel
        column(width = 9, 
               
               h3("Error Models"),
               br(),
               
               navlistPanel(widths = c(3, 12), well = FALSE,
                            
                  tabPanel(
                    title = "(a) continuous covariates", 
                    #h3("Effects of Measurement Errors"),
                    
                    column(width = 12,
                           includeMarkdown(
                             paste0(path_htmlFiles, "overview-errorModels_ME.Rmd")
                           ))
                    
                    #img(src = "effectTable_ME.png")
                  ),
                  
                  tabPanel(
                    title = "(b) categorical covariates", 
                    #h3("Effects of Misclassification"),
                    
                    column(width = 12,
                      includeMarkdown(
                        paste0(path_htmlFiles, "overview-errorModels_M.Rmd")
                      )
                    )
                    
                    #img(src = "effectTable_M.png")
                  )
               )
        )


      ),
      
      # Impact on outcome models ---------
      tabPanel(
        title = "Impact on Outcome Model", br(),
        
        # sidebar panel
        column(width = 3,
               wellPanel(
                 includeMarkdown(
                   paste0(path_htmlFiles, "overview-effect.Rmd")
                 ) 
               )
        ),
        
        # main panel
        column(width = 9, 
               
          h3("Impact on Outcome Model"),
          br(),
               
          navlistPanel(widths = c(3, 12), well = FALSE,
                       
            tabPanel(
              title = "(a) measurement error", 
              #br(),
              
              column(width = 12,
                h4("Impacts of Measurement Errors on Linear Regression"),
                includeMarkdown(
                  paste0(path_htmlFiles, "overview-effect_ME.Rmd")
                )
                
                # "Assume X, X* are continuous covariates and U ~ N(0, var(U)).",
                # 
                # img(src = "effectTable_ME.png")
              )
            ),
            
            tabPanel(
              title = "(b) misclassification", 
              #br(),
              
              column(width = 12,
                h4("Impacts of Misclassification on Linear Regression"),
                includeMarkdown(
                  paste0(path_htmlFiles, "overview-effect_M.Rmd")
                ),
                img(src = "effectTable_M.png")
              )
            )
          )
        )
        
        # tabsetPanel(
        #   tabPanel(
        #     title = "Measurement Error"
        #   ),
        #   
        #   tabPanel(
        #     title = "Missclassification"
        #   )
        # )
      )
    )
  ),
  
  
  
  
  
  
  # 'Simulation'-Menu ==========================================================
  navbarMenu(
    title = "Simulation",
    
    tabPanel(
      title = "Measurement Error",
      #simulationUI("simulation")
      outputPanelUI("outputME")
    ),
    
    # horizontal line ----
    "----",
    
    tabPanel(
      title = "Missclassification",
      #simulationUI("simulation", categorical = TRUE)
      outputPanelUI("outputM", categorical = TRUE)
    )
             
    
  ), # navbarMenu 'Simulation'
  
  # 'Examples'-Page ------------------------------------------------------------
  tabPanel(
    title = "Examples", 
    
    dataUploadUi("upload")
    
    # # Page-title
    # titlePanel("Explore MEM-Effects based on Example Data"),
    # 
    # # Page-content
    # tabsetPanel(
    #   
    #   tabPanel(
    #     title = "Data Upload",
    #     dataUploadUi("upload")
    #   ),
    #   
    #   tabPanel(
    #     title = "Error Distribution"
    #   ),
    #   
    #   tabPanel(
    #     title = "Effect on Regression"
    #   )
    # )
    
    
  ),
  
  # 'Help'-Page ----------------------------------------------------------------
  tabPanel(
    title = "Help"
  )
  
)) # shinyUi/navbarPage


