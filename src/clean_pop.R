# set up environment
library(tidyverse)
library(lubridate)
library(readxl)
library(janitor)

# read the population data from the Excel file
all_pop <- read_excel("data/raw/abs_population/OZ_pop.xlsx", sheet = "Data1")
print (all_pop, n = 100)

# we need to change the format for years because it read as random numbers.
# only keep data from 2009-12 to 2014-12, and NEM states columns.
# must check the original data outside of R to confirm the correct rows and columns to keep.
all_pop <- all_pop[-c(1:123,145:187), -c(2:19, 24, 26:28)]
print (all_pop, n = 100)
head(all_pop)

# create a year and month column from the first column, which contains quarterly dates
colnames(all_pop)[1] <- "date"
n_rows <- nrow(all_pop)

all_pop$date <- seq(from = as.Date("2009-12-01"), by = "3 months", length.out = n_rows) %>% 
  format("%Y-%m")

all_pop <- all_pop %>%
  separate(date, into = c("year", "month"), sep = "-")

# rename the region columns to match the other datasets
all_pop <- all_pop %>%
  rename(NSW = 3, VIC = 4, QLD = 5, SA = 6, TAS = 7)

# pivot the data to long format for easier plotting
all_pop <- all_pop %>%
  pivot_longer(cols = c(NSW, VIC, QLD, SA, TAS),
               names_to = "region",
               values_to = "population")

# Convert population, year, and month to numeric
all_pop$population <- as.numeric(all_pop$population)
all_pop$year <- as.numeric(all_pop$year)
all_pop$month <- as.numeric(all_pop$month)

# save the cleaned data to a new CSV file
write_csv(all_pop, "data/clean/quarterly_population.csv")

#produce a plot of population over time for each region
r <- ggplot(all_pop, aes(x = as.Date(paste(year, month, "01",
sep = "-")), y = population, color = region)) +
  geom_line() +
  labs(title = "Population over Time by Region",
       x = "Date",
       y = "Population") +
  theme_minimal()

print(r)

#save the plot as a PNG file
ggsave ("outputs/population_by_region.png", plot = r, width = 12, height = 8)
