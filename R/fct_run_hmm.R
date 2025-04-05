#' run_hmm 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
run_hmm <- function(stored_data, n_states = 2, seed = 123) {
  processed <- process_data(stored_data)
  
  cleaned <- processed$cleaned_data
  standardized <- processed$standardized_data
  
  hmm_result <- fit_hmm(standardized, n_states = n_states, seed = seed)
  standardized <- hmm_result$data
  
  raw_data_with_state <- cleaned
  raw_data_with_state$state <- standardized$state
  
  summary_raw <- raw_data_with_state %>%
    dplyr::group_by(state) %>%
    dplyr::summarise(dplyr::across(where(is.numeric), mean, .names = "mean_{.col}"))
  
  summary_std <- standardized %>%
    dplyr::group_by(state) %>%
    dplyr::summarise(dplyr::across(where(is.numeric), mean, .names = "mean_{.col}"))
  
  graph_state_means <- summary_std %>% dplyr::select(-state)
  state_means_for_graph <- scale(graph_state_means) %>% as.data.frame()
  
  weights <- state_means_for_graph %>%
    dist() %>%
    cmdscale(k = 1) %>%
    scales::rescale(to = c(-1, 1))
  
  names(weights) <- summary_std$state
  
  
  standardized$index <- weights[as.character(standardized$state)]
  standardized$date <- cleaned$date
  
  list(
    summary_raw = summary_raw,
    summary_std = summary_std,
    plot_data = standardized
  )
}