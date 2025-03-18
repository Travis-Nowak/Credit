#' module_3 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_module_3_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' module_3 Server Functions
#'
#' @noRd 
mod_module_3_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_module_3_ui("module_3_1")
    
## To be copied in the server
# mod_module_3_server("module_3_1")
