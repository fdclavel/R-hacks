# Exercise 1

# install the lubridate package if you don't already have it installed
install.packages('lubridate')

lub



# Run the following script. What do you think they do?

# The following three will explicitly call the lubridate
# package without actually mounting it. It works but it is
# a rather tedious way to use functions within specific packages.

lubridate::date() #display the current date and time
lubridate::today() #display today's date cleanly
lubridate::month(lubridate::today()) #display the current month


#mount the lubridate and tidyverse packages directly
library(lubridate)
library(tidyverse)


#call the same three functions as earlier, but with lubridate already mounted.
date()
today()
month(today())


#save a date string to an object
d <- '2011-12-12'

#read that string as a usable date with lubridate's ymd function
d2 <- ymd(d)

#check their classes. "d" should be a character vector, while "d2" should be a date object.
class(d)
class(d2)


#read the system's date in base R
Sys.Date()

#suspends execution of R expressions for (n) seconds
Sys.sleep(10)




