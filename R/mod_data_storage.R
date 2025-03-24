#' data_storage UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_storage_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::actionButton(ns("store_data"), "Store Data"),
    shiny::br(),
    shiny::textOutput(ns("store_feedback"))
 
  )
}
    
#' data_storage Server Functions
#'
#' @noRd 
mod_data_storage_server <- function(id, r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    r$stored_data <- list()
    
    observeEvent(input$store_data, {
      req(r$user_key, r$series_id)
      
      fredr::fredr_set_key(r$user_key)
      
      new_data <- fredr::fredr(
      series_id = r$series_id,
      observation_start = as.Date("1900-01-01")
    ) %>% 
      tidyr::drop_na()
    current_list <- list(new_data)
    names(current_list) <- r$series_id
    r$stored_data <- append(r$stored_data, current_list)
    
    output$store_feedback <- shiny::renderText({
      paste0("Data from series ", r$series_id, " has been stored.")
    })
    })
  })
}
    
## To be copied in the UI
# mod_data_storage_ui("data_storage_1")
    
## To be copied in the server
# mod_data_storage_server("data_storage_1")
