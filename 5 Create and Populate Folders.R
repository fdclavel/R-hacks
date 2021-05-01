# start by removing the Weather folder from the previous script.
# this should result in a 'permission denied' error, which we will 
# fix next.

file.remove("1 R Hacks/Weather")

# we need to use the unlink function to get around this.

unlink(x = "1 R Hacks/Weather", recursive=T)


# now we can recreate this folder and its contents.

dir.create(path = "1 R Hacks/Weather")

# now let's recreate the folders using the same paste0 function we used before.
y <- 2016
paste0("1 R Hacks/", "Weather/", y)

# now wrap it in a simple function to loop through the years 
# and create folders for each year, combining both steps above

path_func <- function(y) {
  dir.create(path=paste0("1 R Hacks/", "Weather/", y))
}

# test it real quick. it should create a folder named whatever you specify here.

path_func(2020) #creates a 2020 folder.

#delete this again and recereate it empty so we can do a clean walk loop.

unlink(x = "1 R Hacks/Weather", recursive=T)
dir.create(path = "1 R Hacks/Weather")

# now we use a walk to create the 2017-2020 folders again
# we're going to do this with pipe functions to streamline things a bit. 
# The '.' for x is telling the walk function to use the values that are being piped in.

2017:2020 %>% walk(.x = ., .f= path_func)


# now we can repopulate the folders by grabbing the csv files
# from the zip files folder that they're currently in. We can use the read_csv 
# function from the tidyverse readr package.
# NOTE - don't use read.csv - this one will take a really long time 
# with large data sets like this one, which is over 1GB. Because this 
# file has 34 million rows, we aren't going to read the entire thing.
# Instead we just read the first 200,000 to illustrate.

read_csv(file = "Zip files/2017.csv", col_names=F, n_max = 200000)

# we can also use readr to write files.
# basic argument is:
#write_csv(x = , path =)
#
# we will use pipe function to pipe the read function into the write function to read the file from the 'zip files' folder and write the csv anew to the Weather folder.

read_csv(file = "Zip files/2017.csv", col_names = F, n_max = 200000) %>%
  write_csv(x=., path = "1 R Hacks/Weather/2017/2017.csv")

# we can also bundle both into a custom function. To change the year 
# dynamically based on whatever y is, we need to use the paste0 function again.

read_n_write <- function(y) {
  read_csv(file = paste0("Zip files/", y, ".csv"), col_names = F, n_max = 200000) %>%
  write_csv(x=., path = paste0("1 R Hacks/Weather/",y, "/", y, ".csv"))
}

#test it with 2018. should copy the 2018 csv file and paste it to Weather/2018

read_n_write(2018)

#now we can use a pipelined walk function again to fill them all with a 200K row data file for each year.

2017:2020 %>% walk(.x = ., .f= safely(read_n_write))

