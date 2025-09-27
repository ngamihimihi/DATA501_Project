#' Core EM/MCEM Engine for an em_model Object
#'
#' In this draft package: only multivariate normal distribution is ready for testing (method = 'nvnorm')
#'
#' Runs the Expectation-Maximization (EM) or Monte Carlo EM (MCEM) algorithm on
#' an \code{em_model} object assuming a multivariate normal distribution. The algorithm
#' iteratively imputes missing values (E-step) and updates parameters (M-step) until convergence
#' or a maximum number of iterations is reached.
#' In this draft package: only multivariate normal distribution is ready for testing (method = 'nvnorm')
#'
#' @param model An object of class \code{em_model}.
#' @param method Character string: either \code{"EM"} or \code{"MCEM"}.
#' @param tolerance A numeric threshold for convergence, based on the absolute change
#'   in log-likelihood between iterations. Default is \code{1e-5}.
#' @param max_iter Maximum number of iterations. Default is \code{100}.
#' @param m Number of MCMC samples for the MCEM E-step (used only if method = "MCEM").
#' @param burn Number of burn-in iterations for the MCMC sampler (MCEM only).
#' @param thin Thinning parameter for MCMC sampler (MCEM only).
#' @param tau Proposal scale for Random Walk Metropolis-Hastings sampler (MCEM only).
#'
#' @return An updated \code{em_model} object with the following fields populated:
#' \describe{
#'   \item{loglik_history}{Log-likelihood value at each iteration.}
#'   \item{parameters}{Final estimated parameters: mean vector and covariance matrix.}
#'   \item{parameter_history}{List of parameters tracked over iterations.}
#'   \item{imputed}{Matrix with imputed values.}
#'   \item{early_stop}{List with \code{converged} flag and number of \code{iterations}.}
#'   \item{mc_diagnostics}{(Only if MCEM) Acceptance rates of the RW-MH sampler per iteration.}
#' }
#'
#' @details This function is the computational engine underlying the user-facing
#' \code{\link{run_em_algorithm}} wrapper. It supports both deterministic EM and
#' stochastic MCEM modes. The appropriate E-step and M-step functions are dynamically
#' dispatched based on the model's \code{distribution} field.
#'
#' @seealso \code{\link{em_model}}, \code{\link{run_em_algorithm}},
#'   \code{\link{e_step_nvnorm}}, \code{\link{e_step_nvnorm_mc}},
#'   \code{\link{m_step_nvnorm}}, \code{\link{log_likelihood_mvnorm}}
#'
#' @keywords internal
#' @export
em_engine <- function(model, method = "EM", tolerance = 1e-5, max_iter = 100,
                      m = NULL, burn = NULL, thin = NULL, tau = NULL) {
  stopifnot(inherits(model, "em_model"))

  data <- model$data
  dist <- model$distribution

  # Initialization
  params <- initialize_parameters(data, dist)
  params$distribution <- dist

  # Dispatch core functions
  e_step_fn   <- get(paste0("e_step_", dist, "_" ,tolower(method)))
  m_step_fn   <- get(paste0("m_step_", dist))
  loglik_fn   <- get(paste0("log_likelihood_", dist))

  #for (fn in c("e_step_", "m_step_", "log_likelihood_")) {
  #  full_fn <- paste0(fn, dist,)
  #  if (!exists(full_fn)) stop("Missing function: ", full_fn)
  #}

  loglik_history    <- numeric()
  parameter_history <- list()
  mc_diagnostics    <- list()
  iter              <- 0
  converged         <- FALSE

  while (iter < max_iter) {
    iter <- iter + 1

    # E-step
    if (method == "EM") {
      imputed_data <- e_step_fn(data, params)
    }
    else if (method == "MCEM") {
      res <- e_step_fn(
        data, params,
        m = m %||% 200,
        burn = burn %||% 100,
        thin = thin %||% 1,
        tau = tau %||% 0.1
      )
      imputed_data <- res$imputed
      mc_diagnostics[[iter]] <- res$accept_rate
    } else {
      stop("Invalid method: choose 'EM' or 'MCEM'.")
    }

    # M-step
    params <- m_step_fn(imputed_data)
    if (is.null(params$mu) || is.null(params$sigma)) {
      stop("m_step_fn() returned NULL for mu or sigma.")
    }
    # Log-likelihood after parameter update
    loglik <- loglik_fn(imputed_data, params)
    loglik_history <- c(loglik_history, loglik)
    parameter_history[[iter]] <- params
    # Convergence check
    if (iter > 1 && abs(loglik - loglik_history[iter - 1]) < tolerance) {
      converged <- TRUE
      break
    }
    # Log parameter history and the most recent parameter.

  }

  # Finalize and return model
  params$distribution      <- dist
  model$parameters         <- params
  model$parameter_history  <- parameter_history
  model$loglik_history     <- loglik_history
  model$imputed            <- imputed_data
  model$early_stop         <- list(converged = converged, iterations = iter)
  if (method == "MCEM") model$mc_diagnostics <- mc_diagnostics

  return(model)
}
