# --------------
# Web scraping exercise
# --------------


# 1. Go to https://www.imdb.com/, then click on Menu. Under Celebs, click on Most Popular Celebs



# 2. Copy the URL and paste it into a new R script.



# 3. Go back to the webpage and scroll down to the last actor. Click on Next to see the next page. Copy the URL and paste it under a new line in the R session



# 4. Repeat step 3 once more.



# 5. Do you see a pattern in these URLs?



# 6. Use the paste0() and the seq() functions to recreate the first six of these URLs.



# 7. Go back to the first page and open the Selector Gadget



# 8. Get the node for the actors' names, go to R and scrape all the actors' names from that first page. Save it under a variable; call it actor



# 9. Repeat step 9 but get this time get the text underneath the actor's name. Save this variable as about_actor



# 10. Get the link under the actor's name. Use the paste0() function to complete these URLs and save them in a variable called actor_link



# 11. Create a tibble containing the actor's name, the text about them, and the URL link for each actor



# 12. Create a function that wraps the two scrapers from steps 9 and 10. The input to this function should be the URLs that you created in step 6



# 13. Test your function with the link to one of the pages



# 14. Write a loop that would loop through the links in step 6 and save the data in a tibble. Save it in a variable called dat. Make sure the add some random sleep time or risk being blocked by the administrator of the webpage you're getting the data from.



# 15. Write the data from step 14 to your working directory as a CSV file.
