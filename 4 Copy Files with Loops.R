# copying files using R script functions

# find the from path and the to path.
list.files(path = "1 R Hacks/Weather/") #this will be the to path
list.files(path = "1 R Hacks/Weather/2017/")

from_path <- list.files(path = "1 R Hacks/Weather/2017/", full.names=T)

file.copy(from = from_path, to = "1 R Hacks/Weather/")


# use the walk function from purrr to copy each file out of its 
# individual folder into the main weather data folder

# protip - when looping, you should do one iteration first, 
# just to make sure it's actually doing what you want it to, then proceed with the whole run.

library(tidyverse)

# using the paste0 function to concatenate two strings together and feed 
# into the loop. works very similar to the & argument or concatenate 
# in Excel.

# for example this:
paste0("1 R Hacks/", "Weather/", "2018", "/2018.csv")

#returns this:
#[1] "1 R Hacks/Weather/2018/2018.csv"

#we can use placeholder objects to feed into the loop. for example.
y <- 2018
paste0("1 R Hacks/", "Weather/", y, "/", y, ".csv") #note objects must be outside quotations, just like in Excel with cell reference numbers


#also returns this:
#[1] "1 R Hacks/Weather/2018/2018.csv"

# now we just turn the placeholder object into a vector instead of 
# a single value, and we get several returns.
y <- 2017:2020
paste0("1 R Hacks/", "Weather/", y, "/", y, ".csv")

# the multiple returns are the files that we need for the next step.

# now we write a quick function to conduct the paste step we just did.
my_copy_function <- function(y) {
  paste0("1 R Hacks/", "Weather/", y, "/", y, ".csv")
}

# we can test this function real quick before expanding it to copy files.
print(my_copy_function(2015))

# now we expand the function to take that paste step and use 
# it as the "from" path for the file.copy function we used 
# earlier. It will effectively set the from path as a function 
# of whichever year it's currently using. 
my_copy_function <- function(y) {
  from_path <- paste0("1 R Hacks/", "Weather/", y, "/", y, ".csv")
  file.copy(from = from_path, to = "1 R Hacks/Weather")
}

# note - remove the "from_path" and "y" values we made earlier, or else 
# the function might encounter a "no such file/directory" error
rm(from_path)
rm(y)

# we can test this function real quick to see if it copies a single file.
my_copy_function(2018)

# lastly, we use the walk function to loop through a set number of 
# years and apply the new function we just wrote to each year, to 
# copy each file out of it's origin folder and into the main Weather folder.
walk(.x = 2017:2020, .f = safely(my_copy_function))
