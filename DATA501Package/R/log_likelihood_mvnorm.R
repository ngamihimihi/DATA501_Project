#' Log-Likelihood of Multivariate Normal Distribution
#'
#' Computes the total log-likelihood of a complete dataset under a multivariate normal distribution.
#'
#' @param data A numeric matrix with no missing values (imputed data).
#' @param mu A numeric vector, the mean vector.
#' @param Sigma A numeric matrix, the covariance matrix.
#'
#' @return A single numeric value: the log-likelihood.
#' @export
log_likelihood_mvnorm <- function(data, mu, Sigma) {
  .Call(`_DATA501Package_log_likelihood_mvnorm`, data, mu, Sigma)
}
