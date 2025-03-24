#' seriesid UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_seriesid_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::textInput(
      inputId = ns("series_id_input"),
      label = "Enter a FRED series ID:",
      width = "33%"
    ),
    shiny::actionButton(
      inputId = ns("go_button"),
      label = "Go",
      style = "height: 38px;"
    )
  )
}
    
#' seriesid Server Functions
#'
#' @noRd 
mod_seriesid_server <- function(id, r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    r$series_id <- NULL
    
    observeEvent(input$go_button, {
      if (nzchar(input$series_id_input)) {
        r$series_id <- input$series_id_input
      }
    })
  })
}
    
## To be copied in the UI
# mod_seriesid_ui("seriesid_1")
    
## To be copied in the server
# mod_seriesid_server("seriesid_1")
