#' @export
initialize_parameters_mixture <- function(data) {
  k <- 2  # assume 2 components, can be passed later
  # Placeholder: k-means initialization
  km <- kmeans(na.omit(data), centers = k)
  mu_list <- split(km$centers, rep(1:k, each = ncol(data)))
  pi_vec <- table(km$cluster) / nrow(data)

  list(mu = mu_list, pi = pi_vec)
}
