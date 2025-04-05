#' data_list 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
data_list <- function(stored_data, ns) {
  if (length(stored_data) == 0) {
    return(shiny::tags$p("No data series stored yet."))
  }
  
  shiny::tagList(
    lapply(names(stored_data), function(series_name) {
      df <- stored_data[[series_name]]
      n_obs <- nrow(df)
      
      shiny::div(
        style = "margin-bottom: 10px;",
        shiny::span(shiny::tags$strong(series_name),
                    paste0(" (", n_obs, " observations)")),

        shiny::actionButton(inputId = ns(paste0("delete_", series_name)),
                            label = "Delete",
                            class = "btn-danger",
                            style = "margin-left: 20px;")
      )
    })
  )
}