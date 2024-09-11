#package

library(tidyverse)
library(tune)

# Remove Variables

rm(list = ls())
graphics.off()

# Load data

source("~/opt/bat_helth_log/battery_analysis/Log_loder.R")

# Today Battery percentage

filter.log <-
  filter(log, log$`Log date` == tail(log$`Log date`, n = 1L))

health <- filter.log$Health
tper <- filter.log$`True Percentage`
aper <- filter.log$`Apparent Percentage`
start.date <- today() |> floor_date(unit = "year") |> as.Date()
end.date <- today() |> ceiling_date(unit = "year") |> as.Date() -1

# Battery plot
tit <-
  paste0("Battery Percantage: ",
         date())
bat.life <-
  ggplot(filter.log, aes(`Log time`, aper, col = "Apparent Percentage")) +
  geom_line() +
  geom_line(aes(y = tper, col = "True Percentage")) +
  labs(y = "Batery Percentage",
       x = NULL,
       title = tit,
       colour = NULL) +
  ylim(0, 100) +
  theme_minimal() +
  theme(legend.position = "top")


# Time series plot of the Battery health

agg <- aggregate(log$Health ~ log$`Log date`, log, mean)
dt <- agg$`log$\`Log date\``
hl <- round(agg$`log$Health`)
df <- data.frame(dt, hl)

# bat.health <-
#   ggplot(df, aes(dt, hl)) +
#   geom_line() +
#   ylim(1, 100) +
#   labs(title = "Battery health", y = "Health %", x = "Date") +
#   theme_minimal()

# Full Batlife


app <- aggregate(log$`Apparent Percentage` ~ log$`Log date`, log, mean)
ap <- round(app$`log$\`Apparent Percentage\``)
dp <- app$`log$\`Log date\``
dd <- data.frame(dp,ap)

# bat.agg <-
#   bat.agg <-
#   ggplot(dd, aes(dp, ap)) +
#   geom_line() +
#   ylim(1, 100) +
#   labs(title = "Battery life mean", y = "Battery % Mean", x = "Date") +
#   theme_minimal()

av.hl <-
  full_join(dd, df, join_by(dp == dt))

bat.av.hl <-
  ggplot(av.hl, aes(dp, ap, col = "Avrage Battery Life")) +
  geom_smooth(method = 'loess', se = TRUE, formula = "y~x")+
  geom_line()+
  geom_line(aes(y = hl, col = "Health")) +
  geom_hline(yintercept = 80)+
  ylim(0, 100) +
  labs(title = "Battery life", y = "Battery %", x = NULL,
       colour = "Battery stats") +
  theme_minimal() +
  theme(legend.position = "top")

## Logs
pdf(
  file = "/home/kd/opt/bat_helth_log/battery_helth.pdf",
  width = 16,
  height = 9,
  paper = "a4r"
)
print(bat.life)
print(bat.av.hl)
# print(bat.health)
# print(bat.agg)
dev.off()

# View(log)
# View(filter.log)