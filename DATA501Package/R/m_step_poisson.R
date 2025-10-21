#' M-step for Poisson Model
#'
#' Performs the M-step of the EM algorithm for a poisson distribution,
#' given a matrix with missing values imputed (i.e., the completed dataset).
#'
#' @param imputed_data A numeric matrix where missing values have been filled in,
#'   typically using conditional expectations from the E-step.
#'
#' @return A named list containing:
#' \describe{
#'   \item{lambda}{A numeric vector of araveage rate of events}
#' }
#'
#' @details This function calls a C++ routine (\code{_DATA501Package_m_step_poisson})
#' to compute the MLEs for the poisson parameters \eqn{(\lambda)}.
#' It is designed to work with both outputs of \code{\link{e_step_poisson_em}}.
#'
#' @seealso \code{\link{e_step_poisson_em}}, \code{\link{em_engine}}, \code{\link{log_likelihood_poisson}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4), ncol = 2)
#' lambda <- colMeans(data, na.rm = TRUE)
#' params <- list(lambda = lambda)
#' imputed <- e_step_poisson(data, params)
#' m_step_poisson(imputed)
m_step_poisson <- function(imputed_data, round_lambda = FALSE) {
  .Call(`_DATA501Package_m_step_poisson`, imputed_data, round_lambda)
}

