# Codebook

## Dataset Description

This dataset contains state-level monthly panel data used to analyse the effect of carbon pricing on electricity demand in Australia.

The dataset covers the period 2010–2014 and includes states in the National Electricity Market (NSW, VIC, QLD, SA, TAS).

---

## Variables Used in Analysis From Merged Data

### region
- Description: Australian state
- Values: NSW, VIC, QLD, SA, TAS

### year
- Description: Year of observation
- Format: YYYY

### month
- Description: Month of observation
- Values: 1–12

### avg_demand
- Description: Average monthly electricity demand
- Unit: Megawatts (MW)
- Source: AEMO
- Construction: Average of 30-minute demand observations within each state-month

### avg_price
- Description: Average monthly electricity price
- Unit: AUD/MWh
- Source: AEMO
- Construction: Average of 30-minute spot prices within each state-month

### avg_temp
- Description: Monthly average temperature
- Unit: Degrees Celsius (°C)
- Source: Bureau of Meteorology
- Construction: Calculated as the average of mean maximum and mean minimum temperatures from representative weather stations in each state
- Station used are:
    - NSW: Sydney Obervatory Hill (066062)
    - VIC: Melbourne Regional Office (086071)
    - QLD: Brisbane (040913)
    - SA: Adelaide - West Terrace/Ngayirdaripa (023000)
    - TAS: Hobart - Ellerslie Road (094029)

### mean_max_temp
- Description: Monthly mean maximum temperature
- Unit: Degrees Celsius (°C)
- Source: Bureau of Meteorology

# mean_min_temp
- Description: Monthly mean minimum temperature
- Unit: Degrees Celsius (°C)
- Source: Bureau of Meteorology

### population
- Description: State population
- Unit: Number of people
- Source: Australian Bureau of Statistics
- Construction: Annual population, repeated for quarter (March, June, September, December) within the year

### coal_share
- Description: Share of electricity generated from coal
- Unit: Percentage (0–1)
- Source: Department of Climate Change, Energy, the Environment and Water
- Construction: Calculated as (black coal + brown coal) divided by total electricity generation

### black_coal
- Description: Electricity generated from black coal
- Unit: Gigawatt-hour (GWh)
- Source: Department of Climate Change, Energy, the Environment and Water

### brown_coal
- Description: Electricity generated from brown coal
- Unit: Gigawatt-hour (GWh)
- Source: Department of Climate Change, Energy, the Environment and Water

### total_energy
- Description: Total energy generation from non-renewable fuels and renewable fuels
- Unit: Gigawatt-hour (GWh)
- Source: Department of Climate Change, Energy, the Environment and Water