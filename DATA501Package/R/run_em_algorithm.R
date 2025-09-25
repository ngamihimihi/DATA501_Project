#' Run EM or MCEM depending on model$method
#'
#' Executes the Expectation-Maximization (EM) or Monte Carlo EM (MCEM) algorithm
#' depending on the \code{method} field of the input \code{em_model} object.
#'
#' @param model An object of class \code{em_model}, containing the data, method ("EM" or "MCEM"),
#'   and distribution type.
#' @param tolerance Numeric. Threshold for convergence (change in log-likelihood). Default is \code{1e-5}.
#' @param max_iter Integer. Maximum number of EM iterations. Default is \code{100}.
#' @param m Integer. Number of MCMC samples (used only if \code{method == "MCEM"}).
#' @param burn Integer. Burn-in samples for MCMC (MCEM only).
#' @param thin Integer. Thinning factor for MCMC (MCEM only).
#' @param tau Numeric. Proposal scale for Metropolis-Hastings (MCEM only).
#'
#' @return An updated \code{em_model} object with filled-in fields such as \code{loglik_history},
#'   \code{parameters}, \code{imputed}, and \code{early_stop}.
#'
#' @seealso \code{\link{em_engine}}, \code{\link{em_model}}, \code{\link{e_step_nvnorm}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4), ncol = 2)
#' model <- em_model(data, method = "EM")
#' result <- run_em_algorithm(model, max_iter = 10)
#' result$imputed
run_em_algorithm <- function(model, tolerance = 1e-5, max_iter = 100,
                             m = NULL, burn = NULL, thin = NULL, tau = NULL) {
  method <- model$method
  if (method == "EM") {
    em_engine(model, method = "EM", tolerance = tolerance, max_iter = max_iter)
  } else if (method == "MCEM") {
    em_engine(model, method = "MCEM", tolerance = tolerance, max_iter = max_iter,
              m = m, burn = burn, thin = thin, tau = tau)
  } else {
    stop("Unknown method: ", method)
  }
}
