#' read a yeast grower .txt file into  a tibble
#'
#' @param path <chr> path to file
#' @export
read_yg <- function(path) {
    l <- yg:::read_ini(path)
    l_info <- yg_read_info(l)
    l_data <- yg_read_data(l, path)
    out <- list(info = list(l_info), data = list(l_data))
    tibble::as_tibble(out)
}

#' read the info sections from ini yg files
#'
#' @param l  list of parsed ini file
yg_read_info <- function(l) {
    # config file info section
    cfi <- l[["config file info"]] %||% empty_config_file_info()
    cfi <- tibble::repair_names(cfi)
    cfi <- tibble::as_tibble(cfi)
    # run parameters section
    rp <- l[["Run_Parameters"]] %||% empty_run_parameters()
    rp <- tibble::repair_names(rp)
    rp <- tibble::as_tibble(rp)
    # drug data section
    dd <- l[["Drug_Data"]] %||% empty_drug_data()
    dd <- tibble::repair_names(dd)
    dd <- tibble::as_tibble(dd)
    dplyr::bind_cols(cfi, rp, dd)
}


#' read the data sections from ini yg files
#'
#' @param l  list of parsed ini file
yg_read_data <- function(l, path) {
    # data section
    d <- l[["Data:"]] %||% empty_data()
    pad <- ''
    if(length(d) == 1){
        pad <- '\n'
    }
    d <- paste0(c(unlist(d, use.names = F), pad), collapse = '\n')
    d <- readr::read_tsv(d)
    d <- tidyr::extract(d, DateTime, c("date", "time"), "D(\\d+)_(.+)")
    start_date <- start_date_from_filename(path)
    d <- dplyr::mutate(d, date = start_date + as.integer(date))
    d <- dplyr::mutate(d, datetime = as.POSIXct(paste(date, time)))
    d <- dplyr::select(d, -date, -time)
    d <- dplyr::mutate(d,
                       runtime = `RunT[s]`,
                       temperature = as.numeric(stringr::str_replace(Temp, "^(\\d{2})","\\1\\."))
    )
    d <- dplyr::select(d, -`RunT[s]`, -Temp)

    well_cols <- stringr::str_subset(names(d), "Well_")
    other_cols <- setdiff(names(d), well_cols)
    well_labels <- mtp_labels_from_length(well_cols)
    names(d) <- c(well_labels, other_cols)
    d <- dplyr::select(d, dplyr::one_of(other_cols), dplyr::one_of(well_labels))
    d <- tidyr::gather(d, well, measurement, dplyr::one_of(well_labels))
    # d <- dplyr::mutate(d, well = as.integer(stringr::str_replace(well, "^Well_", '')))
    d
}

start_date_from_filename <- function(path) {
    m <- stringr::str_match(basename(path), "^(\\d+_\\d+_\\d+)_.+")
    as.Date(m[,2], format = "%d_%m_%y")
}
