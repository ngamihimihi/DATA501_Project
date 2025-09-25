#' Initialize Parameters for Multivariate Normal Model
#'
#' Estimates initial mean and covariance parameters for a multivariate normal
#' distribution, handling missing data via pairwise-complete covariance and
#' applying jitter if needed to ensure positive definiteness.
#'
#' @param data A numeric matrix with missing values (NAs).
#'
#' @return A list with two elements:
#' \describe{
#'   \item{mu}{A numeric vector of column means (ignoring NAs).}
#'   \item{sigma}{A numeric covariance matrix, adjusted to be symmetric and positive definite.}
#' }
#'
#' @details The function computes column means using \code{colMeans(..., na.rm = TRUE)}
#' and uses \code{cov(..., use = "pairwise.complete.obs")} to estimate the covariance matrix.
#' It then ensures that the covariance matrix is symmetric, and applies a small jitter to
#' the diagonal if any eigenvalues are close to zero or negative, to ensure positive definiteness.
#'
#' A warning message is shown if jittering is applied. If the matrix remains not positive definite
#' after jittering, the function stops with an error.
#'
#' @seealso \code{\link{run_em_algorithm}}, \code{\link{em_model}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, 2, NA, 4, 5, 6, 7, NA, 9), ncol = 3)
#' params <- initialize_parameters_nvnorm(data)
#' params$mu
#' params$sigma
initialize_parameters_nvnorm <- function(data) {
  if (!is.matrix(data) || !is.numeric(data)) {
    stop("Input data must be a numeric matrix.")
  }

  if (any(colSums(!is.na(data)) == 0)) {
    stop("One or more columns are entirely NA — cannot initialize.")
  }

  if (any(rowSums(!is.na(data)) == 0)) {
    warning("Some rows are completely NA — they will be ignored.")
  }

  mu <- colMeans(data, na.rm = TRUE)
  sigma <- cov(data, use = "pairwise.complete.obs")

  # check for NA or Inf in sigma
  if (anyNA(sigma) || any(!is.finite(sigma))) {
    stop("Covariance matrix has NA, Inf, or NaN values — likely due to too few complete observations.")
  }

  # Enforce symmetry
  sigma <- 0.5 * (sigma + t(sigma))

  # Jitter if not PD
  eig_vals <- eigen(sigma, symmetric = TRUE)$values
  min_eig <- min(eig_vals)

  if (min_eig < 1e-6) {
    jitter <- abs(min_eig) + 1e-4
    message("Warning: sigma not PD, applying jitter of ", jitter)
    sigma <- sigma + diag(jitter, ncol(sigma))
  }

  # Final check
  if (any(!is.finite(eigen(sigma, symmetric = TRUE)$values))) {
    stop("Even after jittering, sigma is not positive definite or contains NA/Inf.")
  }

  list(mu = mu, sigma = sigma)
}
