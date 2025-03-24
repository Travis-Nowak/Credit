#' fred_pull 
#'
#' @description A function which pulls FRED data using the API key input and returns a cleaned dataframe
#'
#' @param user_key The user's API key
#' 
#' @param series_id The FRED data to be pulled
#' 
#' @return The return value, if any, from executing the function.
#' 
#' @noRd
fred_pull <- function(r) {
  # set key
  fredr::fredr_set_key(r$user_key)
  
  
  # assign data
  data <- fredr::fredr(
    series_id = r$series_id, # Why does this not work when not calling as a function? I.e.) why doesn't r$series_id work but r$series_id() does?
    observation_start = as.Date("1900-01-01")
  )
  # clean data
  data <- data %>%
    tidyr::drop_na()
  
  p <- data %>% ggplot(aes(x = date, y = value)) +
    geom_line()
  
  plotly::ggplotly(p)
  
}
