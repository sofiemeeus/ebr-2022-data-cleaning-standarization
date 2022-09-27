# Empowering Biodiversity Research
# Data cleaning and standardisation in R 

# make sure to have installed tidyverse, uncomment next to install it
install.packages("tidyverse")
library(tidyverse)

DataAbundancew <- read_csv("./data/DataAbundancew.csv")


# Exercises part A. (10 min)
# cheatsheet https://github.com/rstudio/cheatsheets/blob/main/strings.pdf
# 1. Open the file and look at the scope of the data, something strange with the site names? *use unique() 
# It is always a good practice to look at the scope of your data, to check for possible mistyping errors, outliers OR na (always make sure these are real NA and not 0 or viceverse) & decide how to handle them
unique(DataAbundancew$date)
unique(DataAbundancew$SiteName) #is there anything that do you notice here? (there are mistyping errors)

range(DataAbundancew$Latitude) 

# 2. Identify mistyping errors in the site names and correct them *use str_replace()
# Replace the mistyping in the data: Ballylongfor, New Quay_, New quay, newquay
# ! Note that is always a good practice to preserve the original data and create a second column containing the corrections
DataAbundancew$SiteName_clean <- DataAbundancew$SiteName

DataAbundancew$SiteName_clean <- str_replace(DataAbundancew$SiteName_clean, "New quay", "New Quay") #ok
DataAbundancew$SiteName_clean <- str_replace(DataAbundancew$SiteName_clean, "newquay", "New Quay") #ok
DataAbundancew$SiteName_clean <- str_replace(DataAbundancew$SiteName_clean, "New Quay_", "New Quay") #ok
str_replace(DataAbundancew$SiteName_clean, "Ballylongfor", "Ballylongford") #note here using str_replace does not work for our purpose

DataAbundancew$SiteName_clean[DataAbundancew$SiteName_clean == 'Ballylongfor'] <- "Ballylongford"


# Now that your data is clean, let's make it tidy!

# 3. Delete special characters and spaces from the data *use str_replace()
# Spaces, special characters cannot be read by computers (if sometime you need them, _ - are allowed)
DataAbundancew$SiteName_clean <- str_replace(DataAbundancew$SiteName_clean, "'", "")
DataAbundancew$SiteName_clean <- str_replace(DataAbundancew$SiteName_clean, " ", "_")


# Now we are going to present 4 important functions from tidyverse that are key to do data cleaning & standardization
# Using %>%, introduce select, filter, mutate, transform
# cheatsheet: https://nyu-cdsc.github.io/learningr/assets/data-transformation.pdf
DataAbundancew %>% select(SiteName,
                          Latitude,
                          Longitude)

DataAbundancew %>% filter(date == "2/1/2019")

dt<- DataAbundancew %>% mutate(SiteNameCountry = paste0(SiteName_clean, ", Ireland"))

dt<- DataAbundancew %>% transmute(SiteNameCountry = paste0(SiteName_clean, ", Ireland"))

#you could also correct all mistakes from one column (exercises A.2 & A.3) with one piece of code:
DataAbundancew <- DataAbundancew %>% 
                                  mutate(
                                    SiteName = SiteName %>% 
                                      tolower() %>% 
                                      trimws() %>% 
                                      str_replace("_", "") %>% 
                                      str_replace("'", "") %>%
                                      str_replace(",", "") %>%
                                      str_replace("ballylongford", "ballylongfor") %>%
                                      str_replace("ballylongfor", "ballylongford") %>%
                                      str_replace(" ", "")
                                  )

# Exercises part B. (15 min)
# cheatsheet https://raw.githubusercontent.com/rstudio/cheatsheets/main/tidyr.pdf

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
DataAbundancew <- DataAbundancew %>% rename(recordNumber = observationNumber,
                                            eventDate = date,
                                            decimalLatitude = Latitude,
                                            decimalLongitude = Longitude,
                                            locality = SiteName_clean,
                                            scientificName = species,
                                            individualCount = abundance
                                          )


# Exercises part D. (10 min)
# 1. Use worrms library to obtain the LSID of each species and put them in a new column named “scientificNameID”
#    * use wm_records_taxamatch
#    * once you obtained them, use “do.call(rbind, myspeciestable)” to extract the elements of myspeciestable 
#    * use left_join to ONLY add the species 
# https://cran.r-project.org/web/packages/worrms/worrms.pdf
# uncomment next to install worrms R package:
# install.packages("worrms")

library(worrms)
myspeciestable <- wm_records_taxamatch(unique(DataAbundancew$scientificName)) 

#transform the list of dataframes to a single dataframe
table <- do.call(rbind, myspeciestable) %>%
                         select(scientificname, lsid)

DataAbundancew <- DataAbundancew %>%
                   left_join(table, by = c("scientificName" = "scientificname"))

# Exercises part E. (10 min)
# 1. Use marineregions to search for the correct id of the region and put it in a new column (locationID) 
# https://www.marineregions.org/gazetteer.php?p=search
# uncomment next to install mregions2 R package:
# devtools::install_github("lifewatch/mregions2", build_vignettes = TRUE)

library(mregions2)
DataAbundancew %>% 
  sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"), crs = 4326, remove = FALSE) %>% 
  mapview::mapview()

irish_mr <- mr_gaz_records_by_name("Irish") 

irish_mr %>% distinct(placeType)
irish_mr %>% View()

irish_eez <- irish_mr %>%
  filter(placeType == "EEZ")

irish_eez$MRGID

DataAbundancew <- DataAbundancew %>% mutate(locationID = "http://marineregions.org/mrgid/5681")

