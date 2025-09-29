load_data <-function(){
laksetap_board <- pins::board_connect()

losses <- pins::pin_read(laksetap_board, "vi2451/losses_and_mortality_yearly_data")
losses_monthly_data <- pins::pin_read(laksetap_board, "vi2451/losses_monthly_data")
mortality_rates_monthly_data <- pins::pin_read(laksetap_board, "vi2451/mortality_rates_monthly_data")
mortality_cohorts_data <- pins::pin_read(laksetap_board, "vi2451/mortality_cohorts_data")

options(losses = losses)
options(losses_monthly_data = losses_monthly_data)
options(mortality_cohorts_data = mortality_cohorts_data)
options(mortality_rates_monthly_data = mortality_rates_monthly_data)
}