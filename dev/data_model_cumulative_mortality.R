create_dummy_cumulative_mort <- function(geo_group) {
    species <- c('salmon', 'rainbowtrout')
    
    current_year <- format(Sys.Date(), "%Y")
    current_year <- format(Sys.Date(), "%Y")
    months <- expand.grid(year = 2020:current_year, month = 1:12)
    date_vector <- as.Date(paste(months$year, months$month, "01", sep = "-")) |> sort()
    date_vector
    region_salmon = c(sort(c("1 & 2", 3:11, "12 & 13",
               "Agder & Rogaland", "Finnmark", "Møre og Romsdal",
               "Nordland", "Norway", "Troms", "Trøndelag", "Vestland")) 
               )
    region_RBtrout = c(sort(c("2 & 3", "4", "5, 6, & 9",
                             "Rogaland & Vestland", "Møre og Romsdal, Trøndelag,  Nordland, & Troms", "Norway")) 
    )
    
    library(dplyr)
    
    df_salmon <- expand.grid(species = "salmon", date = date_vector, region = region_salmon) |>
        mutate(
            mort_count = rbinom(n(), size = 100, prob = 0.005),
            mort = mort_count / 100
        ) |>
        rowwise() |>
        mutate(
            LCI = binom.test(mort_count, 100)$conf.int[1],
            UCI = binom.test(mort_count, 100)$conf.int[2]
        ) |>
        ungroup() |> 
        mutate(year = substring(date, 1, 4)) |> 
        arrange(date) |> 
        group_by(species, region, year) |> 
        mutate(mort = cumsum(mort)) |> 
        mutate(LCI = cumsum(LCI)) |> 
        mutate(UCI = cumsum(UCI)) |> ungroup()|> 
        mutate(
            geo_group = case_when(
                region %in% c("1 & 2", 3:11, "12 & 13") ~ "area",
                region %in% c("Agder & Rogaland", "Finnmark", "Møre og Romsdal", "Nordland", "Troms", "Trøndelag", "Vestland") ~ "county",
                region == "Norway" ~ "country",
                TRUE ~ NA_character_  # fallback for unexpected values
            )
        ) |> 
        dplyr::select(species, year, month = date, geo_group, region, mort, LCI, UCI)
        
 #print(df_salmon, n = 10)
 
 df_RBtrout <- expand.grid(species = "rainbowtrout", date = date_vector, region = region_RBtrout) |>
     mutate(
         mort_count = rbinom(n(), size = 10, prob = 0.005),
         mort_count = cumsum(mort_count),
         mort = mort_count / 10
     ) |>
     rowwise() |>
     mutate(
         LCI = binom.test(mort_count, 100)$conf.int[1],
         UCI = binom.test(mort_count, 100)$conf.int[2]
     ) |>
     ungroup() |> 
     mutate(year = substring(date, 1, 4)) |> 
     arrange(date) |> 
     group_by(species, region, year) |> 
     mutate(mort = cumsum(mort)) |> 
     mutate(LCI = cumsum(LCI)) |> 
     mutate(UCI = cumsum(UCI)) |> ungroup() |> 
     mutate(
         geo_group = case_when(
             region %in% c("2 & 3", "4", "5, 6, & 9") ~ "area",
             region %in% c("Rogaland & Vestland", "Møre og Romsdal, Trøndelag,  Nordland, & Troms") ~ "county",
             region == "Norway" ~ "country",
             TRUE ~ NA_character_  # fallback for unexpected values
         )
     ) |> 
     dplyr::select(species, year, month = date, geo_group, region, mort, LCI, UCI)
 
 dummy_cumul_mort <- bind_rows(df_salmon, df_RBtrout)
 
 #print(dummy_cumul_mort, n = 10)
 choice <- geo_group
 data_out <- dummy_cumul_mort |> 
     filter(geo_group %in% choice)

 return(data_out)
}
cumulative_mortality_dummy_data <- create_dummy_cumulative_mort(geo_group = "area")

cumulative_mortality_dummy_data |> dim()
print(cumulative_mortality_dummy_data, n = 20)

# saveRDS(
#     cumulative_mortality_dummy_data,
#     file = "inst/extdata/cumulative_mortality_dummy_data.Rds"
# )