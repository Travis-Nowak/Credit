#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd

app_server <- function(input, output, session) {
  fred_key_rv <- mod_fred_key_server("fred_key_module")
  user_series_r <- mod_seriesid_server("seriesid_module")
  mod_plot_data_server(
    id = "plot_module",
    user_key = fred_key_rv,
    user_series = user_series_r
  )
  
  stored_data_r <- mod_data_storage_server(
    id = "store_data_module",
    user_key = fred_key_rv,
    user_series = user_series_r
  )
  
  mod_list_data_server(
    id = "list_data_module",
    stored_data = stored_data_r
  )
  
  mod_random_server("my_random_module")
}
