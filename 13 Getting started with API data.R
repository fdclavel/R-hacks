# using R to get data via API

# you will need the httr package to begin with. This package has the two
# functions - get and post - that will allow you to communicate with API servers.

install.packages('httr')

# second is jsonlite. this package will allow you to make sense of the data you obtain
# from API servers.

install.packages('jsonlite')

# lets mount the packages we need.

library(httr)
library(jsonlite)
library(tidyverse)


# you will need to find the API documentation for the particular website you are attempting 
# to collect data from. Unlike web scraping, API functions allow you to 
# collect data from a website via a mutual agreement between the user
# and the publisher of the data. Websites offer APIs to users as a way to allow
# them to collect data in a curated and supervised way (whereas web scraping is 
# unsupervised and doesn't involve a mutual agreement between parties). Each site's API will 
# vary, but you should be able to find the url that you need to begin using the GET function
# if you sniff around the documentation the site has available for developers or analysts.

# ------------------------
# another requirement 
# ------------------------
# in order to use API data collection, you will need to have an API key. This is issued to you 
# by the website and is unique to you. It is how the website knows that it is you
# who is requesting data from the API server. You will need to use your key in 
# any API data collection example, like in the script below.


# EXAMPLE -- using LendingClub's API to collect data.
# 
# NOTE -- do not run the code below, it will not actually work. It is merely
# provided here for illustrative purposes.
#

# find the url for their API server - in this case, retrieving your own account summary data.

# https://api.lendingclub.com/api/investor/<version>/accounts/<investor id>/summary
# where -
#      <version> - is the version of the API that the website provides to you. 
#                  You can find this in their documentation.
#      <investor id> - this will be your account number (this is explained in their
#                     documentation as well).

my_url <- 'https://api.lendingclub.com/api/investor/<version>/accounts/<investor id>/summary'

.my_key <- '(your API key here)'

# quick tip -- if you don't want your objects to be displayed in the R studio environment,
#              you can hide them by naming them with a leading period 
#              (e.g.,  .my_key   instead of   my_key  ).
#              They will still exist in your R session but will not be displayed in the environment.

# some websites will require you to add headers to your request. This is usually 
# where you will provide your API key. The website documentation will clarify this 
# for you though.

# create the API request and save it as an object.

r <- httr::GET(url = my_url, add_headers('Authorization' = .my_key))

# the r object will summarize the outcome of the request by listing 
# the response, the data, the status, content-type (usually will be json data), 
# and the size of the data. The status code will tell you whether the request 
# went through successfully or encountered an error. You can also just check
# the status code manually here by running   httr:status_code(r)

# we can play with the content by using the httr::content function. 
# The   as = 'text'   option below will give us raw text from the 
# javascript object, explaining the contents of the JSON data.

httr::content(x = r, as = 'text')

# now we can use the jsonlite package to convert the JSON content into 
# a useable R object (we are simplifying it to increase our chances 
# of successful conversion). In this case, we will get an R list object.

parsed <- jsonlite::fromJSON(txt = my_Contetn, simplifyVector = T)

# now we can sift through the various elements in this JSON 
# data object like usual, using the dollar sign operator.

parsed$availableCash # this would return the amount of cash left in your account as of data retrieval date.

