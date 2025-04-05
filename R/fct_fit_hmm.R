#' fit_hmm 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
fit_hmm <- function(data, n_states, seed = 123) {

  formula_list <- names(data)[-1] %>%
    purrr::map(~ as.formula(paste(.x, "~ 1")))
  

  model <- depmixS4::depmix(
    response = formula_list,
    data = data,
    nstates = n_states,
    family = rep(list(gaussian()), length(formula_list))
  )
  
  set.seed(seed)
  fit_model <- depmixS4::fit(model, verbose = FALSE)
 
  post <- depmixS4::posterior(fit_model, type = "viterbi")

  data$state <- as.factor(post$state)

  list(
    fit_model = fit_model,
    data = data
  )
}