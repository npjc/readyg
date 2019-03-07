#' get file paths to example yeast grower files provided with the package.
#'
#' @export
yg_example_files <- function() {
    list.files(system.file("extdata", package = 'readyg'), full.names = TRUE)
}
