library(tidyverse)
locations <- read_csv("../DC3-data/additional_data/location_coords.csv")
wind_data <- readxl::read_xlsx("../DC3-data/Sensor Data/Meteorological Data.xlsx") %>% 
  select(date = Date,
         wind_dir = `Wind Direction`,
         wind_speed = `Wind Speed (m/s)`)

# convert to miles in an hour from m/s
wind_data <- wind_data %>% 
  mutate(x_diff = (((wind_speed/1609)*60*60)/0.06)*sin(wind_dir*pi/180),
         y_diff = (((wind_speed/1609)*60*60)/0.06)*cos(wind_dir*pi/180)) %>% 
  drop_na() %>% 
  slice(rep(1:n(), each = 4))

wind_data$name <- rep(c("roadrunner", "kasios", "radiance", "indigo"),
                      times=nrow(wind_data)/4)

wind_data <- wind_data %>% 
  left_join(locations) %>% 
  mutate(x_end = x + x_diff,
         y_end = y + y_diff) %>% 
  select(date, wind_speed, x, y, x_end, y_end)

write_csv("../DC3-data/additional_data/vector_field")