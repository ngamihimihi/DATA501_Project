#' Initialize Parameters for Poisson Model
#'
#' Estimates the rate parameters (\eqn{\lambda}) for each variable in a
#' Poisson-distributed dataset. This is intended for use with the EM algorithm
#' under the assumption that each variable follows an independent Poisson distribution.
#'
#' @param data A numeric matrix of count data (non-negative integers). Missing values (NAs)
#'   are allowed and are excluded from the calculation via \code{na.rm = TRUE}.
#'
#' @return A list containing:
#' \describe{
#'   \item{lambda}{A numeric vector of estimated Poisson means for each column.}
#' }
#'
#' @details This function computes the initial \eqn{\lambda_j} for each column
#' by taking the column-wise mean, ignoring missing values. These values serve as
#' starting parameters for the E-step and M-step of the Poisson EM algorithm.
#'
#' @seealso \code{\link{run_em_algorithm}}, \code{\link{em_model}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 2, 3, 4, 5), ncol = 2)
#' params <- initialize_parameters_poisson(data)
#' params$lambda
initialize_parameters_poisson <- function(data) {
  lambda <- colMeans(data, na.rm = TRUE)
  list(lambda = lambda)
}
