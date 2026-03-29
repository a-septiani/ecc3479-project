# set up the environment
install.packages(c("tidyverse", "lubridate", "readr", "languageserver", "janitor", "readxl"))
library(tidyverse)
library(lubridate)
library(readr)
library(janitor)

# define base directory and path for temperature data
regions <- c("NSW", "QLD", "SA", "TAS", "VIC")
base_dir <- "data/raw/bom_temperature"

read_region_temp <- function(region) {
  max_path <- file.path(base_dir, region, paste0(region, "_mean_max.csv"))
  min_path <- file.path(base_dir, region, paste0(region, "_mean_min.csv"))


# read and combine all mean max temperature files
  max_df <- read_csv(max_path, show_col_types = FALSE) |>
    clean_names() |>
    dplyr::transmute(
      REGION = region,
      year = as.integer(year),
      month = as.integer(month),
      mean_max_temp = as.numeric(.data$mean_maximum_temperature_c)
    )

# read and combine all mean min temperature files
  min_df <- read_csv(min_path, show_col_types = FALSE) |>
    clean_names() |>
    dplyr::transmute(
      REGION = region,
      year = as.integer(year),
      month = as.integer(month),
      mean_min_temp = as.numeric(.data$mean_minimum_temperature_c)
    )

  dplyr::inner_join(max_df, min_df, by = c("REGION", "year", "month"))
}

# combine all regions' temperature data into one data frame
monthly_temperature <- map_dfr(regions, read_region_temp) |>
  filter(year %in% 2010:2014) |>
  mutate(avg_temp = (mean_max_temp + mean_min_temp) / 2)

# save the cleaned data to a new CSV file
write_csv(monthly_temperature, "data/clean/monthly_temperature.csv")

# produce a plot of average temperature over time for each region
q <- ggplot(monthly_temperature, aes(x = as.Date(paste(year, month, "01", sep = "-")), y = avg_temp, color = REGION)) +
  geom_line() +
  labs(title = "Average Monthly Temperature by Region (2010-2014)",
       x = "Date",
       y = "Average Temperature (°C)") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1") +
  theme(legend.title = element_blank())

  print (q)

# save the plot to a file
ggsave("outputs/temperature_by_region.png", plot = q, width = 12, height = 8)
