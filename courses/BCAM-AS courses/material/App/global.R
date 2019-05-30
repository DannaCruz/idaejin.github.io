
# load required packages
library(shiny)
library(tidyr)
library(tidyselect)
library(tibble)
library(ggplot2)
library(plotly)
library(broom)
library(dplyr)
library(magrittr)
library(purrr)
library(dotwhisker)
library(ggiraphExtra)
#library(gridExtra)


path_project <- paste0(getwd(),"/MEM-Explorer")
path_textFiles <- paste0(path_project, "/Rmd-files")


# helping functions
source(paste0(path_project, "/Helping-Functions/create_maskingEffectPlot.R"))
source(paste0(path_project, "/Helping-Functions/create_stochVSsysPlot.R"))
source(paste0(path_project, "/Helping-Functions/plot-functions.R"))
source(paste0(path_project, "/Helping-Functions/summary-functions.R"))

# simulation source code
source(paste0(path_project, "/Simulation", "/simulationOutput-module.R"))
source(paste0(path_project, "/Simulation", "/simulation-module.R"))
source(paste0(path_project, "/Simulation", "/simulationSidebar-module.R"))
source(paste0(path_project, "/Simulation/simulate_covars.R"))
source(paste0(path_project, "/Simulation/simulate_errors.R"))
source(paste0(path_project, "/Simulation/simulate_data.R"))

# modules source-code
source(paste0(path_project, "/Modules", "/simulationInput-module.R"))
source(paste0(path_project, "/Modules", "/errorOutput-module.R"))
source(paste0(path_project, "/Modules", "/effectOutput-module.R"))

# example-module source code
source(paste0(path_project, "/Example", "/upload-module.R"))

