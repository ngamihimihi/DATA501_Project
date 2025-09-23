#' Constructor for em_model object
#'
#' Initializes an EM model structure with input data and placeholders
#' for algorithm output.
#'
#' @param data A numeric matrix with missing values (NAs).
#' @param method A character string, either "EM" or "MCEM", this will determine which method to apply
#' @param early_stop A list to store early stopping information.
#'
#' @return An object of class \code{em_model}.
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4), ncol = 2)
#' model <- em_model(data)
em_model <- function(data, method = "EM", distribution="mvnorm",early_stop = list()) {
  #Throw error if one of the components if not numeric.
  if (!is.matrix(data) || !is.numeric(data)) {
    stop("Input data must be a numeric matrix.")
  }
  #Throw error if all components are null
  if (all(is.na(data))) {
    stop("Input data matrix cannot contain only missing values.")
  }

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

