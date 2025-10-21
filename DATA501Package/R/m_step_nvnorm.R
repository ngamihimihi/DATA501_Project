#' M-step for Multivariate Normal Model
#'
#' Performs the M-step of the EM algorithm for a multivariate normal distribution,
#' given a matrix with missing values imputed (i.e., the completed dataset).
#'
#' @param imputed_data A numeric matrix where missing values have been filled in,
#'   typically using conditional expectations from the E-step.
#'
#' @return A named list containing:
#' \describe{
#'   \item{mu}{A numeric vector of column means.}
#'   \item{sigma}{A numeric covariance matrix (assumed positive definite).}
#' }
#'
#' @details This function calls a C++ routine (\code{_DATA501Package_m_step_nvnorm})
#' to compute the MLEs for the multivariate normal parameters \eqn{(\mu, \Sigma)}.
#' It is designed to work with both outputs of \code{\link{e_step_nvnorm_em}} or
#' \code{\link{e_step_nvnorm_mc}} during the EM algorithm.
#'
#' @seealso \code{\link{e_step_nvnorm_em}}, \code{\link{e_step_nvnorm_mcem}}, \code{\link{em_engine}}, \code{\link{log_likelihood_nvnorm}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4), ncol = 2)
#' mu <- colMeans(data, na.rm = TRUE)
#' sigma <- diag(2)
#' params <- list(mu = mu, sigma = sigma)
#' imputed <- e_step_nvnorm(data, params)
#' m_step_nvnorm(imputed)
m_step_nvnorm <- function(imputed_data) {
  .Call(`_DATA501Package_m_step_nvnorm`, imputed_data)
}

