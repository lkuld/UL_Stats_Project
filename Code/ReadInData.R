
# Read in csv file from https://www.propertypriceregister.ie/

ppr_df <- read.csv(file = "./Data/Original/PPR-ALL.csv", fileEncoding = "windows-1252")
# ppr_df <- read.csv(file = "./Data/Original/PPR-ALL.csv")

# Read in RData file from Brightspace

load(file = "./Data/Original/property_df.RData")
