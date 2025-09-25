#' Dispatcher for Parameter Initialization Based on Distribution
#'
#' Dynamically dispatches to the appropriate parameter initialization function
#' based on the specified distribution name. This supports multiple distribution
#' families in EM or MCEM workflows by modularizing the initialization logic.
#'
#' @param data A numeric matrix with possible missing values (NAs). The structure and
#'   assumptions about the data depend on the target distribution.
#' @param dist A character string indicating the assumed distribution of the data.
#'   Supported values include: \code{"mvnorm"}, \code{"poisson"}, \code{"mixture"}, etc.
#'
#' @return A named list of initialized parameters appropriate for the given distribution.
#'   For example:
#'   \describe{
#'     \item{\code{"mvnorm"}}{Returns \code{list(mu = ..., sigma = ...)}}
#'     \item{\code{"poisson"}}{Returns \code{list(lambda = ...)}}
#'     \item{\code{"mixture"}}{Returns \code{list(mu = list(...), pi = ...)}}
#'   }
#'
#' @details This is a dynamic wrapper that looks for a function named
#' \code{initialize_parameters_<dist>} in the global or package environment and calls it.
#' The corresponding function must exist; otherwise, an error is thrown.
#'
#' @seealso \code{\link{initialize_parameters_mvnorm}},
#'   \code{\link{initialize_parameters_poisson}},
#'   \code{\link{initialize_parameters_mixture}}
#'
#' @export
#'
#' @examples
#' data <- matrix(c(1, NA, 3, 4, 2, 1), ncol = 2)
#' initialize_parameters(data, "mvnorm")
#' initialize_parameters(data, "poisson")
initialize_parameters <- function(data, dist) {
  init_fn <- get(paste0("initialize_parameters_", dist))
  init_fn(data)
}
