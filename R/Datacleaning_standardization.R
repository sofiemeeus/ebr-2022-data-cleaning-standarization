# Empowering Biodiversity Research
# Data cleaning and standardisation in R 
# Laura Marquez & Salvador Fernandez

# make sure to have installed tidyverse, uncomment next to install it
# install.packages("tidyverse")
library(tidyverse)

# Exercises part A. (10 min)
# cheatsheet: https://github.com/rstudio/cheatsheets/blob/main/strings.pdf
# 1. Open the file and look at the scope of the data, something strange with the site names? *use unique() 

# 2. Identify mistyping errors in the site names (Ballylongfor, New Quay_, New quay, newquay) and correct them *use str_replace()

# 3. Delete special characters and spaces from the data *use str_replace()


# Exercises part B. (15 min)
# cheatsheet: https://nyu-cdsc.github.io/learningr/assets/data-transformation.pdf
# cheatsheet: https://raw.githubusercontent.com/rstudio/cheatsheets/main/tidyr.pdf

# 1. Standardize the dates in IS0 8601 standard (YYYY-mm-dd) *use separate() & mutate()

# 2. Use pivot function to get your data tidy (one observation per row) *use pivot_longer()

# 3. Drop the unnecessary columns (day, month, year, SiteName) *use select() 

# Great job! Now your data is tidy, we can move on standardization!


# Exercises part C. (5 min)
# 1. Modify DataAbundancew column names to fit the Darwin Core standard * use rename()


# Exercises part D. (10 min)
# 1. Use worrms library to obtain the LSID of each species and put them in a new column named “scientificNameID”
#    * use wm_records_taxamatch
#    * once you obtained them, use “do.call(rbind, myspeciestable)”	to extract the elements of myspeciestable  
#    * use left_join to ONLY add the species 
# https://cran.r-project.org/web/packages/worrms/worrms.pdf
# uncomment next to install worrms R package:
# install.packages("worrms")

library(worrms)

myspeciestable <- wm_records_taxamatch(unique(YOURDATAHERE)) 

table <- do.call(rbind, myspeciestable)


# Exercises part E. (10 min)
# 1. Use marineregions to search for the correct id of the region and put it in a new column (locationID) 
# https://www.marineregions.org/gazetteer.php?p=search
# uncomment next to install mregions2 R package:
# install.packages("devtools")
# devtools::install_github("lifewatch/mregions2", build_vignettes = TRUE)

library(mregions2)
