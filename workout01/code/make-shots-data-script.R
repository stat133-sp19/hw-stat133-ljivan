#Description: The purpose of this script is to create a csv data file 
#shots-data.csv that will contain the required variables to be used in 
#the visualization phase.
#Input:'andre-iguodala.csv', 'draymond-green.csv', 'kevin-durant.csv',
#'klay-thompson.csv', and 'stephen-curry.csv'
#output:'shots-data-summary.txt','andre-iguodala-summary.txt',
#'draymond-green-summary.txt', 'kevin-durant-summary.txt', 
#'klay-thompson-summary.txt', and 'stephen-curry-summary.txt'  
#Author: Jian Liu
#Date: 03/11/2019

library(dplyr) 

setwd('/Users/Ivan/Desktop/hw-stat133/workout01')
# reading files with relative path
Iguodala <- read.csv('data/andre-iguodala.csv', stringsAsFactors = FALSE)
Green <- read.csv('data/draymond-green.csv', stringsAsFactors = FALSE)
Durant <- read.csv('data/kevin-durant.csv', stringsAsFactors = FALSE)
Thompson <- read.csv('data/klay-thompson.csv', stringsAsFactors = FALSE)
Curry <- read.csv('data/stephen-curry.csv', stringsAsFactors = FALSE)
Curry

#Add a column name to each imported data frame that contains the name of the corresponding player
Iguodala <- cbind(name = "Andre Iguodala", Iguodala)
Green <- cbind(name = "Draymond Green", Green)
Durant <- cbind(name = "Kevin Durant", Durant)
Thompson <- cbind(name = "Klay Thompson", Thompson)
Curry <- cbind(name = "Stephen Curry", Curry)

#Change the original values of shot_made_flag to more descriptive values:
#replace "n" with "shot_no", and "y" with "shot_yes"
Iguodala$shot_made_flag[Iguodala$shot_made_flag == "n"] <- "shot_no"
Iguodala$shot_made_flag[Iguodala$shot_made_flag == "y"] <- "shot_yes"

Green$shot_made_flag[Green$shot_made_flag == "n"] <- "shot_no"
Green$shot_made_flag[Green$shot_made_flag == "y"] <- "shot_yes"

Durant$shot_made_flag[Durant$shot_made_flag == "n"] <- "shot_no"
Durant$shot_made_flag[Durant$shot_made_flag == "y"] <- "shot_yes"

Thompson$shot_made_flag[Thompson$shot_made_flag == "n"] <- "shot_no"
Thompson$shot_made_flag[Thompson$shot_made_flag == "y"] <- "shot_yes"

Curry$shot_made_flag[Curry$shot_made_flag == "n"] <- "shot_no"
Curry$shot_made_flag[Curry$shot_made_flag == "y"] <- "shot_yes"

#Add a column minute that contains the minute number where a shot occurred.
Iguodala$minute <- Iguodala$period*12-Iguodala$minutes_remaining
Green$minute <- Green$period*12-Green$minutes_remaining
Durant$minute <- Durant$period*12-Durant$minutes_remaining
Thompson$minute <- Thompson$period*12-Thompson$minutes_remaining
Curry$minute <- Curry$period*12-Curry$minutes_remaining

#Use sink() to send the summary() output of each imported data frame into individuals text files
sink(file='output/andre-iguodala-summary.txt' )
summary(Iguodala)
sink()

sink(file='output/draymond-green-summary.txt' )
summary(Green)
sink()

sink(file='output/kevin-durant-summary.txt' )
summary(Durant)
sink()

sink(file='output/klay-thompson-summary.txt' )
summary(Thompson)
sink()

sink(file = 'output/stephen-curry-summary.txt' )
summary(Curry)
sink()

#Use the row binding function rbind() to stack the 
#tables into one single data frame (or tibble object).
shots_data <- rbind(Iguodala, Green, Durant, Thompson, Curry)


#Export (i.e. write) the assembled table as a CSV file 
#shots-data.csv inside the folder data/. 
write.csv(shots_data, file = 'data/shots-data.csv', row.names = FALSE )


#Use sink() to send the summary() output of the assembled table. 
#Send this output to a text file named shots-data-summary.txt inside the output/ folder.
sink(file = 'output/shots-data-summary.txt')
summary(shots_data)
sink()




