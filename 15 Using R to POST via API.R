# ----------------------------
# using R to POST actions to websites via API
# ----------------------------


# lets mount the packages we need.

library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)


# EXAMPLE -- using LendingClub's API to post orders. 
# 
# NOTE -- do not run the code below, it will not actually work. It is merely
# provided here for illustrative purposes.
#

# find the url for their API server - in this case, retrieving loan listing data for investors.

# https://api.lendingclub.com/api/investor/<version>/loans/listing
# where -
#      <version> - is the version of the API that the website provides to you. 
#                  You can find this in their documentation.
#      
#
# Before we post we have to decide what to invest in. Let's 
# retrieve the list of available loans, using the same code from script 14.

# we can do more stuff with this request. Listings can often be filtered
# on websites, and we can obtain and apply those filter codes to the url.
# typically you can find the filter codes in the website's API documentation.

# example (we're adding the   showALL   filter to the request this time)

u3 <- 'https://api.lendingclub.com/api/investor/<version>/loans/listing?showALL=true'

r3 <- httr::GET(url = u, add_headers('Authorization' = .my_key))
status_code(r3) #checking that it completed successfully.

# convert the JSON data into a tibble and save it as 'dt'.
dt <- httr::content(x = r2, as = 'text') %>% 
  jsonlite::fromJSON(txt = ., simplifyVector = T) %>% 
  .$loans %>% 
  as_tibble()
  

# We need to create an API POST request and save it as an object.
# before we do, we need to figure out which loans we want to invest in.
# to do so, we need to create an algorithm to decide which loans to decide on.
# For example:
#
# 1. We only want to invest in those loans that are already funded above a certain
#    percent threshold.
# 2. If the loan amount is more than 4% of the income, the loan is too risky, so
#    We won't want to invest in it.
# 3. We compute this filter, then we arrange the listings in order from the lowest to highest
#    according to this filter
# 4. We select the top two options (first two rows) for investment after they've 
#    been filtered and arranged.

# selecting the top two investments based on our 4% of income criterion
dt %>% 
  mutate(percent_funded = round(fundedAmount/loanAmount, 2), 
         pmt_to_inc = installment*12/annualInc) %>% 
  filter(pmt_to_inc <= .04) %>% 
  arrange(pmt_to_inc) %>%
  .[1:2,] %>% 
  select(percent_funded, installment, pmt_to_inc, annualInc, everything())

# now that we've selected the top two, we can invest using the post function. We 
# can replicate the pipeline above to make these investments.

# selecting the top two investments based on our 4% of income criterion and investing $25 in each
buy <- dt %>% 
  mutate(percent_funded = round(fundedAmount/loanAmount, 2), 
         pmt_to_inc = installment*12/annualInc,
         requestedAmount = 25) %>% 
  filter(pmt_to_inc <= .04) %>% 
  arrange(pmt_to_inc) %>%
  .[1:2,] %>% 
  select(loanId = id, requestedAmount)

# create a list to pass into the post function. According to the documentation,
# a sample of the POST request data takes on the form of a list with 2 elements: 
#
# 1. the account ID (aid) and the orders you want to submit (which is simply the 
# 2. investments we identified in the "buy" data frame above)

# create the list of two elements.
buy_post <- list('aid' = '<your account ID>',
                 'orders' = buy)

# convert this list into a JSON object to pass to the buying API via POST function.

toJSON(buy_post)

# grab the API url for buying notes (aka investing)

u4 <- 'https://api.lendingclub.com/api/investor/<version>/accounts/<your account ID>/orders'

# make the investment of $25 in two loans

r4 <- httr::POST(url = u4, 
                 body = buy_post,
                 encode = 'json',
                 add_headers('Authorization' = .my_key))


# ----------------------------
# Another important step - 
# After using POST, use API to get a 
# record of what you've just done.
# ----------------------------

# we pull the two listings that we bought from the data frame 
# that we put together initially to make the investment.

# first we pass those loan IDs from the 'buy' list that we 
# purchased from into their own object.

loanID <- buy$loanID

# then we grab just those IDs from the larger data frame of listings
dt %>% 
  filter(id %in% loanID)  #filtering for those id numbers that occur in the 

# write the data for those two IDs into their own csv file.
write_csv(x = bought, path = paste0('LC_Bought_', today(), '.csv'))


