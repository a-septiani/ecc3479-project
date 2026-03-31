# set up the environment
library(tidyverse)
library(readr)
library(janitor)
library(lubridate)

# read the cleaned population data
all_pop <- read_csv("data/clean/quarterly_population.csv")
# read the cleaned energy mix data
energy_mix <- read_csv("data/clean/energy_mix.csv") 
# read the cleaned electricity demand and price data
elec_price <- read_csv("data/clean/monthly_demand_price.csv")
# read the cleaned temperature data
temperature <- read_csv("data/clean/monthly_temperature.csv")

# standardize region column and row names before joining
energy_mix <- energy_mix %>%
  rename(REGION = Region)

all_pop <- all_pop %>%
  rename(REGION = region)

elec_price <- elec_price %>%
  mutate(
    REGION = recode(
      REGION,
      "NSW1" = "NSW",
      "VIC1" = "VIC",
      "QLD1" = "QLD",
      "SA1" = "SA",
      "TAS1" = "TAS"
    )
  )

# merge the datasets by region and date
merged_data <- elec_price %>%
  left_join(energy_mix, by = c("REGION", "year")) %>%
  left_join(all_pop, by = c("REGION", "year", "month")) %>%
  left_join(temperature, by = c("REGION", "year", "month"))

merged_data <- merged_data %>%
  rename(
    coal_share = `Coal Share`,
    black_coal = `Black Coal`,
    brown_coal = `Brown Coal`,
    total_energy = `Total energy`,
    region = REGION
  )

# delete NA rows that may have been introduced by the merge
# dropping NA in population as population is a quarterly variable and will be missing for some months
#dropping NA in coal share as it doesn't have 2015 data to complete price and demand data
 merged_data <- merged_data %>% drop_na()

print (merged_data, n = 100)

write_csv(merged_data, "data/clean/merged_data.csv")

# plot the relationship between coal share, temperature, price, population and electricity demand
plot_data <- merged_data %>%
  mutate(
    date = make_date(year, month, 1),
    coal_share_norm = (coal_share - min(coal_share, na.rm = TRUE)) / (max(coal_share, na.rm = TRUE) - min(coal_share, na.rm = TRUE)),
    temp_norm = (avg_temp - min(avg_temp, na.rm = TRUE)) / (max(avg_temp, na.rm = TRUE) - min(avg_temp, na.rm = TRUE)),
    price_norm = (avg_price - min(avg_price, na.rm = TRUE)) / (max(avg_price, na.rm = TRUE) - min(avg_price, na.rm = TRUE)),
    pop_norm = (population - min(population, na.rm = TRUE)) / (max(population, na.rm = TRUE) - min(population, na.rm = TRUE)),
    demand_norm = (avg_demand - min(avg_demand, na.rm = TRUE)) / (max(avg_demand, na.rm = TRUE) - min(avg_demand, na.rm = TRUE))
  )

# create the plot with normalized variables (faceted by region)
d <- ggplot(plot_data, aes(x = date)) +
  geom_line(aes(y = coal_share_norm, color = "Coal Share"), na.rm = TRUE, size = 0.8) +
  geom_line(aes(y = temp_norm, color = "Temperature"), na.rm = TRUE, size = 0.8) +
  geom_line(aes(y = price_norm, color = "Price"), na.rm = TRUE, size = 0.8) +
  geom_line(aes(y = pop_norm, color = "Population"), na.rm = TRUE, size = 0.8) +
  geom_line(aes(y = demand_norm, color = "Demand"), na.rm = TRUE, size = 0.8) +
  geom_vline(xintercept = as.Date("2012-07-01"), linetype = "dashed", color = "black", size = 0.5) +
  annotate("text", x = as.Date("2012-07-01"), y = 0.95, label = "Carbon Pricing", 
           vjust = 1.5, hjust = -0.1, size = 2.5) +
  facet_wrap(~region, nrow = 2) +
  scale_y_continuous(
    name = "Normalized Values (0-1)",
    limits = c(0, 1)
  ) +
  scale_color_manual(
    name = "Metric",
    values = c(
      "Coal Share" = "#0072B2",
      "Temperature" = "#D55E00",
      "Price" = "#009E73",
      "Population" = "#CC79A7",
      "Demand" = "#000000"
    )
  ) +
  labs(
    title = "Coal Share, Temperature, Price, Population, and Demand Over Time by Region",
    x = "Date"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
    legend.position = "bottom",
    strip.text = element_text(face = "bold", size = 10)
  )

print(d)
ggsave("outputs/analysis_metrics_by_region.png", plot = d, width = 14, height = 10)
