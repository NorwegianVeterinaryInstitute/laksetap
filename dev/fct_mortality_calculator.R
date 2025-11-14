# The code below has dummy data and functions to calculate mortality.
# We also provide a calculator in Excel for people to use with their own data.
# The calculator itself is not part of the app because we don't want to
# handle company or farm level data in the app and potentially run into legal
# or security issues.
library(ggplot2)
library(tibble)
library(patchwork)

dat_1 <- tibble::tribble(
  ~month    , ~beginning_count , ~end_count , ~dead_count ,
  "2025-01-01" , 1000L            , 950L       , 50L         ,
  "2025-02-01" , 1000L            , 950L       , 50L         ,
  "2025-03-01" , 1000L            , 950L       , 50L         ,
  "2025-04-01" , 1000L            , 950L       , 50L         ,
  "2025-05-01" , 1000L            , 950L       , 50L         ,
  "2025-06-01" , 1000L            , 950L       , 50L         ,
  "2025-07-01" , 1000L            , 950L       , 50L
)

dat_2 <- tibble::tribble(
  ~month    , ~beginning_count , ~end_count , ~dead_count ,
  "2025-01-01" , 1000L            ,  950L      ,  50L        ,
  "2025-02-01" , 1100L            ,  750L      , 100L        ,
  "2025-03-01" ,  900L            ,  650L      , 800L        ,
  "2025-04-01" , 1200L            ,  950L      , 300L        ,
  "2025-05-01" , 1000L            ,  550L      , 200L        ,
  "2025-06-01" ,  600L            ,  250L      , 150L        ,
  "2025-07-01" , 1500L            , 1150L      , 120L
)

calculate_mortality <- function(dat){
  
  dat$month <- as.Date(dat$month)
  dat$ar_count <- (dat$beginning_count + dat$end_count) / 2
  dat$mort_rate <- dat$dead_count / dat$ar_count
  dat$mort_risk <- 1 - exp(-dat$mort_rate)
  dat$cum_risks <- 1 - exp(-cumsum(-log(1 - dat$mort_risk)))
  
  dat

}

plot_monthly_mortality <- function(dat){
  ggplot(dat) +
    aes(x = month, y = mort_risk) +
    geom_bar(stat = "identity", fill = "steelblue") +
    labs(title = "Monthly Mortality Rate",
         x = "Month",
         y = "Mortality Rate") +
    theme_minimal()
  
}

plot_cummulative_mortality <- function(dat){
  ggplot(dat) +
    aes(x = month, y = cum_risks) +
    geom_line() +
    labs(title = "Cummulative Mortality Rate",
         x = "Month",
         y = "Mortality Rate") +
    theme_minimal()
}


p1 <- calculate_mortality(dat_1) |> plot_monthly_mortality()
p2 <- calculate_mortality(dat_1) |> plot_cummulative_mortality()
p3 <- calculate_mortality(dat_2) |> plot_monthly_mortality()
p4 <- calculate_mortality(dat_2) |> plot_cummulative_mortality()

p1 + p2 + p3 + p4
