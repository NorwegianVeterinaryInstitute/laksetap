plot_cumulative_mortality <- function(dat,
                                      Species = "salmon",
                                      Year = "2025", 
                                      Area = "3"
                                      ) {
    plot_data <- dat |> filter(species == Species,
                               year == Year,
                               region == Area
                               )
    p <- ggplot(plot_data, aes(month, mort, group = year, colour = year)) +
        geom_line(na.rm = FALSE, size=3)  +
        theme(text=element_text(size=30)) +
        geom_ribbon(aes(ymin = LCI  , ymax = UCI, fill = year),  alpha = 0.4, color = NA) + 
        #scale_x_discrete(labels = acc_mort$month_num) +
        labs(y = "Dødelighet (%)")+
        theme(axis.title.y = element_text(20)) +
        theme(axis.title.x = element_blank()) +
        theme(axis.text.y = element_text(15)) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        ggtitle(paste0('Dødelighet (%) i PO ', Area)
        )
    
    p
    
}
plot_cumulative_mortality(dat = create_dummy_cumulative_mort(geo_group = "area"),
                          Area = 5, 
                          Year = 2025,
                          Species = "salmon"
                          )
