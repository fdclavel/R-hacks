# -----------------------
# Collecting data using web scraping
# -----------------------

# We can collect data from IMDB's top 100 movie rankings via R and analyze them. we 
# will need to use the rvest package to accomplish this.

# install and mount.
#install.packages("rvest")
library(rvest)

#assign the url that you want to collect data from.
u <- "https://www.imdb.com/chart/moviemeter/?sort=nv,desc&mode=simple&page=1"

# use the read_html function in rvest to store the page in R.
page <- read_html(u)

# next you will need to collect code from the URL you want to scrape.

# retrieve the titles from this page using the html_node function 
#
# NOTE - classes should be fed in as .[class] in this function. Example below
# uses ".titleColumn" instead of "titleColumn" in the function.
#
# ALSO NOTE - you can use "html_nodes" instead, and it will return every object in that
# class that's on the website.
#
# the html_text function will return the text from the node function
# (using "trim" will help remove some of the white space and the \n spacer tags).

page %>% 
  html_node(".titleColumn") %>%
  html_text(trim = T)

# we can use html_nodes to retrieve all of the movie titles, and
# by specifying ".titleColumn a" we only get the titles themselves, and not the
# additional data we don't need, as seen in the previous step.

title <- page %>% 
  html_nodes(".titleColumn a") %>%
  html_text(trim = T)

# we can do the same for the  movie years
year <- page %>%
  html_nodes("a+ .secondaryInfo") %>%
  html_text(trim = T)

# this variable comes up as characters because the IMDB info is in parentheses each time. We can simply use the parse_number function with the year to create a numerical version.
year <- parse_number(year)

# now let's grab the ratings
ratings<- page %>%
  html_nodes("strong") %>%
  html_text(trim = T) %>%
  parse_number()

# Note that not all of the 100 movies have ratings assigned. We need to autofill 
# the missing entries, so that we can put the three variables together into a data frame.

n_missing <- length(title) - length(ratings)

# compute the NAs using the base rep function
rep(x = NA, n_missing)

# using rep to add the remaining NAs
ratings <- c(ratings, rep(x=NA, n_missing))

# we can also scrape links using the html_attr function
# NOTE - this will scrape relative links, so the main url domain will be missing. 
# we can fill this in after.
links <- page %>% 
  html_nodes(".titleColumn a") %>%
  html_attr('href')

# add the leading url using the paste0 function again
links <- paste0("www.imdb.com", links)


# now we're ready to create a data frame with these pieces of information.
dat <- tibble(title, year, rating = ratings, link = links)

# we can play around with this data set like any other now.
# e.g., filtering those that were made in 2018 and have a rating higher than 7.5

dat %>% filter(year == 2018 & rating >= 7.5)
