#' plot_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_plot_data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotly::plotlyOutput(ns("fred_plot"))
  )
}
    
#' plot_data Server Functions
#'
#' @noRd 
mod_plot_data_server <- function(id, r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    output$fred_plot <- plotly::renderPlotly({
      req(!is.null(r$series_id))
      fred_pull(r = r)
    })
  })
}
    
## To be copied in the UI
# mod_plot_data_ui("plot_data_1")
    
## To be copied in the server
# mod_plot_data_server("plot_data_1")
