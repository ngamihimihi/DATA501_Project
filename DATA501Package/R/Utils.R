#' Null coalescing operator
#'
#' Returns the left-hand side if it is not NULL, otherwise returns the right-hand side.
#' @param x Left-hand value
#' @param y Default value
#' @export
`%||%` <- function(x, y) {
  if (!is.null(x)) x else y
}
