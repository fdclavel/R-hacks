# ------------------------------
# Potential issues with web scraping in R
# ------------------------------

# mount packages needed
library(tidyverse)
library(rvest)

# This time we will be searching for iPhones on Amazon.

# get the url for Amazon search results for iPhones.
u <- 'https://amazon.com/s?k=iphone&ref=nb_sb_noss_2'
pg <- read_html(u)

# With websites like Amazon that change frequently and have fluctuating info,
# you will commonly encounter errors with the steps below. For example, you might
# get search results where there are 20 items listed, but 2 of them have no price
# information listed currently. If you don't correct for these inconsistencies, 
# you will not be able to create a tibble toward the end that contains all of the 
# data you are collecting.

# add the names of each product to a vector
iPhone_name <- pg %>% 
  html_nodes('.a-size-medium.a-text-normal') %>% 
  html_text(trim=T)

# add the prices of each product to a vector
iPhone_price <- pg %>% 
  html_nodes('.sg-col-20-of-28 .a-price-whole') %>% 
  html_text(trim=T)

# one solution to missing elements is to identify them by visiting the website
# and manually finding the missing elements and correcting your vector. For
# example, if the 4th and the 11th elements for prices are missing, you can correct the
# price vector with a quick line of code like this:

iPhone_price <- c(iPhone_price[1:3], NA, iPhone_price[4:9], NA, iPhone_price[10:18])

# however this is very tedious and often insufficient if we plan to run loops or map functions.
# when looping, we won't be able to tell where these missing elements occur on each search
# results page, unless we go and check every single one and correct them. Keep these issues in mind
# when you encounter errors.