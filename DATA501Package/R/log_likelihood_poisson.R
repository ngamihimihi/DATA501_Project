#' Log-Likelihood for Poisson Model
#'
#' Computes the observed-data log-likelihood under a Poisson model,
#' given the current parameter estimates (\eqn{\lambda}).
#'
#' @param data A numeric matrix with missing values (NAs). Missing values are assumed
#'   to follow a Missing At Random (MAR) mechanism. The computation is handled
#'   in C++ using only observed entries per row.
#' @param params A list containing:
#'   \describe{
#'     \item{lambda}{A numeric vector of average rate of events.}
#'   }
#'
#' @return A numeric scalar: the total log-likelihood across all rows.
#'
#' @details
#' This function delegates computation to the underlying C++ routine
#' \code{_DATA501Package_log_likelihood_poisson}, implemented via the Rcpp interface.
#'
#' @seealso
#'  \code{\link{em_engine}},
#'  \code{\link{initialize_parameters_poisson}}
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4), ncol = 2)
#' params <- list(lambda = c(2, 3))
#' log_likelihood_poisson(data, params)
#'
#' @export
log_likelihood_poisson <- function(data, params) {
  lambda <- params$lambda
  .Call(`_DATA501Package_log_likelihood_poisson`, data,lambda)
}
