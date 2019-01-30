#install.packages("anytime")
#install.packages("dplyr")

library(anytime)
library(dplyr)

whangarei_above = read.table("..\\Whangarei\\lightbar_ref_lghtbr_abv_Whangarei_ 22nd Jan 2019.dat", sep = ",", skip = 1, header = TRUE, stringsAsFactors = FALSE)

# remove unused columns
whangarei_above$RECNBR = NULL

lb_run1 = read.table("..\\Whangarei\\Lightbar_trolley_lightbar_Whangarei_run1_22nd Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)
lb_run2 = read.table("..\\Whangarei\\Lightbar_trolley_lightbar_Whangarei_run2_22nd Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)
lb_run3 = read.table("..\\Whangarei\\Lightbar_trolley_lightbar_Whangarei_run3_22nd Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)

whangarei_lightbar = lb_run1
whangarei_lightbar$run_ID[1:length(lb_run1$TMSTAMP)] = "morning"

start_append = length(lb_run1$TMSTAMP) + 1
end_append = start_append + length(lb_run2$TMSTAMP) - 1
whangarei_lightbar[start_append:end_append,] = lb_run2
whangarei_lightbar$run_ID[start_append:end_append] = "midday"

start_append = length(whangarei_lightbar$TMSTAMP) + 1
end_append = start_append+ length(lb_run3$TMSTAMP) - 1
whangarei_lightbar[start_append:end_append,] = lb_run3
whangarei_lightbar$run_ID[start_append:end_append] = "afternoon"

indexes = match(whangarei_lightbar$TMSTAMP, whangarei_above$TMSTAMP)

whangarei_above = whangarei_above[indexes,]
whangarei_lightbar = cbind(whangarei_lightbar, whangarei_above)

# remove unused columns
whangarei_lightbar$RECNBR = NULL

# clean up column names
colnames(whangarei_lightbar)[6:7] = c("TMSTAMP_above","batt_volt_above_Avg")
colnames(whangarei_lightbar)[9:10] = c("Sun8004_Global_Avg","Sun8004_Diffuse_Avg")

filter_IDs = count(whangarei_lightbar, run_number) %>%
                subset(n > 5 & n < 30)
                

whangarei = whangarei_lightbar[whangarei_lightbar$run_number %in% filter_IDs$run_number, ]

write.csv(whangarei, "Whangarei_lightbar_2019-01-22.csv", row.names=F)

calibration_IDs = count(whangarei_lightbar, run_number) %>%
                    subset(n > 20)

whangarei_calibration = whangarei_lightbar[whangarei_lightbar$run_number %in% calibration_IDs$run_number, ]
write.csv(whangarei_calibration, file = "Whangarei_calibration_2019-01-22.csv", row.names=F)