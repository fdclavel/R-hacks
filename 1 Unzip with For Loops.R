# install the R utils package to perform the unzip loop
install.packages('R.utils')
library(R.utils)

# list the files inside the "zip files" folder.
list.files(path = "Zip files/")

# use a for loop to loop over the four zip files inside the folder

  # list files that include 'gz' in the file name, and list by full name.
  list.files(path = "Zip files/", pattern = 'gz', full.names = T)

  # save this list to a vector so we can use it in a loop.
  myzipfile <- list.files(path = "Zip files/", pattern = 'gz', full.names = T)

  # use G unzip "gunzip" in R utils package to unzip a file based on its path in
  # the vector of zipfiles above. 
  # Note - this operation will also delete the original zip file, which isn't recommended
  # so we will use a different function below, and comment this out instead. It is
  # preserved for documentation purposes only.
  
  #R.utils::gunzip(myzipfile[1])
  
  # Instead we will make sure that "remove" is set to FALSE to prevent this issue.
  # Now we can build that function into a loop, and we don't have to explicitly call
  # R utils each time, since it's already mounted.
  
  for(i in myzipfile) {
    print(i)
    gunzip(i, remove=FALSE)
  }



  
  
  



  

