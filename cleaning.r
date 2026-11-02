library(tidyverse)
library(dplyr)

dataset = read.csv("257_P1/Dataset of motor insurance portfolio.csv", sep=";")


# i want to see if i cant predict "total incurred" if total incurred > from charactersitics of vehicles
# only year 2022 active policies

cleaned = dataset %>% 
  filter(policy_status=="A", year=="2022", total_incurred>0, policy_type=="CC") %>%
  select(total_incurred, driver_age, vehicle_age, age_driving_licence, power_to_weight_ratio, vehicle_value, total_premium) %>%
  mutate(years_licensed=driver_age-age_driving_licence)

write.csv(cleaned, "257_P1/data/cleaned.csv", row.names=FALSE)


