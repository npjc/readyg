#' read a yeast grower .txt file into  a tibble
#'
#' @param path <chr> path to file
#' @param start_date <chr> character vector of start date 'YYYY-MM-DD' format.
#' @export
read_yg <- function(path, start_date = NULL, tidy_data_section = TRUE) {
    l <- read_ini(path, omit = omitted_yg_sections())
    run_params <- parse_section(l[["Run_Parameters"]])
    drug_data <- parse_section(l[["Drug_Data"]])

    start_date <- start_date %||% start_date_from_filename(path)
    data <- parse_section_data(l[["Data:"]], start_date)
    if (tidy_data_section) {
      data <- tidy_data_section(data)
    }
    out <- list(
        data = list(data),
        run_params = list(run_params),
        drug_data = list(drug_data))
    tibble::as_tibble(out)
}


parse_section <- function(l) {
    if (is.null(l)) {
        return(NULL)
    }
    values <- stringr::str_remove_all(unlist(l), '"') # '"misc"' -> 'misc'
    tibble::tibble(key = names(l), value = values)
}

#' read the data sections from ini yg files
#'
#' @param l  list of parsed ini file
#' @param start_date date that signifies 'D0' in the raw text file. Because the
#'     format encodes only relative datetime in the data section need to have
#'     standard date be supplied externally.
parse_section_data <- function(l, start_date) {
  # FIXME: make tests explicit:
  #     - handles missing data sections (null)
  #     - handles data sections that exist but only have header row
  if (is.null(l)) {
    return(NULL)
  }

    s <- collapse_list(l)
    col_names <- col_names_from_header_line(l[[1]])
    d <- readr::read_tsv(s, skip = 1, col_names = col_names)

    d <- dplyr::mutate(d, datetime = fix_datetime(datetime, start_date))
    d <- dplyr::mutate(d, temperature = fix_temperature(temperature))
    d
}

#' FIXME: turn these into actual test cases:
#' can_fix <- c('300', '30.1')
fix_temperature <- function(v) {
  v <- stringr::str_replace(v, '\\.', '')
  as.numeric(stringr::str_replace(v, "^(\\d{2})","\\1\\."))
}

#' FIXME: turn these into actual test cases:
#' can_fix <- c("D0 _13:48:51", "D0_13:48:51", "13:48:51")
fix_datetime <- function(v, start_date) {
  v <- as.character(v)
  v <- dplyr::if_else(stringr::str_starts(v, 'D'), v, paste0('D0_', v))
  matches <- stringr::str_match(v, "D(\\d+) ?_(.+)")

  date <- as.Date(start_date) + as.integer(matches[,2])
  time <- matches[,3]
  as.POSIXct(paste(date, time))
}

tidy_data_section <- function(d) {
  if(is.null(d)){
    return(NULL)
  }
  d <- dplyr::group_by(d, datetime, temperature, runtime)
  d <- tidyr::gather(d, well, value, -datetime, -temperature, -runtime)
  d <- dplyr::ungroup(d)
  dplyr::select(d, well, datetime, runtime, value, temperature)
}

start_date_from_filename <- function(path) {
    m <- stringr::str_match(basename(path), "^(\\d+_\\d+_\\d+)_.+")
    as.Date(m[,2], format = "%d_%m_%y")
}

omitted_yg_sections <- function() {
    c("config file info",
      "Runtime_State",
      "Analysis",
      "Run_Parameters_Track_Changes",
      "Runtime_State_Track_Changes",
      "LH_Saves",
      "LH_Innocs",
      "LH_Errors",
      "Flor:",
      "Flor2:",
      "Lumin:",
      "Parameter_Values",
      "Meas_Info")
}


col_names_from_header_line <- function(line) {
    vars <- unlist(stringr::str_split(line,'\t'))
    well_vars <- stringr::str_subset(vars, "Well_\\d+")
    other_vars <- setdiff(vars, well_vars)
    c(rename_other_vars(other_vars), rename_well_vars(well_vars))
}

rename_other_vars <- function(vars) {
    purrr::map_chr(vars,
    ~switch (.x,
            "DateTime" = "datetime",
            "RunT[s]" = "runtime",
            "Temp" = "temperature"
            )
    )
}
#' the well variables in access are defined in row-major order as standard for
#' 96 adn 384 well plates but not in 48 well plates where they use a custom
#' labelling. Default to standard i.e. well 1 -> 'A01' but could support
#' access mapping in the future.
rename_well_vars <- function(well_ids, mapping = c('standard', 'access')) {
    mapping <- match.arg(mapping)
    if(mapping == 'access')
        stop('access well mapping is not supported.')
    mtp_labels_from_length(well_ids)
}

collapse_list <- function(l) {
    pad <- ''
    if(length(l) == 1){
        pad <- '\n'
    }
    paste0(c(unlist(l, use.names = F), pad), collapse = '\n')
}
