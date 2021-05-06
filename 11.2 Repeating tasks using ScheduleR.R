# ---------------------
# Scraping data repeatedly using scheduleR
# (part 2 - the scheduler script)
# ---------------------

# Scraping web information often requires multiple runs. Many websites have content that 
# changes often. This can occur yearly, monthly, weekly, hourly, or even second by 
# second (e.g., stock prices). Getting updated data would normally require that 
# you physically reopen R and re-scrape the web pages each time
# you need an update. Instead, we can use ScheduleR to automate the 
# process of running repeated scrape functions over time. ScheduleR
# will run any script you specify when you specify it.

# one other thing, when you run ScheduleR scripts, you will receive a log file
# that contains output from the steps in the script. In order
# to make this log file legible, we need to insert programmatic spaces
# in the script using the   cat('\n')   function at any points where there 
# is a function or piece of code that prints something. Otherwise, the log file 
# will be very crowded and hard to read.

# First install the task scheduler package.
install.packages("taskscheduleR")
library(taskscheduleR)


# the three most important functions in the taskscheduleR package (arguably) are:
#
#  1. _create -- let's you create schedulers.
#  2. _delete -- remove currently running schedulers. Important for any tasks that 
#                you no longer require to be running continuously (e.g., you have 
#                a scheduler pulling apartment listing info every week, but you just 
#                finished moving into the apartment you found.)
#  3. _ls     -- list all currently active schedulers. Useful to check in case you have 
#                multiple schedulers running and you've forgotten about some of them. Only
#                delete tasks that you have created (some will be BIOS processes that keep
#                your computer running properly).


# now we use the create function to make a scheduler

# we will need: 1) task name, 2) r script to point to, 3) schedule information
# note, because the length in the working directory is too long (max 261 chars.), 
# I copied the Zillow scraper script to a folder closer to root. Insert your own 
# file path for your R script below, bearing this limitation in mind.

taskscheduler_create(taskname = 'MyZillowScheduler',
                    rscript = '[your path here]',
                    schedule = 'WEEKLY',
                    starttime = '23:37',
                    startdate = '05/05/2021',
                    days = c('WED')
                     )

# NOTE - if your task runs incorrectly, check the log file it generates. 
# Before you revise and re-run it, be sure to delete the currently running task
# using the taskscheduler_delete function first.

taskscheduler_delete(taskname = 'MyZillowScheduler')
taskscheduler_ls()


