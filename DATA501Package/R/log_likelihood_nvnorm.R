#' Log-Likelihood for Multivariate Normal Model
#'
#' Computes the observed-data log-likelihood under a multivariate normal model,
#' given the current parameter estimates (mean vector and covariance matrix).
#'
#' @param data A numeric matrix with missing values (NAs). Missing values are assumed
#'   to follow a Missing At Random (MAR) mechanism. The computation is handled
#'   in C++ using only observed entries per row.
#' @param params A list containing:
#'   \describe{
#'     \item{mu}{A numeric vector of means.}
#'     \item{sigma}{A positive definite covariance matrix.}
#'   }
#'
#' @return A numeric scalar: the total log-likelihood across all rows (using only observed entries).
#'
#' @details This function delegates to a C++ routine (\code{_DATA501Package_log_likelihood_nvnorm})
#' that efficiently handles missing data by computing the conditional log-density for each row,
#' based on its observed components.
#'
#' @seealso \code{\link{em_engine}}, \code{\link{initialize_parameters_nvnorm}}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4), ncol = 2)
#' params <- list(mu = c(2, 3), sigma = diag(2))
#' log_likelihood_nvnorm(data, params)
log_likelihood_nvnorm <- function(data, params) {
  mu <- params$mu
  Sigma <- params$sigma
  .Call(`_DATA501Package_log_likelihood_nvnorm`, data, mu, Sigma)
}
