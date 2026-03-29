# set up the environment
install.packages(c("tidyverse", "lubridate", "readr", "languageserver", "janitor", "readxl"))
library(tidyverse)
library(lubridate)
library(readr)

# list all the files in the directory
all_dmd_prc_files <- list.files(
  "data/raw/aemo_demand_price",
  pattern = "\\.csv$",
  recursive = TRUE,
  full.names = TRUE
)
length(all_dmd_prc_files)
head(all_dmd_prc_files)

# read and combine all the files into one data frame
one_file <- read_csv(all_dmd_prc_files[1])
glimpse(one_file)
all_data <- map_dfr(all_dmd_prc_files, read_csv)
glimpse(all_data)
head(all_data)
tail(all_data)
anyNA(all_data)

# create month and year columns
all_data <- all_data |>
  select(REGION, SETTLEMENTDATE, TOTALDEMAND, RRP)
all_data <- all_data |>
  mutate(SETTLEMENTDATE = ymd_hms(SETTLEMENTDATE))
all_data <- all_data |>
  mutate(
    year = year(SETTLEMENTDATE),
    month = month(SETTLEMENTDATE)
  )
glimpse(all_data)

# average demand and price by month and region
monthly_demand_price <- all_data |>
  group_by(REGION, year, month) |>
  summarise(
    avg_demand = mean(TOTALDEMAND, na.rm = TRUE),
    avg_price = mean(RRP, na.rm = TRUE)
  ) |>
  ungroup()
glimpse(monthly_demand_price)
head(monthly_demand_price)

# save the cleaned data to a new CSV file
write_csv(monthly_demand_price, "data/clean/monthly_demand_price.csv")

# produce a plot of average demand and price over time for each region with dual y-axis
scale_factor <- max(monthly_demand_price$avg_demand, na.rm = TRUE) / max(monthly_demand_price$avg_price, na.rm = TRUE)

p <- ggplot(monthly_demand_price, aes(x = as.Date(paste(year, month, "01", sep = "-")))) +
  geom_line(aes(y = avg_demand, color = REGION, linetype = "Demand")) +
  geom_line(aes(y = avg_price * scale_factor, color = REGION, linetype = "Price")) +
  geom_vline(xintercept = as.Date("2012-07-01"), linetype = "dashed", color = "black", size = 1) +
  annotate("text", x = as.Date("2012-07-01"), y = Inf, label = "Carbon Pricing Policy", 
           vjust = 1.5, hjust = -0.1, size = 3) +
  scale_y_continuous(
    name = "Average Demand (MWh)",
    sec.axis = sec_axis(trans = ~./scale_factor, name = "Average Price ($/MWh)")
  ) +
  labs(
    title = "Average Demand and Price Over Time by Region",
    x = "Date",
    color = "Region",
    linetype = "Metric"
  ) +
  theme_minimal()

print(p)
ggsave("outputs/demand_price_by_region.png", plot = p, width = 12, height = 8)
