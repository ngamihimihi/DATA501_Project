m_step_poisson <- function(imputed_data) {
  lambda <- colMeans(imputed_data, na.rm = TRUE)
  list(lambda = lambda)
}
