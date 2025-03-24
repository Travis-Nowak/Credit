#' list_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_list_data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("data_list"))
 
  )
}
    
#' list_data Server Functions
#'
#' @noRd 
mod_list_data_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    output$data_list <- renderUI({
      create_data_list_ui(r$stored_data, ns)
    })

    observe({

      current_series <- names(r$stored_data)
      
      lapply(current_series, function(series_name) {
        delete_button_id <- paste0("delete_", series_name)
        
        local({
          current_name <- series_name
          button_id <- delete_button_id
          
          observeEvent(input[[button_id]], {
            current_list <- r$stored_data
            current_list[[current_name]] <- NULL
            r$stored_data <- current_list

          }, ignoreInit = TRUE)
        })
      })
    })
  })
}
    
## To be copied in the UI
# mod_list_data_ui("list_data_1")
    
## To be copied in the server
# mod_list_data_server("list_data_1")
