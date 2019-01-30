#install.packages("anytime")
#install.packages("dplyr")

library(anytime)
library(dplyr)

pukenui_above = read.table("..\\Pukenui\\Lightbar_reference_lghtbr_abv_Pukenui 23rd Jan 2019.dat", sep = ",", skip = 1, header = TRUE, stringsAsFactors = FALSE)

# remove unused columns
pukenui_above$RECNBR = NULL

lb_run1 = read.table("..\\Pukenui\\Lightbar_trolley_lightbar_Pukenui_run1 23rd Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)
lb_run2 = read.table("..\\Pukenui\\Lightbar_trolley_lightbar_Pukenui_run2 23rd Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)
lb_run3 = read.table("..\\Pukenui\\Lightbar_trolley_lightbar_Pukenui_run3 23rd Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)

pukenui_lightbar = lb_run1
pukenui_lightbar$run_ID[1:length(lb_run1$TMSTAMP)] = "morning"

start_append = length(lb_run1$TMSTAMP) + 1
end_append = start_append + length(lb_run2$TMSTAMP) - 1
pukenui_lightbar[start_append:end_append,] = lb_run2
pukenui_lightbar$run_ID[start_append:end_append] = "midday"

start_append = length(pukenui_lightbar$TMSTAMP) + 1
end_append = start_append+ length(lb_run3$TMSTAMP) - 1
pukenui_lightbar[start_append:end_append,] = lb_run3
pukenui_lightbar$run_ID[start_append:end_append] = "afternoon"

indexes = match(pukenui_lightbar$TMSTAMP, pukenui_above$TMSTAMP)

pukenui_above = pukenui_above[indexes,]
pukenui_lightbar = cbind(pukenui_lightbar, pukenui_above)

# remove unused columns
pukenui_lightbar$RECNBR = NULL

# clean up column names
colnames(pukenui_lightbar)[6:7] = c("TMSTAMP_above","batt_volt_above_Avg")
colnames(pukenui_lightbar)[9:10] = c("Sun8004_Global_Avg","Sun8004_Diffuse_Avg")

filter_IDs = count(pukenui_lightbar, run_number) %>%
                subset(n > 5 & n < 30)
                

pukenui = pukenui_lightbar[pukenui_lightbar$run_number %in% filter_IDs$run_number, ]

write.csv(pukenui, "Pukenui_lightbar_2019-01-23.csv", row.names=F)

calibration_IDs = count(pukenui_lightbar, run_number) %>%
                    subset(n > 20)

pukenui_calibration = pukenui_lightbar[pukenui_lightbar$run_number %in% calibration_IDs$run_number, ]
write.csv(pukenui_calibration, file = "Pukenui_calibration_2019-01-23.csv", row.names=F)