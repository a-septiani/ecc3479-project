# Codebook

## Dataset Description

This dataset contains state-level monthly panel data used to analyse the effect of carbon pricing on electricity demand in Australia.

The dataset covers the period 2010–2014 and includes states in the National Electricity Market (NSW, VIC, QLD, SA, TAS).

---

## Variables

### state
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

### temperature
- Description: Monthly average temperature
- Unit: Degrees Celsius (°C)
- Source: Bureau of Meteorology
- Construction: Calculated as the average of mean maximum and mean minimum temperatures from representative weather stations in each state

### population
- Description: State population
- Unit: Number of people
- Source: Australian Bureau of Statistics
- Construction: Annual population, repeated for each month within the year

### coal_share
- Description: Share of electricity generated from coal
- Unit: Percentage (0–1)
- Source: Department of Climate Change, Energy, the Environment and Water
- Construction: Calculated as (black coal + brown coal) divided by total electricity generation, using pre-policy data in 2010