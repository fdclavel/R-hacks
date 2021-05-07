# using R to get data via API using pipelines


# lets mount the packages we need.

library(httr)
library(jsonlite)
library(tidyverse)


# EXAMPLE -- using LendingClub's API to collect data, this time we're collecting data
#            on the listings available for purchase.
# 
# NOTE -- do not run the code below, it will not actually work. It is merely
# provided here for illustrative purposes.
#

# find the url for their API server - in this case, retrieving your own account summary data.

# https://api.lendingclub.com/api/investor/<version>/loans/listing
# where -
#      <version> - is the version of the API that the website provides to you. 
#                  You can find this in their documentation.
#      

u2 <- 'https://api.lendingclub.com/api/investor/<version>/loans/listing'

.my_key <- '(your API key here)'

# quick tip -- if you don't want your objects to be displayed in the R studio environment,
#              you can hide them by naming them with a leading period 
#              (e.g.,  .my_key   instead of   my_key  ).
#              They will still exist in your R session but will not be displayed in the environment.

# some websites will require you to add headers to your request. This is usually 
# where you will provide your API key. The website documentation will clarify this 
# for you though.

# recreate the API request and save it as an object.

r2 <- httr::GET(url = u2, add_headers('Authorization' = .my_key))

# the r object will summarize the outcome of the request by listing 
# the response, the data, the status, content-type (usually will be json data), 
# and the size of the data. The status code will tell you whether the request 
# went through successfully or encountered an error. You can also just check
# the status code manually here by running   httr:status_code(r)

# we can play with the content by using the httr::content function. 
# The   as = 'text'   option below will give us raw text from the 
# javascript object, explaining the contents of the JSON data.

httr::content(x = r2, as = 'text')


# we can do more stuff with this request. Listings can often be filtered
# on websites, and we can obtain and apply those filter codes to the url.
# typically you can find the filter codes in the website's API documentation.

# example (we're adding the   showALL   filter to the request this time)

u3 <- 'https://api.lendingclub.com/api/investor/<version>/loans/listing?showALL=true'

r3 <- httr::GET(url = u, add_headers('Authorization' = .my_key))

# now we can use the jsonlite package to convert the JSON content into 
# a useable R object - this time we're streamlining the process
# by using pipelines via tidyverse. we want to obtain the 'loans' element of
# the JSON list object, and turn it into a tibble.

httr::content(x = r2, as = 'text') %>% 
  jsonlite::fromJSON(txt = ., simplifyVector = T) %>% 
  .$loans %>% 
  as_tibble()
  




# now we can sift through the various elements in this JSON 
# data object like usual, using the dollar sign operator.

parsed$availableCash # this would return the amount of cash left in your account as of data retrieval date.

# next script will involve using GET to obtain data frames or tibbles.