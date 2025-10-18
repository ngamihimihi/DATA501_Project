#' @title Summary method for EM model objects
#' @description Summarizes the fitted EM or MCEM model.
#' @param object An object of class `em_model`.
#' @param ... Additional arguments (ignored).
#' @return Prints a summary and invisibly returns a list.
#' @export
summary.em_model <- function(object, ...) {
  stopifnot(inherits(object, "em_model"))

  cat("=====================================\n")
  cat("Expectation-Maximization Model Summary\n")
  cat("=====================================\n")
  cat("Method:        ", object$method, "\n")
  cat("Distribution:  ", object$distribution, "\n")

  if (!is.null(object$early_stop$converged))
    cat("Converged:     ", object$early_stop$converged, "\n")
  if (!is.null(object$early_stop$iterations))
    cat("Iterations:    ", object$early_stop$iterations, "\n")

  if (!is.null(object$loglik_history) && length(object$loglik_history) > 0) {
    cat("Final log-likelihood: ",
        formatC(tail(object$loglik_history, 1), digits = 6, format = "f"), "\n")
  }

  if (object$method == "MCEM") {
    accept_rate <- attr(object$imputed, "mc_accept_rate")
    model$mc_diagnostics <- list(
      accept_rate = accept_rate,
      mean_accept_rate = mean(accept_rate, na.rm = TRUE),
      sd_accept_rate   = sd(accept_rate, na.rm = TRUE),
      n_chains         = sum(!is.na(accept_rate))
    )
    cat("MCEM Diagnostics:","\n")
    cat("    Acceptance rate - Mean:     ", model$mc_diagnostics$mean_accept_rate, "\n")
    cat("    Acceptance rate - Standard Deviation:     ", model$mc_diagnostics$sd_accept_rate, "\n")
  }

  invisible(object)
}
