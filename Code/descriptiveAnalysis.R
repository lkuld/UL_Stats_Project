# Created 19 November 2024
# Created by Lukas
# Explores House data by subgroup

# empty workspace
rm(list=ls())

# load packages
library(stringr) # working with text data (character vectors ...)
library(ggplot2) # plotting
library(dplyr)  # data handling
library(lubridate)  # working with time data

# load data created in InspectPrepareData.R
load('./Data/SubsetPPR.RData')
summary(ppr_df)

# created data set with average house price per county and year

# create year variable
ppr_df$year <- year(ppr_df$date)

#####  overall analysis ------ 

hist <- ggplot(ppr_df[ppr_df$price<1000000,], mapping = aes(x=price)) +
  geom_histogram() +
  theme_light() +
  labs(x='Property price', y='')

ggsave(hist, filename='./Output/price_histogram.png', width = 5, height=4)

ppr_df$year_fac <- factor(ppr_df$year)

(hist <- ggplot(ppr_df[ppr_df$price<1000000&ppr_df$County %in% c('Limerick', 'Clare'),],
                mapping = aes(x=price)) +
  geom_histogram(aes(fill=County)) +
  theme_light() +
  labs(x='Property price', y='') +
    facet_wrap(~year)
) 

## county & year analysis ----

stats_agg <- ppr_df |>
  group_by(year) |> 
  summarise(observations=n(),
            price_mean=mean(price),
            price_median=median(price))


num_obs_year <- ggplot(stats_agg, aes(x=year, y=observations)) +
  geom_col() +
  theme_light() +
  labs(x='Year', y='Observations')

ggsave(num_obs_year, filename='./Output/num_obs_year.png', width = 5, height=4)

# mean

mean_year <- ggplot(stats_agg, aes(x=year, y=price_mean)) +
  geom_point() +
  geom_line() +
  theme_light() +
  labs(x='Year', y='Average price')

stats_agg_long <- reshape2::melt(stats_agg[,c("year","price_mean","price_median")],
                                 id='year')
stats_agg_long$variable <- str_remove(stats_agg_long$variable, 'price_')


price_year <- ggplot(stats_agg_long, aes(x=year, y=value)) +
  geom_point(aes(colour=variable, shape=variable)) +
  geom_line(aes(colour=variable)) +
  theme_light() +
  viridis::scale_colour_viridis(discrete = TRUE) +
  labs(x='Year', y='Property price', colour='', shape='') +
  theme(legend.position = 'bottom')

stats_agg <- ppr_df |>
  group_by(year, County) |> 
  summarise(observations=n(),
            price_mean=mean(price),
            price_median=median(price))

stats_agg_long <- reshape2::melt(stats_agg[,c("year", 'County',"price_mean","price_median")],
                                 id=c('year', 'County') )
stats_agg_long$variable <- str_remove(stats_agg_long$variable, 'price_')

price_year <- ggplot(stats_agg_long, aes(x=year, y=value)) +
  geom_point(aes(colour=variable, shape=variable)) +
  geom_line(aes(colour=variable)) +
  theme_light() +
  viridis::scale_colour_viridis(discrete = TRUE) +
  labs(x='Year', y='Property price', colour='', shape='') +
  theme(legend.position = 'bottom') +
  facet_wrap(~County)

