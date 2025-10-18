log_likelihood_poisson <- function(data, params) {
  lambda <- params$lambda
  .Call(`_DATA501Package_log_likelihood_poisson`, data, lambda)
}
