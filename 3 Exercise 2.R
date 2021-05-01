# Exercise 2

# 1 load the tidyverse and R.utils libraries
library(R.utils)
library(tidyverse)

# 2 list files in the zip files/Exercise Data/ path. Get the full path.
list.files(path = "Zip files/Excersise Data/", full.names = T)


# 3 save these paths to a vector. Call it myzipfile2
myzipfile2 <- list.files(path = "Zip files/Excersise Data/", full.names = T)


# 4 use a for() loop to unzip these files. Make sure to use remove = F to keep both the zipped and unzipped files
for (i in myzipfile2){
  print(i)
  gunzip(i, remove=F)
}


# 5 Use one of the following ways to delete the .csv files you just unzipped. We want to redo it with a walk
#   a manually remove by selecting the file and removing them or
#   b run these scripts


   #method 1
   file.remove("Zip files/Excersise Data/2013.csv")

   #method 2
   rm_files <- list.files(path = 'Zip files/Excersise Data/', pattern = 'csv$', full.names = T)

   #method 3
   walk(.x = rm_files, .f = file.remove)


# 6 use the walk() function to unzip the same files in the Exercise Data/folder
walk(.x=myzipfile2, .f=safely(gunzip), remove=F)


