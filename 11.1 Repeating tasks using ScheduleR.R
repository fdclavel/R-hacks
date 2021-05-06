# ---------------------
# Scraping data repeatedly using scheduleR
# (part 1 - the procedure to schedule)
# ---------------------

# Scraping web information often requires multiple runs. Many websites have content that 
# changes often. This can occur yearly, monthly, weekly, hourly, or even second by 
# second (e.g., stock prices). Getting updated data would normally require that 
# you physically reopen R and re-scrape the web pages each time
# you need an update. Instead, we can use ScheduleR to automate the 
# process of running repeated scrape functions over time.

# one other thing, when you run ScheduleR scripts, you will receive a log file
# that contains output from the steps in the script. In order
# to make this log file legible, we need to insert programmatic spaces
# in the script using the   cat('\n')   function at any points where there 
# is a function or piece of code that prints something. Otherwise, the log file 
# will be very crowded and hard to read.

# For this example, we will modify the code written to scrape
# Zillow housing data (see script 8 for original content and notes).


# mount packages needed.
library(tidyverse)
library(rvest)
library(lubridate) #this is needed to add date to the csv file we save.

# when web scraping, we always need two things to start:
# 1) the url, which we turn into 2) the page to read into rvest functions.

# the url
u <- "https://www.zillow.com/homes/for_sale/20744_rb/"

# page
pg <- read_html(u)


# now let's get the html nodes for the buttons that go to the new pages of listings

# we can try to figure out the number of pages programmatically, by
# inspecting the buttons to navigate to other pages, and returning the text from them
# to see how many pages of results we actually need to scrape. It might be hard to find,
# so sniff around a bit. I got lucky on the first try below, but it might be 
# two node references instead of just one.

# find the number of pages we need.
#npages <- pg %>% 
#  html_nodes(".ckcnwH .bIIHfk") %>% 
#  html_text(trim=T) %>% 
#  parse_number() %>% 
#  max()


# this time we use npages to create the links for every page of results
#links <- paste0("https://www.zillow.com/homes/for_sale/20744_rb/", 1:npages,"_p")

#cat('\n')

# although honestly it's more efficient to just do this the way I did it
# in script 8 the first time around. This way you don't have to 
# create an object that contains the number of pages, and then alter the urls
# inside your links vector. Rather, you just pull the actual urls from the 
# search page results buttons directly, and pop them into the links
# vector for use in the loop later.

# doing it the original way (see script #8)
links<- pg %>% 
  html_nodes(".bIIHfk a") %>% 
  html_attr("href")
  
#add the main urls to the links  
links <- paste0("https://zillow.com", links)


# Now we recall the scraper function from script #8.

my_scraper <- function(x) {

  # sleep function to avoid a bot flag.  
  Sys.sleep(time = sample(x = 6:15, size = 1, replace = T))

# page
pg <- read_html(x)

# price
price <- pg %>% 
  html_nodes(".list-card-price") %>%
  html_text(trim=T) %>%
  tolower() %>%  #transforming to lowercase is a good habit for converting strings.
  str_replace_all(string=., pattern = "[,|$|\\s|-|+|k|est.]", replacement = "") %>%
  parse_number() #this is more forgiving than as.numeric

# now lets get the addresses
address <- pg %>%
  html_nodes(".list-card-addr") %>%
  html_text(trim=T)

# let's get property types
type <- pg %>%
  html_nodes(".list-card-statusText") %>%
  html_text(trim=T) %>%
  str_replace_all(string=., pattern = "-\\s", replacement = "")

# finally get the links
item_link <- pg %>% 
  html_nodes(".list-card-info .list-card-link-top-margin")  %>% 
  html_attr(x = ., name ='href')

# now compile all into a data frame using the tibble function
data <- tibble(address, price, type, item_link)
  
}

cat('\n')
cat('\n')

# This part will save the zillow data as a .csv file. Note that
# you must specify the FULL file path for the folder and the csv
# file, or else the scheduled task will fail, because it has no idea
# what your working directory is. You could also theoretically set the
# working directory at the start of the script, using the setwd() function.

dat <- links %>% 
  map_df(.x = ., .f = my_scraper)
  
dat %>% write_csv( x= ., 
                   path = paste0('[your FULL file folder path here]/', 'ZillowFile_', lubridate::today(), '.csv'))


