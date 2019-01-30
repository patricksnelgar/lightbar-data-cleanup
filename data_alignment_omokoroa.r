#install.packages("anytime")
#install.packages("dplyr")

library(anytime)
library(dplyr)

omokoroa_above = read.table("..\\Omokoroa\\Lightbar_reference_lghtbr_abv_Omokoroa 17th Jan 2019.dat", sep = ",", skip = 1, header = TRUE, stringsAsFactors = FALSE)

# remove unused columns
omokoroa_above$RECNBR = NULL

lb_run1 = read.table("..\\Omokoroa\\Lightbar_trolley_lightbar_Omokoroa_run1 17th Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)
lb_run2 = read.table("..\\Omokoroa\\Lightbar_trolley_lightbar_Omokoroa_run2 17th Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)
lb_run3 = read.table("..\\Omokoroa\\Lightbar_trolley_lightbar_Omokoroa_run3 17th Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)

omokoroa_lightbar = lb_run1
omokoroa_lightbar$run_ID[1:length(lb_run1$TMSTAMP)] = "morning"

start_append = length(lb_run1$TMSTAMP) + 1
end_append = start_append + length(lb_run2$TMSTAMP) - 1
omokoroa_lightbar[start_append:end_append,] = lb_run2
omokoroa_lightbar$run_ID[start_append:end_append] = "midday"

start_append = length(omokoroa_lightbar$TMSTAMP) + 1
end_append = start_append+ length(lb_run3$TMSTAMP) - 1
omokoroa_lightbar[start_append:end_append,] = lb_run3
omokoroa_lightbar$run_ID[start_append:end_append] = "afternoon"

indexes = match(omokoroa_lightbar$TMSTAMP, omokoroa_above$TMSTAMP)

omokoroa_above = omokoroa_above[indexes,]
omokoroa_lightbar = cbind(omokoroa_lightbar, omokoroa_above)

# remove unused columns
omokoroa_lightbar$RECNBR = NULL

# clean up column names
colnames(omokoroa_lightbar)[6:7] = c("TMSTAMP_above","batt_volt_above_Avg")
colnames(omokoroa_lightbar)[9:10] = c("Sun8004_Global_Avg","Sun8004_Diffuse_Avg")

filter_IDs = count(omokoroa_lightbar, run_number) %>%
                subset(n > 5 & n < 30)
                

omokoroa = omokoroa_lightbar[omokoroa_lightbar$run_number %in% filter_IDs$run_number, ]

write.csv(omokoroa, "Omokoroa_lightbar_2019-01-17.csv", row.names=F)

calibration_IDs = count(omokoroa_lightbar, run_number) %>%
                    subset(n > 20)

omokoroa_calibration = omokoroa_lightbar[omokoroa_lightbar$run_number %in% calibration_IDs$run_number, ]
write.csv(omokoroa_calibration, file = "Omokoroa_calibration_2019-01-17.csv", row.names=F)