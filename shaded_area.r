install.packages("anytime")

library(anytime)

whangarei_above = read.table("Whangarei\\lightbar_ref_lghtbr_abv_Whangarei_ 22nd Jan 2019.dat", sep = ",", skip = 1, header = TRUE, stringsAsFactors = FALSE)
tmp = read.table("Whangarei\\lightbar_ref_lghtbr_abv_Whangarei_ 22nd Jan 2019.dat", sep = ",", skip = 1, header = TRUE, stringsAsFactors = FALSE)

#start_append = length(whangarei_above$TMSTAMP) + 1
#end_append = start_append +  length(tmp$TMSTAMP)-1

#whangarei_above[start_append:end_append,] = tmp

lb_run1 = read.table("Whangarei\\Lightbar_trolley_lightbar_Whangarei_run1_22nd Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)
lb_run2 = read.table("Whangarei\\Lightbar_trolley_lightbar_Whangarei_run2_22nd Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)
lb_run3 = read.table("Whangarei\\Lightbar_trolley_lightbar_Whangarei_run3_22nd Jan 2019.dat", skip = 1, sep = ",", header = TRUE, stringsAsFactors = FALSE)

start_append = length(lb_run1$TMSTAMP) + 1
end_append = start_append + length(lb_run2$TMSTAMP) - 1

whangarei_lightbar = lb_run1
whangarei_lightbar[start_append:end_append,] = lb_run2

start_append = length(whangarei_lightbar$TMSTAMP) + 1
end_append = start_append+ length(lb_run3$TMSTAMP) - 1

whangarei_lightbar[start_append:end_append,] = lb_run3

indexes = match(whangarei_lightbar$TMSTAMP, whangarei_above$TMSTAMP)

whangarei_above = whangarei_above[indexes,]
whangarei_lightbar = cbind(whangarei_lightbar, whangarei_above)
write.csv(whangarei_lightbar, "Whanagrei_lightbar_2019-01-22.csv", row.names=F)