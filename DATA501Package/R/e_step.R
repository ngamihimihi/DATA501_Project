#' General E-step Imputation
#'
#' @param data A numeric matrix with NAs
#' @param mu Mean vector
#' @param Sigma Covariance matrix
#' @return Matrix with missing entries imputed using conditional expectations
#' @export
e_step_general_impute <-  function(data, mu, Sigma) {
  .Call(`_DATA501Package_e_step_general_impute`, data, mu, Sigma)
}
