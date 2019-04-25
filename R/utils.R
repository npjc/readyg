#' @importFrom rlang .data
.data


`%||%` <- function(a, b) if (is.null(a)) b else a

#' well labels from dimensions of microtitre plate.
#'
#' @param nrow `<int>` number of rows
#' @param ncol `<int>` number of cols
#' @param col_nchar `<int>` the number of characters for the column section. This
#'     controls the left-padding of well labels with zeros. e.g. A1 vs. A01. The
#'     default is the number of characters in `ncol` for nice lexicographic
#'     sorting behaviour.
#' @param order `<chr>` defaults to `"rowmajor"`, alternatively `"colmajor"`
#'
#' @return
#' `<chr>` vector of well labels where the row is represented by a letter,
#'  and the col is represented by an intenger, possibly left-padded with one
#'  or more zeros.
#'
#' @keywords internal
well_labels <- function(nrow, ncol, col_nchar = nchar(ncol),
                        order = c("rowmajor", "colmajor")) {
    fmt <- paste0("%s%0",col_nchar,"d")
    order <- match.arg(order)
    switch(order,
           rowmajor = sprintf(fmt, rep(row_labels(seq_len(nrow)), each = ncol), rep(seq_len(ncol), nrow)),
           colmajor = sprintf(fmt, rep(row_labels(seq_len(nrow)), ncol), rep(seq_len(ncol), each = nrow))
    )
}

row_labels <- function(row) {
    labels <- c(LETTERS, paste0(LETTERS[1], LETTERS), paste0(LETTERS[2], LETTERS))
    labels[row]
}

#' guess the dimensions of microtitre plate from the number of wells.
#'
#' @param n `<num>` number of wells
#'
#' @return
#' [list()] of length 2: number of rows (`nrow`) and columns (`ncol`).
#'
#' @keywords internal
guess_dims_from_n <- function(n) {
    dims <- switch(as.character(n),
                   '6'    = c(2L, 3L),
                   '12'   = c(3L, 4L),
                   '24'   = c(4L, 6L),
                   '48'   = c(6L, 8L),
                   '96'   = c(8L, 12L),
                   '384'  = c(16L, 24L),
                   '1536' = c(32L, 48L))
    list(nrow = dims[1], ncol = dims[2])
}

#' get the labels for a microtitre plate based on the length of the vector.
#'
#' @param v vector of length on which guess is based.
#'
#' @keywords internal
well_labels_from_length <- function(v) {
    n <- length(v)
    dims <- guess_dims_from_n(n)
    well_labels <- well_labels(nrow = dims$nrow, ncol = dims$ncol)
    well_labels
}
