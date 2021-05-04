# --------------
# Web scraping exercise
# --------------


# 1. Go to https://www.imdb.com/, then click on Menu. Under Celebs, click on Most Popular Celebs



# 2. Copy the URL and paste it into a new R script.

# the url
u <- "https://www.imdb.com/search/name/?gender=male%2Cfemale&ref_=nv_cel_m"


# 3. Go back to the webpage and scroll down to the last actor. Click on Next to see the next page. Copy the URL and paste it under a new line in the R session

u2 <- "https://www.imdb.com/search/name/?gender=male,female&start=51&ref_=rlm"


# 4. Repeat step 3 once more.

u3 <- "https://www.imdb.com/search/name/?gender=male,female&start=101&ref_=rlm"

# 5. Do you see a pattern in these URLs?
# each new page starts with the number of the first entry, except the first. 
# however the first page can be brough up by modifying the pattern like this:
# "https://www.imdb.com/search/name/?gender=male,female&start=1&ref_=rlm"


# 6. Use the paste0() and the seq() functions to recreate the first six of these URLs.
urls <- paste0("https://www.imdb.com/search/name/?gender=male,female&start=", 
                seq(from=1, to=251, by=50), "&ref_=rlm")

pg <- read_html(urls[1])

# 7. Go back to the first page and open the Selector Gadget or the Inspector in your browser



# 8. Get the node for the actors' names, go to R and scrape all the actors' names from that first page. Save it under a variable; call it actor

actor <- pg %>% 
  html_nodes(".lister-item-header a") %>% 
  html_text(trim=T)


# 9. Repeat step 9 but get this time get the text underneath the actor's name. Save this variable as about_actor

about_actor <- pg %>% 
  html_nodes(".text-small a") %>% 
  html_text(trim=T)

# 10. Get the link under the actor's name. Use the paste0() function to complete these URLs and save them in a variable called actor_link
links <- pg %>% 
  html_nodes(".lister-item-header a") %>% 
  html_attr('href')

actor_link <- paste0("http://www.imdb.com", links)

# 11. Create a tibble containing the actor's name, the text about them, and the URL link for each actor

tibble(actor, about_actor, actor_link)

# 12. Create a function that wraps the two scrapers from steps 9 and 10. The input to this function should be the URLs that you created in step 6

my_scraper <- function(x) {

Sys.sleep(time = sample(x = 6:17, size = 1, replace = T))
    
pg <- read_html(x)

actor <- pg %>% 
  html_nodes(".lister-item-header a") %>% 
  html_text(trim=T)


about_actor <- pg %>% 
  html_nodes(".text-small a") %>% 
  html_text(trim=T)

links <- pg %>% 
  html_nodes(".lister-item-header a") %>% 
  html_attr('href')

actor_link <- paste0("http://www.imdb.com", links)

tibble(actor, about_actor, actor_link)
  
}

# 13. Test your function with the link to one of the pages

my_scraper(urls[1])

# 14. Write a loop that would loop through the links in step 6 and save the data in a tibble. Save it in a variable called dat. Make sure the add some random sleep time or risk being blocked by the administrator of the webpage you're getting the data from.
actor_data <- urls %>% 
  map_df(.x = . , .f = my_scraper)


# 15. Write the data from step 14 to your working directory as a CSV file.

# this is custom cleanup code for my own sake.
Rank <- seq(1:300)
data <- tibble(Rank, Actor = actor_data$actor, 
               Best.Known.For = actor_data$about_actor, 
               IMDB.link = actor_data$actor_link )



write_csv(data, path="Actor Data.csv", col_names=T)
