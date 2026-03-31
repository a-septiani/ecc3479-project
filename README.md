# Carbon Pricing and Electricity Demand in Australian States
This project examines whether electricity demand responded more strongly to the Australian carbon pricing policy (2012–2014) in states with more carbon-intensive electricity generation.

The analysis uses state-level panel data combining electricity demand, electricity prices, temperature, population, and energy generation mix.

## Repository Structure

- data/raw/  
  Contains raw datasets obtained from external sources (AEMO, BOM, ABS, and Department of Climate Change, Energy, the Environment and Water)

- data/clean/  
  Contains cleaned and merged datasets used for analysis, and codebook of dataset variables

- src/  
  Contains scripts to clean and merge the data:
  - clean_demand_price.R
  - clean_temperature.R
  - clean_pop.R
  - clean_energy_mix.R
  - merge_data.R
  - econometrics_analysis.R 

- outputs/  
  Contains graphs and plots from EDA process. The current plots are:
  - demand_price_by_region.png: The time series trend of demand and price of electricity before and after carbon pricing
  - population_by_region.png: The time series trend of population
  - temperature_by_region.png: The time series trend of temperature, illustrating seasonal pattern
  - coal_share_by_region: The time series trend of percentange of coal shares
  - analysis_metrics_by_region: the combination of all variable trend

- README.md  
  Project documentation

## Software Requirements

- R (version 2.8.8)
- R packages:
  - tidyverse
  - lubridate
  - janitor
  - readr
  - languageserver
  - readxl

To install required packages:

install.packages(c("tidyverse", "lubridate", "janitor", "readxl", "readr", "languageserver"))

## Data Sources

- Electricity demand and price:
  Australian Energy Market Operator (AEMO)

- Temperature data:
  Bureau of Meteorology (BOM), using representative weather stations in major cities
  - Station used are:
    - NSW: Sydney Obervatory Hill (066062)
    - VIC: Melbourne Regional Office (086071)
    - QLD: Brisbane (040913)
    - SA: Adelaide - West Terrace/Ngayirdaripa (023000)
    - TAS: Hobart - Ellerslie Road (094029)

- Population data:
  Australian Bureau of Statistics (ABS)

- Electricity generation mix:
  Department of Climate Change, Energy, the Environment and Water

## How to Run the Project

1. Clone the repository:

    git clone [https://github.com/a-septiani/ecc3479-project]

2. Place raw data files into the appropriate folders:

- data/raw/aemo_demand_price/
- data/raw/bom_temperature/
- data/raw/abs_population/
- data/raw/energy_mix/

3. Run the scripts in the following order:

  1. Rscript src/clean_demand_price.R  
      Result: data/clean/monthly_demand_price.csv
  2. Rscript src/clean_temperature.R  
       Result: data/clean/monthly_temperature.csv
  3. Rscript src/clean_pop.R  
       Result: data/clean/quarterly_population.csv
  4. Rscript src/clean_energy_mix.R 
       Result: data/clean/energy_mix.csv
  5. Rscript src/merge_data.R  
       Result: data/clean/merged_data.csv
  6. Rscript econometrics_analysis.R (outside Data + GitHub assignment)

## Manual Steps

If some raw data cannot be directly included due to size and access restrictions, the following steps must be performed manually:

- Download electricity demand and price data from AEMO (NEM data)
- Download temperature data (monthly mean max and min) from BOM for:
  Sydney, Melbourne, Brisbane, Adelaide, and Hobart
- Download population data from ABS
- Download generation mix data from government sources

Place all files into the specified folders in data/raw/

## Notes

- Temperature is calculated as the average of mean maximum and mean minimum temperatures.
- Coal share is calculated as the percentage of coal share from total energy generation
- Energy generation mix in reported in financial year. To ensure the data can merge in the analysis, year variable is reported based on the ending of financial year. For example, financial year 2009-2010 is reported as energy generation mix in 2010.
- The analysis focuses on states within the National Electricity Market (NEM). Thus, Western Australia, Northern Territory, and Australia Capital Territory is out of the scope on this analysis.
- Data in merged_data.csv follows the quarterly data of population to avoid missing value (NA) for some months.