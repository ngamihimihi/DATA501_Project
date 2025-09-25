#' Initialize Parameters for a Gaussian Mixture Model
#'
#' Initializes parameters for a Gaussian Mixture Model (GMM) using k-means clustering.
#' This is typically used before running the EM algorithm on incomplete data,
#' where component means and mixing proportions must be estimated.
#'
#' @param data A numeric matrix or data frame with no missing values in rows used
#'   for initialization. Rows with \code{NA}s will be excluded internally via \code{na.omit()}.
#'
#' @return A list with initial parameter estimates:
#' \describe{
#'   \item{mu}{A list of mean vectors for each component (length = number of components).}
#'   \item{pi}{A numeric vector of mixing proportions (sums to 1).}
#' }
#'
#' @details This function currently assumes \code{k = 2} mixture components.
#' The function uses k-means clustering on the complete cases of \code{data}
#' to initialize cluster centers as component means, and relative cluster sizes
#' as mixing proportions.
#'
#' @export
#'
#' @examples
#' set.seed(42)
#' data <- rbind(
#'   matrix(rnorm(50, mean = 0), ncol = 2),
#'   matrix(rnorm(50, mean = 5), ncol = 2)
#' )
#' result <- initialize_parameters_mixture(data)
#' result$mu
#' result$pi
initialize_parameters_mixture <- function(data) {
  k <- 2  # assume 2 components, can be passed later
  # Placeholder: k-means initialization
  km <- kmeans(na.omit(data), centers = k)
  mu_list <- split(km$centers, rep(1:k, each = ncol(data)))
  pi_vec <- table(km$cluster) / nrow(data)

  list(mu = mu_list, pi = pi_vec)
}
