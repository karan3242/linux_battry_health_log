library(readr)
log <- read_csv("~/opt/bat_helth_log/log.csv", 
                       col_types = cols(`Log date` = col_date(format = "%m/%d/%y"), 
                                                  `Log time` = col_time(format = "%H:%M:%S")))
# View(log)
