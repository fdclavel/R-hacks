library(tidyverse)

# Using map function from tidyverse is similar to using the walk function, it automates processes.

# let's use it to compute square roots across a vector
sqrt(100)

# computing the square roots of integers 1 through 10. Doing it
# this way returns a list object.
1:10 %>% map(.x = ., .f = sqrt)

# doing it using map_dbl will return a vector instead
1:10 %>% map_dbl(.x = ., .f = sqrt)

# what's nice is we can make our code more streamlined by 
# eliminating redundant calls. the following will return the same
# vector as the previous call. When piping in objects, you don't need
# redundantly specify them as ".x" inside the map function.

1:10 %>% map_dbl(sqrt)

# now let's use map_chr to get the info as strings instead.
1:10 %>% map_chr(sqrt)

# ------------------
# USING MAP DF
# ------------------

# Now we use one of the more powerful functions - map_df.

# We can use map_df to take multiple data frames and concatenate them/append them.
# This can be very helpful if you are working in a context
# where you have dozens, hundreds, or even thousands of smaller 
# data files that you'd like to merge together into one larger data frame in R.

# first we need to create a vector to point us toward the data files we wish to
# concatenate.

# find all files in this folder
list.files(path = "Zip files/")

# find all files in this folder that contain "20" in the file name
list.files(path = "Zip files/", pattern = "20")

# find all files in this folder that end with "20" (none of them do)
list.files(path = "Zip files/", pattern = "20$")

# find all files in this folder that begin with "20" (they all do)
list.files(path = "Zip files/", pattern = "*20")

# find all files in this folder that end with ".csv" (only the data sets end this way)
list.files(path = "Zip files/", pattern = ".csv$")

# now that we have this list, we can use it as a vector
# and pipe it directly into the map function to map data sets together.
#
# NOTE - if you run this without specifying the number of rows (n_max), 
# you will get a MASSIVE data set that is about 5GB in size. Instead, we 
# use n_max to extract just the first 5,000 rows from each data file. These 
# data files also lack a header row, so col_names is set to FALSE.
#
# ALSO NOTE that with map, you place the function parameters after a comma,
# rather than within an internal set of parentheses (we'll do it differently in the 
# next step).

weather_data <- list.files(path = "Zip files/", pattern = ".csv$", full.names = T) %>%
  map_df(read_csv, col_names = F, n_max = 5000)

# Alternatively you can specify this a slightly different way, using
# formulaic specifications for the read_csv function. Both deliver the same result.

weather_data2 <- list.files(path = "Zip files/", pattern = ".csv$", full.names = T) %>%
  map_df(~read_csv(file=., col_names = F, n_max = 5000))



# ------------------
# other potential uses of map functions
# ------------------

# generating random numbers from a normal distribution
rnorm(n = 100, mean = 5, sd = 3)

# using map to repeatedly select n numbers from a normal distribution k times

k = 1:10 #define k before piping it in

k %>% map(rnorm, n = 100)

# alternatively use the formula format to specify things inside parentheses.
k %>% map(~rnorm(n = 100, mean = 5, sd = 1))

# we can also pipe mapped information into other map functions. 
# For example, we can draw those random samples and then compute their
# means with another map function. In this example, each one should be near 5.

k %>% 
  map(~rnorm(n = 100, mean = 5, sd = 1)) %>%
  map_dbl(mean)

# Just for fun, you can also place the "." inside the map function to alter
# the results. For example, if you specify the mean as ".", then it will fix 
# the means for each random sample close to whatever iteration number it is
# currently working on. So if we run the above again in this way, the result
# will be a vector of means that approximate 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10.

k %>% 
  map(~rnorm(n = 100, mean = ., sd = 1)) %>%
  map_dbl(mean)









