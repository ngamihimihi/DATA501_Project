
#' Standard E-step Imputation
#'
#' Performs the E-step of the EM algorithm by imputing missing entries in a
#' numeric matrix using conditional expectations under the poisson distribution model.
#' @param data A numeric matrix with missing values (NAs).
#' @param lambda A numeric vector representing the mean of the distribution.
#' Standard E-step Imputation (Poisson)
#'
#' Performs the E-step of the EM algorithm by imputing missing entries in a
#' numeric matrix using conditional expectations under the poisson model.
#' @param data A numeric matrix with missing values (NAs).
#' @param lambda A numeric vector representing the lambda of the distribution.
#'
#' @return A numeric matrix of the same dimensions as \code{data}, with missing
#'   values imputed using the conditional expectation given observed values.
#'
#' @details This function is typically called internally by the EM loop
#'   (\code{\link{run_em_algorithm}}), but it can be used standalone for testing.
#'
#' @seealso \code{\link{run_em_algorithm}}, \code{\link{log_likelihood_poisson}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4), ncol = 2)
#' lambda <- colMeans(data, na.rm = TRUE)
#' params <- list(lambda = lambda)
#' e_step_poisson_em(data, params)
e_step_poisson_em <- function(data, params) {
  lambda <- params$lambda
  .Call(`_DATA501Package_e_step_poisson_em`, data, lambda)
}
