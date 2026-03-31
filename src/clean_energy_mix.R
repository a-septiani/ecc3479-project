# set up environment
library(tidyverse)
library(lubridate)
library(readxl)
library(janitor)

# NSW energy mix
# read the population data from the Excel file
NSW_energy <- read_excel("data/raw/energy_mix/Energy_Stats_2025.xlsx", sheet = "NSW FY")
print (NSW_energy, n = 100)

# only keep the relevant rows and columns for coal and total energy
NSW_energy <- NSW_energy[c(3, 6, 7, 23), c(1:7)]

NSW_energy <- row_to_names(NSW_energy, row_number = 1)
names(NSW_energy)[1] <- "Energy"

# pivot the data to long format for easier plotting
NSW_energy <- NSW_energy %>%
  pivot_longer(cols = c(`2008-09`, `2009-10`, `2010-11`, `2011-12`, `2012-13`, `2013-14`),
               names_to = "date",
               values_to = "GWh")

# convert GWh to numeric and clean up the Energy column
# energy is calculated based on financial year, so the date is recoded to calendar year for easier merging later. For example, 2009-10 is recoded to 2010.
NSW_energy$GWh <- as.numeric(NSW_energy$GWh)

NSW_energy <- NSW_energy %>%
  mutate(
    Energy = str_squish(str_to_lower(Energy)),
    Energy = case_when(
      Energy == "total" ~ "Total energy",
      Energy == "brown coal" ~ "Brown Coal",
      Energy == "black coal" ~ "Black Coal",
      TRUE ~ NA_character_
    ),
    date = recode(date, "2008-09" = "2009", "2009-10" = "2010", "2010-11" = "2011", "2011-12" = "2012", "2012-13" = "2013", "2013-14" = "2014")
  ) %>%
  filter(!is.na(Energy)) %>%
  pivot_wider(names_from = Energy, values_from = GWh)

# because coal share is 0 in some regions, replace NA with 0 for coal columns before calculating coal share.
# For example, NSW has no brown coal, so its brown coal share should be 0, not NA.
# calculating coal share and adding a region column for merging later.
NSW_energy <- NSW_energy %>%
  mutate(`Brown Coal` = replace_na(`Brown Coal`, 0),
    Region = "NSW",
    `Coal Share` = (`Brown Coal` + `Black Coal`) / `Total energy`
  )

# VIC energy mix
# read the population data from the Excel file
VIC_energy <- read_excel("data/raw/energy_mix/Energy_Stats_2025.xlsx", sheet = "VIC FY")
print (VIC_energy, n = 100)

# only keep the relevant rows and columns for coal and total energy
VIC_energy <- VIC_energy[c(3, 6, 7, 23), c(1:7)]

VIC_energy <- row_to_names(VIC_energy, row_number = 1)
names(VIC_energy)[1] <- "Energy"

# pivot the data to long format for easier plotting
VIC_energy <- VIC_energy %>%
  pivot_longer(cols = c(`2008-09`, `2009-10`, `2010-11`, `2011-12`, `2012-13`, `2013-14`),
               names_to = "date",
               values_to = "GWh")

# convert GWh to numeric and clean up the Energy column
# energy is calculated based on financial year, so the date is recoded to calendar year for
# easier merging later. For example, 2009-10 is recoded to 2010.
VIC_energy$GWh <- as.numeric(VIC_energy$GWh)

VIC_energy <- VIC_energy %>%
  mutate(
    Energy = str_squish(str_to_lower(Energy)),
    Energy = case_when(
      Energy == "total" ~ "Total energy",
      Energy == "brown coal" ~ "Brown Coal",
      Energy == "black coal a" ~ "Black Coal",
      TRUE ~ NA_character_
    ),
    date = recode(date, "2008-09" = "2009", "2009-10" = "2010", "2010-11" = "2011", "2011-12" = "2012", "2012-13" = "2013", "2013-14" = "2014")
  ) %>%
  filter(!is.na(Energy)) %>%
  pivot_wider(names_from = Energy, values_from = GWh)

# because coal share is 0 in some regions, replace NA with 0 for coal columns before calculating coal share.
# For example, VIC has no black coal, so its black coal share should be 0, not NA.
# calculating coal share and adding a region column for merging later.
VIC_energy <- VIC_energy %>%
  mutate(`Black Coal` = replace_na(`Black Coal`, 0),
    Region = "VIC",
    `Coal Share` = (`Brown Coal` + `Black Coal`) / `Total energy`
  )

# QLD energy mix
# read the population data from the Excel file
QLD_energy <- read_excel("data/raw/energy_mix/Energy_Stats_2025.xlsx", sheet = "QLD FY")
print(QLD_energy, n = 100)

# only keep the relevant rows and columns for coal and total energy
QLD_energy <- QLD_energy[c(3, 6, 7, 23), c(1:7)]

QLD_energy <- row_to_names(QLD_energy, row_number = 1)
names(QLD_energy)[1] <- "Energy"

# pivot the data to long format for easier plotting
QLD_energy <- QLD_energy %>%
  pivot_longer(cols = c(`2008-09`, `2009-10`, `2010-11`, `2011-12`, `2012-13`, `2013-14`),
               names_to = "date",
               values_to = "GWh")

# convert GWh to numeric and clean up the Energy column
# energy is calculated based on financial year, so the date is recoded to calendar year for
# easier merging later. For example, 2009-10 is recoded to 2010.
QLD_energy$GWh <- as.numeric(QLD_energy$GWh)

QLD_energy <- QLD_energy %>%
  mutate(
    Energy = str_squish(str_to_lower(Energy)),
    Energy = case_when(
      Energy == "total" ~ "Total energy",
      Energy == "brown coal" ~ "Brown Coal",
      Energy == "black coal" ~ "Black Coal",
      TRUE ~ NA_character_
    ),
    date = recode(date, "2008-09" = "2009", "2009-10" = "2010", "2010-11" = "2011", "2011-12" = "2012", "2012-13" = "2013", "2013-14" = "2014")
  ) %>%
  filter(!is.na(Energy)) %>%
  pivot_wider(names_from = Energy, values_from = GWh)

# because coal share is 0 in some regions, replace NA with 0 for coal columns before calculating coal share.
# For example, QLD has no brown coal, so its brown coal share should be 0, not NA.
# calculating coal share and adding a region column for merging later.
QLD_energy <- QLD_energy %>%
  mutate(`Brown Coal` = replace_na(`Brown Coal`, 0),
    Region = "QLD",
    `Coal Share` = (`Brown Coal` + `Black Coal`) / `Total energy`
  )

# SA energy mix
# read the population data from the Excel file
SA_energy <- read_excel("data/raw/energy_mix/Energy_Stats_2025.xlsx", sheet = "SA FY")
print (SA_energy, n = 100)

# only keep the relevant rows and columns for coal and total energy
SA_energy <- SA_energy[c(3, 6, 7, 23), c(1:7)]

SA_energy <- row_to_names(SA_energy, row_number = 1)
names(SA_energy)[1] <- "Energy"

# pivot the data to long format for easier plotting
SA_energy <- SA_energy %>%
  pivot_longer(cols = c(`2008-09`, `2009-10`, `2010-11`, `2011-12`, `2012-13`, `2013-14`),
               names_to = "date",
               values_to = "GWh")

# convert GWh to numeric and clean up the Energy column
# energy is calculated based on financial year, so the date is recoded to calendar year for
# easier merging later. For example, 2009-10 is recoded to 2010.
SA_energy$GWh <- as.numeric(SA_energy$GWh)

SA_energy <- SA_energy %>%
  mutate(
    Energy = str_squish(str_to_lower(Energy)),
    Energy = case_when(
      Energy == "total" ~ "Total energy",
      Energy == "brown coal" ~ "Brown Coal",
      Energy == "black coal" ~ "Black Coal",
      TRUE ~ NA_character_
    ),
    date = recode(date, "2008-09" = "2009", "2009-10" = "2010", "2010-11" = "2011", "2011-12" = "2012", "2012-13" = "2013", "2013-14" = "2014")
  ) %>%
  filter(!is.na(Energy)) %>%
  pivot_wider(names_from = Energy, values_from = GWh)

# because coal share is 0 in some regions, replace NA with 0 for coal columns before calculating coal share.
# For example, SA has no black coal, so its black coal share should be 0, not NA.
# calculating coal share and adding a region column for merging later.
SA_energy <- SA_energy %>%
  mutate(`Black Coal` = replace_na(`Black Coal`, 0),
    Region = "SA",
    `Coal Share` = (`Brown Coal` + `Black Coal`) / `Total energy`
  )

# TAS energy mix
# read the population data from the Excel file
TAS_energy <- read_excel("data/raw/energy_mix/Energy_Stats_2025.xlsx", sheet = "TAS FY")
print (TAS_energy, n = 100)

# only keep the relevant rows and columns for coal and total energy
TAS_energy <- TAS_energy[c(3, 6, 7, 23), c(1:7)]

TAS_energy <- row_to_names(TAS_energy, row_number = 1)
names(TAS_energy)[1] <- "Energy"

# pivot the data to long format for easier plotting
TAS_energy <- TAS_energy %>%
  pivot_longer(cols = c(`2008-09`, `2009-10`, `2010-11`, `2011-12`, `2012-13`, `2013-14`),
               names_to = "date",
               values_to = "GWh")

# convert GWh to numeric and clean up the Energy column
# energy is calculated based on financial year, so the date is recoded to calendar year for
# easier merging later. For example, 2009-10 is recoded to 2010.
TAS_energy$GWh <- as.numeric(TAS_energy$GWh)

TAS_energy <- TAS_energy %>%
  mutate(
    Energy = str_squish(str_to_lower(Energy)),
    Energy = case_when(
      Energy == "total" ~ "Total energy",
      Energy == "brown coal" ~ "Brown Coal",
      Energy == "black coal" ~ "Black Coal",
      TRUE ~ NA_character_
    ),
    date = recode(date, "2008-09" = "2009", "2009-10" = "2010", "2010-11" = "2011", "2011-12" = "2012", "2012-13" = "2013", "2013-14" = "2014")
  ) %>%
  filter(!is.na(Energy)) %>%
  pivot_wider(names_from = Energy, values_from = GWh)

# because coal share is 0 in some regions, replace NA with 0 for coal columns before calculating coal share.
# For example, TAS has no coal, so its coal share should be 0, not NA.
# calculating coal share and adding a region column for merging later.
TAS_energy <- TAS_energy %>%
  mutate(`Black Coal` = replace_na(`Black Coal`, 0),
    `Brown Coal` = replace_na(`Brown Coal`, 0),
    Region = "TAS",
    `Coal Share` = (`Brown Coal` + `Black Coal`) / `Total energy`
  )

# combine all regions into one data frame
energy_mix <- bind_rows(NSW_energy, VIC_energy, QLD_energy, SA_energy, TAS_energy)

energy_mix <- energy_mix %>%
  mutate(year = as.numeric(date)) %>%
  select(-date)

print(energy_mix)

# save the cleaned data to a new CSV file
write_csv(energy_mix, "data/clean/energy_mix.csv")

# produce a bar chart of coal share over time for each region
e <- ggplot(energy_mix, aes(x = factor(year), y = `Coal Share`, fill = Region)) +
  geom_col(position = "dodge", width = 0.7) +
  labs(
    title = "Coal Share of Energy Mix by Region",
    x = "Year",
    y = "Coal Share"
  ) +
  scale_y_continuous(limits = c(0, 1)) +
  theme_minimal()

print(e)
ggsave("outputs/coal_share_by_region.png", plot = e, width = 12, height = 8)
