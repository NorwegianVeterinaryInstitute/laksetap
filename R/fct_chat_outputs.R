#' chat_system_prompt
#' @description System prompt for the data-chat assistant, describing the
#' available datasets and how to use the registered tools.
#'
#' @return A character string.
#'
#' @noRd
chat_system_prompt <- function() {
  readLines(app_sys("app/www/chat_system_prompt.md"), warn = FALSE) |>
    paste(collapse = "\n")
}


#' chat_rows_to_list
#' @description Convert a data frame of tool results into a small,
#' LLM-friendly list, capping the number of rows returned. A broad question
#' (e.g. no region/year given) can still match hundreds of rows even after
#' species/geo_group filtering. Without a cap, all of them would be
#' serialized into the model's context on every turn, which is slow on
#' local models and costly on hosted ones. `row_count` still carries the
#' true total so the model can tell the user the answer was truncated.
#'
#' @param dat a data frame
#' @param limit maximum number of rows to include
#'
#' @return a list with `row_count`, `rows` and an optional truncation `note`
#'
#' @noRd
chat_rows_to_list <- function(dat, limit = 40) {
  labels <- golem::get_golem_options(which = "labels")
  n <- nrow(dat)

  if (n == 0) {
    return(list(row_count = 0, rows = list(), note = NA_character_))
  }

  truncated <- n > limit
  dat <- utils::head(dat, limit)

  rows <- lapply(seq_len(nrow(dat)), function(i) {
    as.list(dat[i, , drop = FALSE])
  })

  list(
    row_count = n,
    rows = rows,
    note = if (truncated) {
      sprintf(labels$chat_tools$messages$truncated_rows, limit, n)
    } else {
      NA_character_
    }
  )
}


#' chat_apply_common_filters
#' @description Filter a chat dataset by species/geo_group (always) and
#' optionally by region/year, returning notes when a requested region or
#' year does not exist so the model can self-correct instead of guessing.
#'
#' @param dat a data frame with `species`, `geo_group`, `region`, `year`
#' @param species,geo_group,region,year filter values, `region`/`year` optional
#'
#' @return a list with `data` (filtered data frame) and `notes` (character vector)
#'
#' @noRd
chat_apply_common_filters <- function(
  dat,
  species,
  geo_group,
  region = NULL,
  year = NULL
) {
  labels <- golem::get_golem_options(which = "labels")

  dat <- dat |>
    dplyr::filter(.data$species == !!species, .data$geo_group == !!geo_group) |>
    dplyr::mutate(region = as.character(.data$region))

  notes <- character()

  if (!is.null(region) && nzchar(region)) {
    matched <- dat |>
      dplyr::filter(tolower(trimws(.data$region)) == tolower(trimws(!!region)))

    if (nrow(matched) == 0) {
      available <- sort(unique(dat$region))
      notes <- c(
        notes,
        sprintf(
          labels$chat_tools$messages$region_not_found,
          region,
          geo_group,
          paste(utils::head(available, 20), collapse = ", ")
        )
      )
    } else {
      dat <- matched
    }
  }

  if (!is.null(year)) {
    matched <- dat |>
      dplyr::filter(as.character(.data$year) == as.character(!!year))

    if (nrow(matched) == 0) {
      available <- sort(unique(as.character(dat$year)))
      notes <- c(
        notes,
        sprintf(
          labels$chat_tools$messages$year_not_found,
          year,
          paste(available, collapse = ", ")
        )
      )
    } else {
      dat <- matched
    }
  }

  list(data = dat, notes = notes)
}


#' chat_apply_month_filter
#' @description Filter a chat dataset (with a `date` column) by month number.
#'
#' @param dat a data frame with a `date` column
#' @param month integer 1-12, or NULL
#'
#' @return a list with `data` (filtered data frame) and `notes` (character vector)
#'
#' @noRd
chat_apply_month_filter <- function(dat, month) {
  labels <- golem::get_golem_options(which = "labels")

  if (is.null(month)) {
    return(list(data = dat, notes = character()))
  }

  m <- suppressWarnings(as.integer(month))

  if (is.na(m) || m < 1 || m > 12) {
    return(list(
      data = dat,
      notes = sprintf(labels$chat_tools$messages$invalid_month, month)
    ))
  }

  matched <- dat |>
    dplyr::filter(as.integer(format(.data$date, "%m")) == m)

  if (nrow(matched) == 0) {
    return(list(
      data = dat,
      notes = sprintf(labels$chat_tools$messages$month_not_found, m)
    ))
  }

  list(data = matched, notes = character())
}


#' tool_monthly_mortality_impl
#' @description Tool implementation: monthly mortality (%) for salmon/rainbow
#' trout in the sea phase.
#'
#' @noRd
tool_monthly_mortality_impl <- function(
  species = "salmon",
  geo_group = "area",
  region = NULL,
  year = NULL,
  month = NULL
) {
  labels <- golem::get_golem_options(which = "labels")

  dat <- getOption("monthly_mortality_data_lc")
  filtered <- chat_apply_common_filters(dat, species, geo_group, region, year)
  by_month <- chat_apply_month_filter(filtered$data, month)

  dat_out <- by_month$data |>
    dplyr::arrange(.data$year, .data$date) |>
    dplyr::select("year", "month_name", "region", "q1", "median", "q3")

  rows <- chat_rows_to_list(dat_out)

  list(
    summary = labels$chat_tools$summaries$monthly_mortality,
    row_count = rows$row_count,
    rows = rows$rows,
    notes = Filter(Negate(is.na), c(filtered$notes, by_month$notes, rows$note))
  )
}


#' tool_cumulative_mortality_impl
#' @description Tool implementation: cumulative yearly mortality (%),
#' reported per month.
#'
#' @noRd
tool_cumulative_mortality_impl <- function(
  species = "salmon",
  geo_group = "area",
  region = NULL,
  year = NULL,
  month = NULL
) {
  labels <- golem::get_golem_options(which = "labels")

  dat <- getOption("cumulative_mortality_yr_data_lc")
  filtered <- chat_apply_common_filters(dat, species, geo_group, region, year)
  by_month <- chat_apply_month_filter(filtered$data, month)

  dat_out <- by_month$data |>
    dplyr::arrange(.data$year, .data$date) |>
    dplyr::select("year", "month_name", "region", "mean")

  rows <- chat_rows_to_list(dat_out)

  list(
    summary = labels$chat_tools$summaries$cumulative_mortality,
    row_count = rows$row_count,
    rows = rows$rows,
    notes = Filter(Negate(is.na), c(filtered$notes, by_month$notes, rows$note))
  )
}


#' tool_cohort_mortality_impl
#' @description Tool implementation: mortality (%) for completed production
#' cycles (cohorts), per year and region.
#'
#' @noRd
tool_cohort_mortality_impl <- function(
  species = "salmon",
  geo_group = "area",
  region = NULL,
  year = NULL
) {
  labels <- golem::get_golem_options(which = "labels")

  dat <- getOption("cohort_mortality_data")
  filtered <- chat_apply_common_filters(dat, species, geo_group, region, year)

  dat_out <- filtered$data |>
    dplyr::arrange(.data$year) |>
    dplyr::select("year", "region", "q1", "median", "q3")

  rows <- chat_rows_to_list(dat_out)

  list(
    summary = labels$chat_tools$summaries$cohort_mortality,
    row_count = rows$row_count,
    rows = rows$rows,
    notes = Filter(Negate(is.na), c(filtered$notes, rows$note))
  )
}


#' tool_monthly_losses_impl
#' @description Tool implementation: monthly loss counts (dead, discarded,
#' escaped, other).
#'
#' @noRd
tool_monthly_losses_impl <- function(
  species = "salmon",
  geo_group = "area",
  region = NULL,
  year = NULL,
  month = NULL
) {
  labels <- golem::get_golem_options(which = "labels")

  dat <- getOption("monthly_losses_data_lc")
  filtered <- chat_apply_common_filters(dat, species, geo_group, region, year)
  by_month <- chat_apply_month_filter(filtered$data, month)

  dat_out <- by_month$data |>
    dplyr::arrange(.data$year, .data$date) |>
    dplyr::select(
      "year",
      "month_name",
      "region",
      "losses",
      "dead",
      "discarded",
      "escaped",
      "other"
    )

  rows <- chat_rows_to_list(dat_out)

  list(
    summary = labels$chat_tools$summaries$monthly_losses,
    row_count = rows$row_count,
    rows = rows$rows,
    notes = Filter(Negate(is.na), c(filtered$notes, by_month$notes, rows$note))
  )
}


#' tool_yearly_losses_impl
#' @description Tool implementation: yearly loss counts (dead, discarded,
#' escaped, other).
#'
#' @noRd
tool_yearly_losses_impl <- function(
  species = "salmon",
  geo_group = "area",
  region = NULL,
  year = NULL
) {
  labels <- golem::get_golem_options(which = "labels")

  dat <- getOption("yearly_losses_data")
  filtered <- chat_apply_common_filters(dat, species, geo_group, region, year)

  dat_out <- filtered$data |>
    dplyr::arrange(.data$year) |>
    dplyr::select(
      "year",
      "region",
      "losses",
      "dead",
      "discarded",
      "escaped",
      "other"
    )

  rows <- chat_rows_to_list(dat_out)

  list(
    summary = labels$chat_tools$summaries$yearly_losses,
    row_count = rows$row_count,
    rows = rows$rows,
    notes = Filter(Negate(is.na), c(filtered$notes, rows$note))
  )
}


#' chat_optional_filter_label
#' @description Render an optional species/geo_group filter value for
#' display in a tool's `summary` text - the actual value if given, or an
#' "all ..." placeholder if left unset (`NULL`), so an unscoped question
#' reads as "all species", not as a hidden default value.
#'
#' @param value the filter value, or `NULL`
#' @param all_label the label to use when `value` is `NULL`
#'
#' @noRd
chat_optional_filter_label <- function(value, all_label) {
  if (is.null(value)) all_label else value
}


#' chat_year_coverage
#' @description Compute min/max/available years for a dataset, optionally
#' filtered by species/geo_group. When either is left `NULL`, the result is
#' broken out per species/geo_group combination present in the data,
#' rather than silently collapsing to one - a "years available" question
#' should report everything unless the user actually scoped it.
#'
#' @param dat a data frame with `species`, `geo_group`, `year`
#' @param species,geo_group optional filter values
#'
#' @return a list of records, each with `species`, `geo_group`, `min_year`,
#'   `max_year`, `years`
#'
#' @noRd
chat_year_coverage <- function(dat, species = NULL, geo_group = NULL) {
  if (!is.null(species)) {
    dat <- dat |> dplyr::filter(.data$species == !!species)
  }
  if (!is.null(geo_group)) {
    dat <- dat |> dplyr::filter(.data$geo_group == !!geo_group)
  }

  summarised <- dat |>
    dplyr::mutate(year = as.integer(as.character(.data$year))) |>
    dplyr::group_by(.data$species, .data$geo_group) |>
    dplyr::summarise(
      min_year = min(.data$year, na.rm = TRUE),
      max_year = max(.data$year, na.rm = TRUE),
      years = list(sort(unique(.data$year))),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$species, .data$geo_group)

  lapply(seq_len(nrow(summarised)), function(i) {
    record <- as.list(summarised[i, , drop = FALSE])
    record$years <- record$years[[1]]
    record
  })
}


#' tool_list_regions_impl
#' @description Tool implementation: list available region names, broken
#' out by geo_group, so the model can look up valid names instead of
#' guessing them. `species`/`geo_group` are optional filters - left unset,
#' every geo_group's regions are returned rather than defaulting to one.
#'
#' @noRd
tool_list_regions_impl <- function(species = NULL, geo_group = NULL) {
  labels <- golem::get_golem_options(which = "labels")

  dat <- getOption("monthly_mortality_data_lc") |>
    dplyr::mutate(region = as.character(.data$region))

  if (!is.null(species)) {
    dat <- dat |> dplyr::filter(.data$species == !!species)
  }
  if (!is.null(geo_group)) {
    dat <- dat |> dplyr::filter(.data$geo_group == !!geo_group)
  }

  distinct_regions <- dat |>
    dplyr::distinct(.data$geo_group, .data$region) |>
    dplyr::arrange(.data$geo_group, .data$region)

  regions_by_geo_group <- split(
    distinct_regions$region,
    distinct_regions$geo_group
  )

  list(
    summary = sprintf(
      labels$chat_tools$summaries$list_regions,
      chat_optional_filter_label(species, labels$chat_tools$all_species_label),
      chat_optional_filter_label(
        geo_group,
        labels$chat_tools$all_geo_group_label
      )
    ),
    regions_by_geo_group = regions_by_geo_group
  )
}


#' tool_list_years_impl
#' @description Tool implementation: list the years with available data,
#' per dataset (the datasets do not all cover the same years) and, when
#' species/geo_group are left unset, per species/geo_group combination too
#' (real data may not cover every species/area equally, even though the
#' dummy fixtures happen to).
#'
#' @noRd
tool_list_years_impl <- function(species = NULL, geo_group = NULL) {
  labels <- golem::get_golem_options(which = "labels")

  datasets <- list(
    monthly_mortality = "monthly_mortality_data_lc",
    cumulative_mortality = "cumulative_mortality_yr_data_lc",
    cohort_mortality = "cohort_mortality_data",
    monthly_losses = "monthly_losses_data_lc",
    yearly_losses = "yearly_losses_data"
  )

  coverage <- lapply(datasets, function(dataset_name) {
    chat_year_coverage(getOption(dataset_name), species, geo_group)
  })

  list(
    summary = sprintf(
      labels$chat_tools$summaries$list_years,
      chat_optional_filter_label(species, labels$chat_tools$all_species_label),
      chat_optional_filter_label(
        geo_group,
        labels$chat_tools$all_geo_group_label
      )
    ),
    coverage = coverage
  )
}


#' build_chat_tools
#' @description Build the full list of `ellmer` tools for the data-chat
#' assistant.
#'
#' @return a list of `ellmer::tool()` (`ToolDef`) objects
#'
#' @noRd
build_chat_tools <- function() {
  config <- golem::get_golem_options(which = "config")
  labels <- golem::get_golem_options(which = "labels")
  species_values <- config$mod_top_bar$species_choices
  geo_group_values <- config$mod_top_bar$geo_group_choices

  descriptions <- labels$chat_tools$tool_descriptions
  arg_descriptions <- labels$chat_tools$arg_descriptions

  species_arg <- ellmer::type_enum(
    values = species_values,
    description = arg_descriptions$species,
    required = FALSE
  )
  geo_group_arg <- ellmer::type_enum(
    values = geo_group_values,
    description = arg_descriptions$geo_group,
    required = FALSE
  )
  region_arg <- ellmer::type_string(
    description = arg_descriptions$region,
    required = FALSE
  )
  year_arg <- ellmer::type_integer(
    description = arg_descriptions$year,
    required = FALSE
  )
  month_arg <- ellmer::type_integer(
    description = arg_descriptions$month,
    required = FALSE
  )
  species_arg_all <- ellmer::type_enum(
    values = species_values,
    description = arg_descriptions$species_all,
    required = FALSE
  )
  geo_group_arg_all <- ellmer::type_enum(
    values = geo_group_values,
    description = arg_descriptions$geo_group_all,
    required = FALSE
  )

  list(
    ellmer::tool(
      tool_monthly_mortality_impl,
      name = "monthly_mortality",
      description = descriptions$monthly_mortality,
      arguments = list(
        species = species_arg,
        geo_group = geo_group_arg,
        region = region_arg,
        year = year_arg,
        month = month_arg
      )
    ),
    ellmer::tool(
      tool_cumulative_mortality_impl,
      name = "cumulative_mortality",
      description = descriptions$cumulative_mortality,
      arguments = list(
        species = species_arg,
        geo_group = geo_group_arg,
        region = region_arg,
        year = year_arg,
        month = month_arg
      )
    ),
    ellmer::tool(
      tool_cohort_mortality_impl,
      name = "cohort_mortality",
      description = descriptions$cohort_mortality,
      arguments = list(
        species = species_arg,
        geo_group = geo_group_arg,
        region = region_arg,
        year = year_arg
      )
    ),
    ellmer::tool(
      tool_monthly_losses_impl,
      name = "monthly_losses",
      description = descriptions$monthly_losses,
      arguments = list(
        species = species_arg,
        geo_group = geo_group_arg,
        region = region_arg,
        year = year_arg,
        month = month_arg
      )
    ),
    ellmer::tool(
      tool_yearly_losses_impl,
      name = "yearly_losses",
      description = descriptions$yearly_losses,
      arguments = list(
        species = species_arg,
        geo_group = geo_group_arg,
        region = region_arg,
        year = year_arg
      )
    ),
    ellmer::tool(
      tool_list_regions_impl,
      name = "list_regions",
      description = descriptions$list_regions,
      arguments = list(
        species = species_arg_all,
        geo_group = geo_group_arg_all
      )
    ),
    ellmer::tool(
      tool_list_years_impl,
      name = "list_years",
      description = descriptions$list_years,
      arguments = list(
        species = species_arg_all,
        geo_group = geo_group_arg_all
      )
    )
  )
}
