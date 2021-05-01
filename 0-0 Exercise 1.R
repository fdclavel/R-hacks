# Exercise 1

# install the lubridate package if you don't already have it installed
install.packages('lubridate')


# The following three will explicitly call the lubridate
# package without actually mounting it. It works but it is
# a rather tedious way to use functions within specific packages,
# however it can offer a useful layer of added precision in cases
# where two or more packages share the same function name (this
# is pretty common with larger packages [e.g., tidyverse or ggplot2]).

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

# Sys.sleep suspends execution of R expressions for (n) seconds.
# This function is useful for operations that involve web scraping,
# where your script will send many requests to a server (e.g., 1000).
# It is important to provide periods of downtime in between those 
# requests (effectively mimicking a human), or else some servers may 
# flag your machine as a bot and deny your requests, or even ban 
# your IP from future requests.

Sys.sleep(10)


