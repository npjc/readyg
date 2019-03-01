#' @export
yg_example <- function(file) {
    system.file("extdata", file, package = 'yg')
}

#' @export
yg_example_list <- function(full.names = T) {
    list.files(system.file("extdata", package = 'yg'), full.names = full.names)
}
