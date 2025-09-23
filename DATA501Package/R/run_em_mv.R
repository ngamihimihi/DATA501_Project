#' Run the EM Algorithm on an em_model Object
#'
#' Iteratively imputes missing values using the Expectation-Maximization (EM)
#' algorithm under the assumption of multivariate normality. The algorithm
#' alternates between imputing missing values (E-step) and updating parameters
#' (M-step) until convergence.
#'
#' @param model An object of class \code{em_model}, initialized with a numeric matrix.
#' @param tolerance A numeric threshold for convergence based on change in log-likelihood
#'   between iterations. Default is \code{1e-5}.
#' @param max_iter Maximum number of iterations before stopping. Default is \code{100}.
#'
#' @return The updated \code{em_model} object with fields populated:
#' \describe{
#'   \item{loglik_history}{A numeric vector of log-likelihood values per iteration.}
#'   \item{parameters}{Final estimates: mean vector \code{mu} and covariance \code{Sigma}.}
#'   \item{parameter_history}{List of \code{mu} and \code{Sigma} estimates at each iteration.}
#'   \item{imputed}{Matrix with imputed values filled in.}
#'   \item{early_stop}{List containing convergence flag and iteration count.}
#' }
#'
#' @details The E-step uses conditional expectations to impute missing values,
#' and the M-step updates the mean and covariance estimates using the imputed data.
#'
#' @seealso \code{\link{em_model}}, \code{\link{e_step_general_impute}}, \code{\link{m_step_estimate}}, \code{\link{log_likelihood_mvnorm}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4), ncol = 2)
#' model <- em_model(data)
#' result <- run_em_algorithm(model, max_iter = 5)
#' result$imputed
#' plot(result$loglik_history, type = "l", main = "Log-Likelihood")
run_em_algorithm <- function(data, tolerance = 1e-5, max_iter = 100) {
  stopifnot(inherits(model, "em_model"))
  # --- Extract from model object ---
  data <- model$data
  dist <- model$distribution

  # --- Initialization ---
  params <- initialize_parameters(data, dist)
  params$distribution <- dist  # Store the distribution inside params for tracking

  # --- Dynamic Dispatch ---
  e_step_fn   <- get(paste0("e_step_", dist))
  m_step_fn   <- get(paste0("m_step_", dist))
  loglik_fn   <- get(paste0("log_likelihood_", dist))

  loglik_history     <- numeric()
  parameter_history  <- list()
  iter               <- 0
  converged          <- FALSE


  # --- Check if the distribution fucntion exists ---
  for (fn in c("e_step_", "m_step_", "log_likelihood_")) {
    full_fn <- paste0(fn, dist)
    if (!exists(full_fn)) stop("Missing function: ", full_fn)
  }
  while (iter < max_iter) {
    iter <- iter + 1

    # --- E-step ---
    imputed_data <- e_step_fn(data, params)

    # --- Log-likelihood ---
#    print("DEBUG: params at log-likelihood call:")
#    str(params)

    loglik <- loglik_fn(imputed_data, params)
    loglik_history <- c(loglik_history, loglik)

    # --- Save parameter history ---
    parameter_history[[iter]] <- params

    # --- Convergence check ---
    if (iter > 1 && abs(loglik - loglik_history[iter - 1]) < tolerance) {
      converged <- TRUE
      break
    }

    # --- M-step ---

    params <- m_step_fn(imputed_data)

    if (is.null(params$mu) || is.null(params$sigma)) {
      stop("m_step_fn() returned NULL for mu or sigma.")
    }
    params$distribution <- dist  # Keep track
  }

  # Update model object
  # --- Finalize model ---
  model$parameters         <- params
  model$parameter_history  <- parameter_history
  model$loglik_history     <- loglik_history
  model$imputed            <- imputed_data
  model$early_stop         <- list(converged = converged, iterations = iter)


  return(model)
}
