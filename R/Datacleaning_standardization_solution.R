#Empowering Biodiversity Research
#Data cleaning and standardisation in R 

library(tidyverse)

DataAbundancew <- read_csv("./data/DataAbundancew.csv")


#Exercises part A. (10 min)

# 1. Open the file and look at the scope of the data, something strange with the site names? *use unique() 
unique(DataAbundancew$date)
unique(DataAbundancew$SiteName) #is there anything that do you notice here? (there are mistyping errors)

unique(DataAbundancew$Latitude)
unique(DataAbundancew$Longitude)#it is always a good practice to look at the scope of your data, to check for possible mistyping errors, outliers OR na (always make sure these are real NA and not 0 or viceverse) & decide how to handle them


# 2. Identify mistyping errors in the site names and correct them *use str_replace()
# Replace the mistyping in the data: Ballylongfor, New Quay_, New quay, newquay
# !! Note that is always a good practice to preserve the original data and create a second column containing the corrections
DataAbundancew$SiteName_clean <- DataAbundancew$SiteName
names(DataAbundancew)

unique(DataAbundancew$SiteName_clean)
DataAbundancew$SiteName_clean <- str_replace(DataAbundancew$SiteName_clean, "New quay", "New Quay") #ok
DataAbundancew$SiteName_clean <- str_replace(DataAbundancew$SiteName_clean, "newquay", "New Quay") #ok
DataAbundancew$SiteName_clean <- str_replace(DataAbundancew$SiteName_clean, "New Quay_", "New Quay") #ok
str_replace(DataAbundancew$SiteName_clean, "Ballylongfor", "Ballylongford") #

DataAbundancew$SiteName_clean[DataAbundancew$SiteName_clean == 'Ballylongfor'] <- "Ballylongford"


# Now that your data is clean, let's make it tidy!

# 3. Delete special characters and spaces from the data *use str_replace()
# Spaces, special characters cannot be read by computers (if sometime you need them, _ - are allowed)
DataAbundancew$SiteName_clean <- str_replace(DataAbundancew$SiteName_clean, "'", "")
DataAbundancew$SiteName_clean <- str_replace(DataAbundancew$SiteName_clean, " ", "_")


# Now we are going to present 4 important functions from tidyverse that are key to do data cleaning & standardization
# this are useful not only for this, but for handling any type of data
# Using %>%, introduce select, filter, mutate, transform
DataAbundancew %>% select(SiteName,
                          Latitude,
                          Longitude)

DataAbundancew %>% filter(date == "2/1/2019")

DataAbundancew %>% mutate(SiteNameCountry = paste0(SiteName_clean, ", Ireland"))

DataAbundancew %>% transmute(SiteNameCountry = paste0(SiteName_clean, ", Ireland"))


# Exercises part B. (15 min)
# 1. Standardize the dates in IS0 8601 standard (YYYY-mm-dd) *use separate() & mutate()
DataAbundancew <- DataAbundancew %>% separate(col = date, 
                                             into = c("month","day", "year"),
                                             sep = c("/"),
                                             extra = "merge") %>% 
                                      mutate(date = paste0(year, 
                                                           "-", 
                                                           ifelse(as.numeric(month)<10, 
                                                                  paste0(0,month), 
                                                                  month),
                                                           "-",
                                                           ifelse(as.numeric(day)<10, 
                                                                  paste0(0,day), 
                                                                  day)
                                      )      
                                      )



# 2. Use pivot function to get your data tidy (one observation per row) *use pivot_longer()
DataAbundancew <- DataAbundancew %>% pivot_longer(cols = 8:10, names_to = "species", values_to = "abundance")


# 3. Drop the unnecessary columns (day, month, year, SiteName) *use select() 
DataAbundancew <- DataAbundancew %>% select(-c("month", "day", "year", "SiteName"))


# Great job! Now your data is tidy, we can move on standardization!

# Exercises part C. (5 min)
# 1. Modify DataAbundancew column names to fit the Darwin Core standard * use rename()
DataAbundancew <- DataAbundancew %>% rename(
  recordNumber = observationNumber,
  eventDate = date,
  decimalLatitude = Latitude,
  decimalLongitude = Longitude,
  Location = SiteName_clean,
  scientificName = species,
  individualCount = abundance
)


# Exercises part D. (10 min)
# 1. Use worrms library to obtain the LSID of each species and put them in a new column named “scientificNameID”
#    * use wm_records_taxamatch
#    * once you obtained them, use “do.call(rbind, myspeciestable)” 	to transform the tibble to data frame 
#    * use left_join to ONLY add the species 

#https://github.com/ropensci/worrms
#https://cran.r-project.org/web/packages/worms/worms.pdf

library(worrms)

table <-wm_records_taxamatch(unique(DataAbundancew$scientificName)) #join introducing
table <-do.call(rbind, table)

speciesID <- table %>% select(scientificName= scientificname,
                              lsid)

DataAbundancew <- left_join(DataAbundancew, speciesID, by = "scientificName")


# Exercises part E. (10 min)
# 1. Use marineregions to search for the correct id of the region and put it in a new column (locationID) 
# https://www.marineregions.org/gazetteer.php?p=search
# https://github.com/ropensci/mregions

DataAbundancew %>% 
  sf::st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE) %>% 
  mapview::mapview()

mregions2::mr_gaz_records_by_name("Irish") %>% filter(placeType == "EEZ")

DataAbundancew <- DataAbundancew %>% mutate(locationID = "http://marineregions.org/mrgid/5681")

