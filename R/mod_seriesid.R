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
      label = "Enter FRED series:",
      width = "33%"
    ),
    shiny::actionButton(
      inputId = ns("go_button"),
      label = "Visualize & Store",
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
    
    observeEvent(input$go_button, {
      req(nzchar(input$series_id_input), r$user_key)
      
      # Set series ID reactively
      r$series_id <- input$series_id_input
      
      # Pull and clean data from FRED
      fredr::fredr_set_key(r$user_key)
      
      new_data <- fredr::fredr(
        series_id = r$series_id,
        observation_start = as.Date("1900-01-01")
      ) %>%
        tidyr::drop_na() %>%
        dplyr::rename(!!paste0("value_", r$series_id) := value) %>%
        dplyr::mutate(!!paste0("series_id_", r$series_id) := r$series_id)
      
      # Append to stored data
      if (is.null(r$stored_data)) r$stored_data <- list()
      current_list <- list(new_data)
      names(current_list) <- r$series_id
      r$stored_data <- append(r$stored_data, current_list)
      
      # Optional feedback
      output$store_feedback <- renderText({
        paste0("Data from series ", r$series_id, " has been stored.")
      })
    })
  })
}
    
## To be copied in the UI
# mod_seriesid_ui("seriesid_1")
    
## To be copied in the server
# mod_seriesid_server("seriesid_1")
