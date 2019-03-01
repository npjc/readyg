empty_config_file_info <- function() {
    list(
        `last write` = NA_character_,
        last_write = NA_character_
         )
}

empty_run_parameters <- function() {
    list(
        Instrument = NA_character_,
        user = NA_character_,
        Project_Name = NA_character_
    )
}

empty_drug_data <- function() {
    list(
        Well_Pos = NA_character_,
        Well_Alias = NA_character_,
        Project_Name = NA_character_
    )
}

empty_data <- function() {
    list(
        Read = "DateTime\tRunT[s]\tTemp\tWell_1",
         `1` = "NA\tNA\tNA\tNA"
        )
}
