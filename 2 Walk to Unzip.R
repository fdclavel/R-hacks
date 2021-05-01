# Now we are going to use R utils to execute a walk loop
# to unzip files. The walk function is in tidyverse, specifically
# in the purrr package.

library(tidyverse)

# we will need the vector of zip file names again. copied below from script 1.

# list files that include 'gz' in the file name, and list by full name.
  list.files(path = "Zip files/", pattern = 'gz', full.names = T)

  # save this list to a vector so we can use it in a loop.
  myzipfile <- list.files(path = "Zip files/", pattern = 'gz', full.names = T)
  
# use walk with gunzip to unzip the files and be sure to 
# call the "remove=F" parameter in gunzip  (you can add bundled 
# parameters from other functions to a walk function in purr)
  
# Also note that the 2017 file is already in the folder. We can tell walk to
# skip any iterations that encounter errors and keep going, 
# by using the 'safely' function within walk. 
walk(.x=myzipfile, .f=safely(gunzip), remove=F)
