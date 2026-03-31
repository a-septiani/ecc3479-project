# set up environment
library(tidyverse)
library(lubridate)
library(readr)
library(janitor)

# read the cleaned merged data
merged_data <- read_csv("data/clean/merged_data.csv")  

# run a simple linear regression to analyze the relationship between electricity demand and coal share, controlling for population and temperature, price
model <- lm(avg_demand ~ `Coal Share` + population + avg_temp + avg_price, data = merged_data)
print (model)
summary(model)

# robustness check: run the regression separately for each region
regions <- unique(merged_data$REGION)
for (region in regions) {
  cat("Region:", region, "\n")
  region_data <- merged_data %>% filter(REGION == region)
  region_model <- lm(avg_demand ~ `Coal Share` + population + avg_temp + avg_price, data = region_data)
  print (region_model)
  summary(region_model)
  cat("\n")
}

# Before/after July 2012 model:
# tests whether demand changed differently after July 2012 in higher coal-share regions.
analysis_data <- merged_data %>%
  mutate(
    date = make_date(year, month, 1),
    post_jul2012 = if_else(date >= as.Date("2012-07-01"), 1, 0)
  )

# Coal Share is region-level in the cleaned energy file; carry that region value across months.
coal_share_map <- analysis_data %>%
  group_by(REGION) %>%
  summarise(coal_share_region = first(na.omit(`Coal Share`)), .groups = "drop")

analysis_data <- analysis_data %>%
  left_join(coal_share_map, by = "REGION") %>%
  mutate(`Coal Share` = coalesce(`Coal Share`, coal_share_region)) %>%
  select(-coal_share_region)

# Population is quarterly, so keep rows where controls are observed.
analysis_data <- analysis_data %>%
  filter(!is.na(population), !is.na(avg_temp), !is.na(avg_price), !is.na(`Coal Share`))

policy_model <- lm(
  avg_demand ~ post_jul2012 * `Coal Share` + population + avg_temp + avg_price + factor(REGION) + factor(month),
  data = analysis_data
)

cat("\nBefore/After July 2012 model\n")
print(policy_model)
print(summary(policy_model))

# DID model: high coal-share states (NSW/VIC/QLD) vs low coal-share states (SA/TAS)
did_data <- analysis_data %>%
  mutate(treated = if_else(REGION %in% c("NSW", "VIC", "QLD"), 1, 0))

did_model <- lm(
  avg_demand ~ treated * post_jul2012 + population + avg_temp + avg_price + factor(REGION) + factor(month),
  data = did_data
)

cat("\nDifference-in-Differences model (high coal share vs low coal share)\n")
print(did_model)
print(summary(did_model))

