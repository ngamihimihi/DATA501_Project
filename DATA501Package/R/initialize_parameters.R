#' Dispatcher to initialize parameters based on distribution
#'
#' @param data Matrix with missing values
#' @param dist Character string: "mvnorm", "poisson", "mixture", etc.
#' @return A list of initial parameters (depends on distribution)
initialize_parameters <- function(data, dist) {
  init_fn <- get(paste0("initialize_parameters_", dist))
  init_fn(data)
}
