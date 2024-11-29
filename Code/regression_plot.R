# Regression based plots for price averages
# Created by Lukas, 17/11/2024
# TO DO: ...

library(stringr)
library(lubridate)
library(dplyr)
library(broom)
library(ggplot2)

# Read in csv file from https://www.propertypriceregister.ie/
ppr_df <- read.csv(file = "./Data/Original/PPR-ALL.csv", fileEncoding = "windows-1252")

# clean price var 
ppr_df$price <- str_remove_all(ppr_df$Price...., '[^0-9]')
ppr_df$price <- as.numeric(ppr_df$price) / 100

# specify date
ppr_df$date <- as_date(ppr_df$Date.of.Sale..dd.mm.yyyy., format = '%d/%m/%Y')

# extract year
ppr_df$year <- ppr_df$date |> year() |> as.character()

ggplot(ppr_df[ppr_df$price<1000000&ppr_df$County=='Limerick',], 
       mapping= aes(x=date, y=price)) +
  geom_point(size=.1) +
  geom_smooth(method = 'lm')

ppr_df$days <- (ppr_df$date - min(ppr_df$date)) |> as.numeric()

lm(price ~ days + Description.of.Property, 
   ppr_df[ppr_df$County=='Limerick',]) |> summary()


# bit more complicated code below, use ChatGPT and help function 
# to understand the individual functions

regs <- ppr_df |> 
  group_by(County) |> 
  do(data.frame(tidy(lm(price~year-1 , data = .), conf.int=TRUE)))

# needs to be numeric for plotting
regs$year <- regs$term |> str_extract(pattern = '[0-9]{4}') |> as.numeric()
regs <- regs[str_detect(regs$term, 'year'),]
# plot
ggplot(regs |> filter(County %in% c('Limerick', 'Clare')), aes(year, estimate)) +
  geom_point(aes(colour=County, shape=County)) +
  geom_line(aes(colour=County)) +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high, colour=County)) +
  theme_light() +
  viridis::scale_color_viridis(discrete = TRUE) +
  labs(y='price')
