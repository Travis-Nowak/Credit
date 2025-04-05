#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd

app_server <- function(input, output, session) {
  
  r <- reactiveValues()
  
  
  
  mod_fred_key_server("fred_key_module", r) # done
  user_series_r <- mod_seriesid_server("seriesid_module", r) # done
  mod_plot_data_server( # done
    id = "plot_module",
    r
  )
  
  mod_list_data_server(
    id = "list_data_module",
    r
  )
  
  mod_hmm_server(
    id = "my_model",
    r
  )
  
  mod_example_case_server(id = "example_case_1",
                          r)
}
