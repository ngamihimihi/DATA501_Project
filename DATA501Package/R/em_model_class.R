#' Constructor for em_model Object
#'
#' Initializes an EM model structure with input data and placeholders
#' for algorithm output. Used as the primary object to pass through
#' the EM or MCEM pipeline.
#'
#' @param data A numeric matrix with missing values (NAs). Must not be entirely missing.
#' @param method A character string, either \code{"EM"} or \code{"MCEM"}, which determines the algorithm to use.
#' @param distribution A character string indicating the assumed distribution family. Currently only \code{"mvnorm"} is supported.
#' @param early_stop A list to store convergence status and iteration count. Defaults to an empty list.
#'
#' @return An object of class \code{em_model} with initialized slots for parameters, history, and output.
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4), ncol = 2)
#' model1 <- em_model(data)
#' model2 <- em_model(data, method = "MCEM")
em_model <- function(data, method = "EM", distribution="mvnorm",early_stop = list()) {
  ##### --- CHECK DATA ---
  # Throw error if one of the components if not numeric.
  if (!is.matrix(data) || !is.numeric(data)) {
    stop("Input data must be a numeric matrix.")
  }
  # Throw error if all components are null
  if (all(is.na(data))) {
    stop("Input data matrix cannot contain only missing values.")
  }
  #### --- CHECK METHOD ---
  supported_methods <- c("EM", "MCEM")
  if (!method %in% supported_methods) {
    stop("Method must be one of: ", paste(supported_methods, collapse = ", "))
  }
  #### --- CHECK DISTRIBUTION ---
  supported_distribution <- c("nvnorm", "poisson","mixture")
  if (!distribution %in% supported_distribution) {
    stop("Only the following distributions are supported currently: ", paste(supported_distribution, collapse = ", "))
  }

  #### --- OBJECT STRUCTURE
  structure(list(
    data = data,
    method = method,
    early_stop = early_stop,
    loglik_history = numeric(),
    distribution=distribution,
    #error_history = list(MAE = numeric(), RMSE = numeric()), #need to track change of mu and sigma over time as a parameter instead of error tracking
    parameters = list(),
    parameter_history = list(),
    imputed = NULL
  ), class = "em_model")
}

