#' Initialize parameters from incomplete data
#'
#' @param data A numeric matrix with NAs
#' @return A list with estimated `mu` and `Sigma`
#' @export
initialize_parameters <- function(data) {
  mu <- colMeans(data, na.rm = TRUE)
  Sigma <- cov(data, use = "pairwise.complete.obs")  # Can later switch to EM-based if needed
  return(list(mu = mu, Sigma = Sigma))
}
