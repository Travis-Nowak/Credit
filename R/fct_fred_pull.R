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
fred_pull <- function(user_key, series_id) {
  # set key
  fredr::fredr_set_key(user_key)
  # assign data
  data <- fredr::fredr(
    series_id = series_id,
    observation_start = as.Date("1900-01-01")
  )
  # clean data
  data <- data %>%
    tidyr::drop_na()
  
  p <- data %>% ggplot(aes(x = date, y = value)) +
    geom_line()
  
  plotly::ggplotly(p)
  
}
