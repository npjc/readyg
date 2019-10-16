#' @importFrom rlang .data
.data


`%||%` <- function(a, b) if (is.null(a)) b else a
