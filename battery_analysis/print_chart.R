#package
pkg <- c("tidyverse", "tune", "readr")
lapply(pkg, library, character.only = TRUE)
theme_set(theme_minimal())

# Load data

log <- read_csv("~/opt/bat_helth_log/log.csv",
                col_types = cols(`Log date` = col_date(format = "%m/%d/%y"),
                                 `Log time` = col_time(format = "%H:%M:%S")))

# Today Battery percentage

filter.log <-
  filter(log, log$`Log date` == tail(log$`Log date`, n = 1L))

health <- filter.log$Health
tper <- filter.log$`True Percentage`
aper <- filter.log$`Apparent Percentage`
start.date <- today()  %>%  floor_date(unit = "year")  %>%  as.Date()
end.date <- today()  %>%  ceiling_date(unit = "year")  %>%  as.Date() -1

# Battery plot
tit <-
  paste0("Battery %: ",
         date())
bat.life <-
  ggplot(filter.log, aes(`Log time`, aper, col = "Apparent %")) +
  geom_line() +
  geom_line(aes(y = tper, col = "True %")) +
  geom_hline(yintercept = mean(filter.log$`Apparent Percentage`))+
  scale_x_time(limits = as_datetime(c("00:00:00", "23:59:59"))) +
  ylim(0,100) +
  labs(y = "Batery Percentage",
       x = NULL,
       title = tit,
       colour = NULL) +
  theme(legend.position = "top")

# Rate of Change Chart

rate_of_change <- filter.log %>% 
  mutate(Lag = lag(filter.log$`Apparent Percentage`),
         Lead = lead(filter.log$`Apparent Percentage`),
         ChangePercentage  = (filter.log$`Apparent Percentage`- Lag))

change_chart <- ggplot(rate_of_change, aes(`Log time`, ChangePercentage)) +
  geom_line() + 
  labs(title = "Change points",
       x = element_blank(),
       y = element_blank())

# Time series plot of the Battery health

agg <- aggregate(log$Health ~ log$`Log date`, log, mean)
dt <- agg$`log$\`Log date\``
hl <- agg$`log$Health`
df <- data.frame(dt, hl)

# Full Batlife

app <- aggregate(log$`Apparent Percentage` ~ log$`Log date`, log, mean)
ap <- app$`log$\`Apparent Percentage\``
dp <- app$`log$\`Log date\``
dd <- data.frame(dp,ap)

av.hl <-
  full_join(dd, df, join_by(dp == dt))

cycle <- read_lines("/home/kd/opt/bat_helth_log/battery_analysis/cycle_count")

bat.av.hl <-
  ggplot(av.hl, aes(dp, ap, col = "Avrage Battery Life")) +
  geom_hline(yintercept = mean(av.hl$hl)) +
  geom_hline(yintercept = max(av.hl$hl), color = 'green') +
  geom_hline(yintercept = min(av.hl$hl), color = 'red') +
  geom_hline(yintercept = mean(tail(av.hl$hl, n = 30)), color = 'blue') +
  geom_line(aes(y = hl, col = "Health"), show.legend = FALSE) +
    labs(title = paste("Battery life - Cycles:",cycle ), y = "Battery %", x = NULL,
       colour = "Battery stats")

## Logs
pdf(
  file = "/home/kd/opt/bat_helth_log/battery_helth.pdf",
  width = 16,
  height = 9,
  paper = "a4r"
)
print(bat.life)
print(change_chart)
print(bat.av.hl)

dev.off()