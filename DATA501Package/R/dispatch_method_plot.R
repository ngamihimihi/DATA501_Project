#' @title Plot method for EM model objects
#' @description Plot the log-likelihood trajectory from an EM/MCEM model.
#' @param x An object of class `em_model`.
#' @param what Character: plot to show — `"loglik"`.
#' @param ... Additional arguments passed to ggplot.
#' @return A ggplot object.
#' @export
plot.em_model <- function(x, what = c("loglik"), ...) {
  stopifnot(inherits(x, "em_model"))
  what <- match.arg(what)

  if (what == "loglik") {
    # ----- Log-likelihood plot -----
    if (is.null(x$loglik_history) || length(x$loglik_history) == 0) {
      message("No log-likelihood history available.")
      return(invisible(NULL))
    }

    df <- data.frame(
      iteration = seq_along(x$loglik_history),
      loglik = x$loglik_history
    )

    p <- ggplot2::ggplot(df, ggplot2::aes(x = iteration, y = loglik)) +
      ggplot2::geom_line(linewidth = 0.8, color = "steelblue") +
      ggplot2::geom_point(size = 1.2, color = "grey30") +
      ggplot2::theme_bw() +
      ggplot2::labs(
        title = paste("Log-Likelihood over iterations (", x$method, ")"),
        x = "Iteration", y = "Log-Likelihood"
      )

  }

  print(p)
  invisible(p)
}
