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
mod_data_storage_server <- function(id, user_key, user_series){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    stored_data <- reactiveVal(list())
    
    observeEvent(input$store_data, {
      req(user_key(), user_series())
      
      fredr::fredr_set_key(user_key())
      
      new_data <- fredr::fredr(
      series_id = user_series(),
      observation_start = as.Date("1900-01-01")
    ) %>% 
      tidyr::drop_na()
      
    current_list <- stored_data()
    
    current_list[[user_series()]] <- new_data
    
    stored_data(current_list)
    
    output$store_feedback <- shiny::renderText({
      paste0("Data from series ", user_series(), " has been stored.")
    })
    })
    
    return(stored_data)
 
  })
}
    
## To be copied in the UI
# mod_data_storage_ui("data_storage_1")
    
## To be copied in the server
# mod_data_storage_server("data_storage_1")
