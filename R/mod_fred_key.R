#' FRED_key UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_fred_key_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::div(
      style = "display: flex; align-items: center;",
      shiny::passwordInput(
        inputId = ns("fred_key_input"),
        label = "Enter your FRED API key:",
        width = "33%" 
      ),
      shiny::actionButton(
        inputId = ns("set_key"),
        label = "Set Key",
        style = "margin-left: 10px; height: 38px;"
      )
    ),
    shiny::br(),
    shiny::textOutput(ns("feedback"))
  )
}

    
#' FRED_key Server Functions
#'
#' @noRd 
mod_fred_key_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    
    new_key <- NULL
    
    observeEvent(input$set_key, {
      new_key <- input$fred_key_input
      if (nzchar(new_key)) {
        fredr::fredr_set_key(new_key)
        output$feedback <- shiny::renderText("API Key set for this session.")
      } else {
        output$feedback <- shiny::renderText("No key entered.")
      }
      r$user_key <- new_key
    })
  })
}
