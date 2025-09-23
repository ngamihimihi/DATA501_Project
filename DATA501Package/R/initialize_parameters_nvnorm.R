#' Log-Likelihood of Multivariate Normal Distribution
#'
#' Computes the total log-likelihood of a fully observed numeric dataset under
#' a multivariate normal (MVN) distribution with specified mean vector and covariance matrix.
#'
#' @param data A numeric matrix with no missing values. Each row is an observation.
#' @param mu A numeric vector of means (same length as the number of columns in \code{data}).
#' @param Sigma A numeric covariance matrix (must be square and match dimensions of \code{mu} and \code{data}).
#'
#' @return A single numeric value: the total log-likelihood of the data under the MVN model.
#'
#' @details This function is typically called within the EM algorithm after missing values
#' have been imputed. It assumes that the covariance matrix is positive definite.
#'
#' @seealso \code{\link{run_em_algorithm}}, \code{\link{e_step_general_impute}}, \code{\link[stats]{mvtnorm}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1.2, 2.3, 2.0, 3.1, 1.8, 2.8), ncol = 2, byrow = TRUE)
#' mu <- colMeans(data)
#' Sigma <- cov(data)
#' initialize_parameters_nvnorm(data, mu, Sigma)
initialize_parameters_nvnorm <- function(data) {
  mu <- colMeans(data, na.rm = TRUE)
  sigma <- cov(data, use = "pairwise.complete.obs")

  # Enforce symmetry
  sigma <- 0.5 * (sigma + t(sigma))

  # Check eigenvalues
  eig_vals <- eigen(sigma, symmetric = TRUE)$values
  min_eig <- min(eig_vals)

  if (min_eig < 1e-6) {
    jitter <- abs(min_eig) + 1e-4
    message("⚠ sigma not PD, applying jitter of ", jitter)
    sigma <- sigma + diag(jitter, ncol(sigma))
  }

  # Final check
  final_vals <- eigen(sigma, symmetric = TRUE)$values
  if (any(final_vals <= 0)) {
    stop("Even after jittering, sigma is not positive definite.")
  }

  list(mu = mu, sigma = sigma)
}
