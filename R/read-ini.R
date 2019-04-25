#' Read ini file
#'
#' Compared to `ini::read.ini()` is ~4x faster and allows you to omit
#' certain sections.
#'
#' This function is used internally to parse the yeast grower data ini files.
#'
#' @param path `<chr>` path to file
#' @param omit `<chr>` section name(s) to omit
#' @param encoding `<chr>` defaults to 'UTF-8' encoding.
#'
#' @export
read_ini <- function(path, omit = NULL, encoding = 'UTF-8') {

    r_ignore = "^\\s*[;#]"
    r_section = "^\\s*\\[\\s*(.+?)\\s*]"
    r_keyvalue = "^\\s*([^=]+)=(.+)"

    ini <- list()
    con <- file(path, open = "r", encoding = encoding)
    on.exit(close(con))

    while (TRUE) {
        line <- readLines(con, n = 1, encoding = encoding, warn = F)
        if (length(line) == 0) {
            break
        }

        state <- stringr::str_detect(line, c(r_ignore, r_section, r_keyvalue))

        if (state[1]) {
            next
        }

        if (state[2]) {
            last_section <- stringr::str_match(line, r_section)[,2]
        }

        if (!last_section %in% omit) {
            if (state[3]) {
                l <- stringr::str_split_fixed(line, '\\s*=\\s*', n = 2)
                child <- stats::setNames(list(l[[2]]), l[[1]])
                ini[[last_section]] <- c(ini[[last_section]], child)
            }
        }
    }
    ini
}


section_key_valuefy <- function(l) {
    l <- purrr::map(l, ~tibble::tibble(key = names(.x), value = unlist(.x)))
    d <- dplyr::bind_rows(l, .id = 'section')
    dplyr::distinct(d)
}

#' @param section `<chr>` name of the section to read in
#' @export
#' @rdname read_ini
read_ini_section <- function(path, section, encoding = 'UTF-8') {
    r_ignore = "^\\s*[;#]"
    r_section = "^\\s*\\[\\s*(.+?)\\s*]"
    r_keyvalue = "^\\s*([^=]+)=(.+)"

    ini <- list()
    con <- file(path, open = "r", encoding = encoding)
    on.exit(close(con))

    while (TRUE) {
        line <- readLines(con, n = 1, encoding = encoding, warn = F)
        if (length(line) == 0) {
            break
        }

        state <- stringr::str_detect(line, c(r_ignore, r_section, r_keyvalue))

        if (state[1]) {
            next
        }

        if (state[2]) {
            last_section <- stringr::str_match(line, r_section)[,2]
        }

        if (exists('last_section') & last_section == section) {
            if (state[3]) {
                l <- stringr::str_split_fixed(line, '\\s*=\\s*', n = 2)
                child <- stats::setNames(list(l[[2]]), l[[1]])
                ini <- c(ini, child)
            }
        }
    }
    if (length(ini) == 0) {
        return(ini)
    }
    d <- tibble::enframe(ini)
    d <- tidyr::unnest(d, .data$value)
    dplyr::mutate(d, value = stringr::str_remove_all(.data$value, '"'))
}
