#' Standard E-step Imputation
#'
#' Performs the E-step of the EM algorithm by imputing missing entries in a
#' numeric matrix using conditional expectations under the multivariate normal model.
#'In this draft package: only multivariate normal distribution is ready for testing (method = 'nvnorm')
#' @param data A numeric matrix with missing values (NAs).
#' @param mu A numeric vector representing the mean of the distribution.
#' @param Sigma A numeric covariance matrix (must be positive definite).
#'
#' @return A numeric matrix of the same dimensions as \code{data}, with missing
#'   values imputed using the conditional expectation given observed values.
#'
#' @details This function is typically called internally by the EM loop
#'   (\code{\link{run_em_algorithm}}), but it can be used standalone for testing.
#'
#' @seealso \code{\link{run_em_algorithm}}, \code{\link{log_likelihood_mvnorm}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4), ncol = 2)
#' mu <- colMeans(data, na.rm = TRUE)
#' sigma <- diag(2)
#' params <- list(mu = mu, sigma = sigma)
#' e_step_nvnorm_em(data, params)
e_step_nvnorm_em <- function(data, params) {
  mu <- params$mu
  Sigma <- params$sigma
  .Call(`_DATA501Package_e_step_nvnorm_em`, data, mu, Sigma)
}
