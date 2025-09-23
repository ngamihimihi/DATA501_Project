#' General E-step Imputation
#'
#' Performs the E-step of the EM algorithm by imputing missing entries in a
#' numeric matrix using conditional expectations under the multivariate normal model.
#'
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
#' Sigma <- diag(2)
#' e_step_nvnorm(data,params)
e_step_nvnorm <-  function(data, params) {
  mu <- params$mu
  Sigma <- params$sigma
  .Call(`_DATA501Package_e_step_nvnorm`, data, mu,Sigma)
}
