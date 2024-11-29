# Inspect property data and create cleaned subset
# Created by Lukas, 31/10/2023
# TO DO: ...

library(stringr)
library(lubridate)

# Read in csv file from https://www.propertypriceregister.ie/
ppr_df <- read.csv(file = "./Data/Original/PPR-ALL.csv", fileEncoding = "windows-1252")

# inspect data

summary(ppr_df)
head(ppr_df)
View(ppr_df)
names(ppr_df)

# create transaction id variable
ppr_df$id <- seq_along(ppr_df$Date.of.Sale..dd.mm.yyyy.)

# create subset for date, county, price, id

ppr_df <- ppr_df[,c("id", "Date.of.Sale..dd.mm.yyyy.", "County", "Price....")]

# create numeric price variable
  
ppr_df$price <- str_remove_all(ppr_df$Price...., '[^0-9]')
ppr_df$price <- as.numeric(ppr_df$price) / 100


# create a date variable
# https://r4ds.hadley.nz/datetimes.html

ppr_df$date <- as_date(ppr_df$Date.of.Sale..dd.mm.yyyy., format = '%d/%m/%Y')

# subset and save new data frame
ppr_df <- ppr_df[,c('id', 'date', 'County', 'price')]
save(ppr_df, file = './Data/SubsetPPR.RData')

