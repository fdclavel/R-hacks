# --------------
# Web scraping continued - with Zillow
# --------------

# mount packages needed.
library(tidyverse)
library(rvest)

# when web scraping, we always need two things to start:
# 1) the url, which we turn into 2) the page to read into rvest functions.

# the url
u <- "https://www.zillow.com/homes/for_sale/20744_rb/"

# page
pg <- read_html(u)

# scraping various pieces of information about available homes for sale in Washington DC.

# price (protip -- try the singular html_node first, to see how the results will look)
pg %>% 
  html_nodes(".list-card-price") %>%
  html_text(trim=T)

# we can see that this format has issues: 
# 1) it has dollar signs in it, 
# 2) it has commas in it.
# 3) there is white space, and 
# 4) there are some blank entries that say "--"
#
# we can remove white space using the handler \\s. we 
# can remove all the unwanted elements in the str_replace_all function
# by specifying them under "pattern" and using vertical bars |
# which indicates OR statements, and placing the entire set of elements within
# square brackets. See below.


price <- pg %>% 
  html_nodes(".list-card-price") %>%
  html_text(trim=T) %>%
  tolower() %>%  #transforming to lowercase is a good habit for converting strings.
  str_replace_all(string=., pattern = "[,|$|\\s|-]", replacement = "") %>%
  as.numeric()


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

# we can continue this process through the rest of 
# the listings on Zillow for this zip code. To do this,
# we can use a loop.

#let's first get the html nodes for the buttons that go to the new pages of listings

links<- pg %>% 
  html_nodes(".bIIHfk a") %>% 
  html_attr("href")
  
#add the main urls to the links  
links <- paste0("https://zillow.com", links)


# ---------------------------
# Using looping procedures to 
# scrap multiple web pages
# ---------------------------

# So now we can use a loop or a map function to loop through 
# all pages of listings and extract the same info above that 
# we just scraped from the first page of results.
#
# to use the map function, we will first define a scraping function 
# that purrr will ultimately use on each page via map.



# define the scraping function, based on all of the above steps, 
# from defining the page to scrape to making the tibble. x will be the 
# url we loop over.

############# WARNING ###############
# The inherent risk in running loops to do web scraping is that a website's server might flag your
# IP address as a bot and block you from accessing it. This is especially risky if you fail to 
# include a sys.sleep function, because without this function, the R script will ping the website's
# server multiple times in very rapid succession, which is a red flag for non-human access.
# To circumvent this risk, we use two things in tandem at the start of the new function:
# 
# 1) using a sys.sleep function to make R stop running 
#    for n seconds at the beginning of each loop
# 2) within sys.sleep use a random sampling function to 
#    make the length of n seconds vary randomly between two values each time
######################################

my_scraper <- function(x) {

  # sleep function to avoid a bot flag.  
  Sys.sleep(time = sample(x = 6:20, size = 1, replace = T))

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

# now we use the new function to run the process 
# over all the pages of results (which we called "links" earlier)

links %>% 
  map_df(.x = ., .f = my_scraper)
