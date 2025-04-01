#' process_data 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
process_data <- function(stored_data) {

joined_data <- purrr::reduce(
  .x = stored_data,
  .f = ~ dplyr::inner_join(.x, .y, by = "date")
)


value_cols <- grep("value", names(joined_data), value = TRUE)


series_ids <- grep("series_id", names(joined_data), value = TRUE)


series_names <- unlist(lapply(series_ids, function(col) {
  unique(joined_data[[col]])[1]
}))
series_names <- make.names(series_names, unique = TRUE)


cleaned_data <- joined_data %>%
  dplyr::select(date, all_of(value_cols))


colnames(cleaned_data)[-1] <- series_names


standardized_data <- cleaned_data %>%
  dplyr::arrange(date) %>%
  dplyr::mutate(
    dplyr::across(-date, ~ as.numeric(scale(.x)))
  )

list(
  cleaned_data = cleaned_data,
  standardized_data = standardized_data
)
}