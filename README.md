# Carbon Pricing and Electricity Demand in Australian States
This project examines whether electricity demand responded more strongly to the Australian carbon pricing policy (2012–2014) in states with more carbon-intensive electricity generation.

The analysis uses state-level panel data combining electricity demand, electricity prices, temperature, population, and generation mix.

## Repository Structure

- data/raw/  
  Contains raw datasets obtained from external sources (AEMO, BOM, ABS, etc.)

- data/clean/  
  Contains cleaned and merged datasets used for analysis, and codebook of dataset variables

- src/  
  Contains scripts to clean and merge the data:
  - clean_demand_price.R
  - clean_temperature.R
  - 03_clean_population.R
  - 04_clean_generation_mix.R
  - 05_merge_data.R

- README.md  
  Project documentation

## Software Requirements

- R (version 4.x)
- R packages:
  - tidyverse
  - lubridate
  - janitor
  - readr
  - languageserver
  - readxl (if using Excel files)

To install required packages:

install.packages(c("tidyverse", "lubridate", "janitor", "readxl", "readr", "languageserver"))

## Data Sources

- Electricity demand and price:
  Australian Energy Market Operator (AEMO)

- Temperature data:
  Bureau of Meteorology (BOM), using representative weather stations in major cities

- Population data:
  Australian Bureau of Statistics (ABS)

- Electricity generation mix:
  Department of Climate Change, Energy, the Environment and Water

## How to Run the Project

1. Clone the repository:

git clone [your-repo-link]

2. Place raw data files into the appropriate folders:

- data/raw/demand_price/
- data/raw/temperature/
- data/raw/population/
- data/raw/generation_mix/

3. Run the scripts in the following order:

Rscript code/01_clean_demand_price.R  
Rscript code/02_clean_temperature.R  
Rscript code/03_clean_population.R  
Rscript code/04_clean_generation_mix.R  
Rscript code/05_merge_data.R  

4. The final dataset will be generated in:

data/clean/final_panel.csv

## Manual Steps

Some raw data cannot be directly included due to size and access restrictions. The following steps must be performed manually:

- Download electricity demand and price data from AEMO (NEM data)
- Download temperature data (monthly mean max and min) from BOM for:
  Sydney, Melbourne, Brisbane, Adelaide, and Hobart
- Download population data from ABS
- Download generation mix data from government sources

Place all files into the specified folders in data/raw/

## Notes

- Temperature is calculated as the average of mean maximum and mean minimum temperatures.
- Coal share is calculated using pre-policy generation data to avoid endogeneity.
- The analysis focuses on states within the National Electricity Market (NEM).