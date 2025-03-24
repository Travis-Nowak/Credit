#' hmm UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_hmm_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::h3("Hidden Markov Model Analysis"),
    shiny::p("Select one of your stored data series and specify the number of states for the HMM."),
    shiny::selectInput(
      inputId = ns("data_select"),
      label = "Select Data Series:",
      choices = NULL
    ),
    shiny::numericInput(
      inputId = ns("num_states"),
      label = "Number of States:",
      value = 2,
      min = 2,
      step = 1
    ),
    shiny::actionButton(
      inputId = ns("fit_hmm"),
      label = "Fit HMM"
    ),
    shiny::br(), shiny::br(),
    shiny::verbatimTextOutput(ns("hmm_summary")),
    shiny::plotOutput(ns("state_plot"))
  )
}
    
#' hmm Server Functions
#'
#' @noRd 
mod_hmm_server <- function(id, r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    observe({
      if (!is.null(r$stored_data) && length(r$stored_data) > 0) {
        shiny::updateSelectInput(session, "data_select", choices = names(r$stored_data))
      }
    })
 
  })
}
    
## To be copied in the UI
# mod_hmm_ui("hmm_1")
    
## To be copied in the server
# mod_hmm_server("hmm_1")
