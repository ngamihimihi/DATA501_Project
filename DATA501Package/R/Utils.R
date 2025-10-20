#' Null coalescing operator
#'
#' Returns the left-hand side if it is not NULL, otherwise returns the right-hand side.
#'
#' @name grapes_or_or_grapes
#' @rdname grapes_or_or_grapes
#'
#' @param x Left-hand value
#' @param y Default value
#' @return The left-hand value if not NULL; otherwise the right-hand value.
#' @examples
#' NULL %||% "default"
#' 1 %||% "ignored"
#'
#' @export
`%||%` <- function(x, y) {
  if (!is.null(x)) x else y
}
