#' Constructor for em_model object
#' @param data Input data matrix with missing values
#' @param method "EM" or "MCEM"
#' @param early_stop List of early stopping criteria
#' @return An object of class em_model
em_model <- function(data, method = "EM", early_stop = list()) {
  structure(list(
    data = data,
    method = method,
    early_stop = early_stop,
    loglik_history = numeric(),
    error_history = list(MAE = numeric(), RMSE = numeric()),
    parameters = list(mu = NULL, sigma = NULL),
    parameter_history = list(mu = list(), sigma = list()),
    imputed = NULL
  ), class = "em_model")
}