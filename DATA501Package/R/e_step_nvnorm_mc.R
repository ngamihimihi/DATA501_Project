#' Monte Carlo E-step for Multivariate Normal (Random Walk Metropolis-Hastings)
#'
#' Performs the E-step of the Monte Carlo EM (MCEM) algorithm for missing data
#' under a multivariate normal model using Random Walk Metropolis-Hastings (RW-MH).
#'
#' @param data A numeric matrix with missing values (NAs).
#' @param params A list containing:
#'   \describe{
#'     \item{mu}{A numeric vector of means.}
#'     \item{sigma}{A positive definite covariance matrix.}
#'   }
#' @param m Integer. Number of MCMC samples to draw (default is 200).
#' @param burn Integer. Number of burn-in iterations (default is 100).
#' @param thin Integer. Thinning factor to reduce autocorrelation (default is 1).
#' @param tau Numeric. Proposal variance scaling factor (default is 0.1).
#'
#' @return A list with:
#' \describe{
#'   \item{imputed}{Numeric matrix of the same dimension as \code{data}, with missing
#'   values imputed using Monte Carlo estimates of the conditional expectation. The
#'   attribute \code{"mc_accept_rate"} stores the mean acceptance rate of the MCMC sampler.}
#'   \item{accept_rate}{Vector of acceptance rates for each row.}
#' }
#'
#' @details This function implements a Random Walk Metropolis-Hastings sampler
#' to approximate the conditional expectations in the E-step of the MCEM algorithm.
#' It is useful when analytic imputation is intractable or when estimating
#' uncertainty from the posterior distribution of missing values.
#'
#' @seealso \code{\link{e_step_nvnorm}}, \code{\link{run_em_algorithm}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(5.1, NA, 6.1,
#'                  1.0, 1.4, 4.3,
#'                  NA, 2.2, 2.5,
#'                  3.3, 1.1, 1.0), ncol = 3, byrow = TRUE)
#' mu <- colMeans(data, na.rm = TRUE)
#' sigma <- diag(3)
#' params <- list(mu = mu, sigma = sigma)
#' result <- e_step_nvnorm_mc(data, params, m = 50, burn = 50, thin = 1, tau = 0.1)
#' result$imputed
#' attr(result$imputed, "mc_accept_rate")
e_step_nvnorm_mcem <- function(data, params,
                             m = 200, burn = 100, thin = 1, tau = 0.1) {
  stopifnot(is.matrix(data),
            is.list(params),
            !is.null(params$mu),
            !is.null(params$sigma))

  out <- .Call(`_DATA501Package_e_step_nvnorm_mcem`,
               data,
               params$mu,
               params$sigma,
               as.integer(m),
               as.integer(burn),
               as.integer(thin),
               as.numeric(tau))
  attr(out$imputed, "mc_accept_rate") <- out$accept_rate
  return(out)
}
