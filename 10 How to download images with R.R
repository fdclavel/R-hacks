# --------------------------
# How to download images with R
# --------------------------

# continuing from script 9.1

# you can use this for image files or pdf files. First we need
# to find the source for the file we want. We're going to download 
# the matching photos for the actors on the IMDB list, using the 
# download function.


# get the node information for the images on the first page at:
# https://www.imdb.com/search/name/?gender=male,female&start=1&ref_=rlm
# this is what the object "pg" refers to.
pg %>% 
  html_nodes('img') %>% 
  html_attr('src')

# notice that the first few entries are not actually image files we want,
# rather they are pointing to something else. We can filter those out of
# the scraping process by targeting things that end with .jpg only, by using
# a subset function to parse things out of a vector based on the strings that
# we detect using the str_detect function.

actor_image <- pg %>% 
  html_nodes('img') %>% 
  html_attr('src') %>% 
  subset(x = ., str_detect(string = ., pattern = '.jpg'))

# lastly we can use the download.file function to batch download the image files 

#start with the first actor, Ben Barnes.
download.file(url = actor_image[1], destfile = "Actor1.jpg", mode = "wb")


