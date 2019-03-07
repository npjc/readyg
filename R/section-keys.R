#' get a tibble of all the keys in all the section that may exist in one or
#' more yeast grower / ACCESS files.
#' @export
yg_section_keys <- function() {
    file <- system.file('yg-data-section-keys.csv', package = 'readyg')
    readr::read_csv(file, col_types = readr::cols(
        section = readr::col_character(),
        key = readr::col_character()
    ))
}
