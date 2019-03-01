#' Read ini formatted text file into a nested section-key-value list.
#'
#' This is re-written from the `ini::read.ini()` function to use stringr for
#' tokenization and matching. This simplifies the source code and makes it
#' ~3 times faster. It is also strictly reading in UTF-8.
#'
#' This function is used to parse the yeast grower data.
#'
#' `identical(read_ini(path), read.ini(path))` returns TRUE.
#'
#' @param path <chr> path to file
#'
#'
read_ini <- function (path){

    sectionREGEXP <- "^\\s*\\[\\s*(.+?)\\s*]"
    keyValueREGEXP <- "^\\s*[^=]+=.+"
    ignoreREGEXP <- "^\\s*[;#]"

    ini <- list()
    con <- file(path, open = "r", encoding = 'UTF-8')
    on.exit(close(con))

    while (TRUE) {
        line <- readLines(con, n = 1, encoding = 'UTF-8', warn = F)
        if (length(line) == 0) {
            break
        }
        if (stringr::str_detect(line, ignoreREGEXP)) {
            next
        }
        if (stringr::str_detect(line, sectionREGEXP)) {
            lastSection <- stringr::str_match(line, sectionREGEXP)[,2]
        }
        if (stringr::str_detect(line, keyValueREGEXP)) {
            l <- stringr::str_split_fixed(line, '\\s*=\\s*', n = 2)
            child <- setNames(list(l[[2]]), l[[1]])
            ini[[lastSection]] <- c(ini[[lastSection]], child)
        }
    }
    ini
}
