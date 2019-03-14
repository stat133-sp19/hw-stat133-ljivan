#Title: workout01_Shot Charts
#Description: The purpose of this script is to create shot charts
#Input:'andre-iguodala.csv', 'draymond-green.csv', 'kevin-durant.csv', '
#'klay-thompson.csv', and 'stephen-curry.csv', 'nba-court.jpg'
#output:'andre-iguodala-shot-chart.pdf', 'draymond-green-shot-chart.pdf' 
#'kevin-durant-shot-chart.pdf', 'klay-thompson-shot-chart.pdf', 
#'stephen-curry-shot-chart.pdf', 'gsw-shot-charts.pdf'
#Author: Jian Liu
#Date: 03/11/2019

library(jpeg)
library(grid)
library(ggplot2)
library(dplyr)

#read files and court image
shots_data <- read.csv('../data/shots-data.csv', stringsAsFactors = FALSE)
Iguodala <- filter(shots_data, name == 'Andre Iguodala')
Green <- filter(shots_data, name == 'Draymond Green')
Durant <- filter(shots_data, name == 'Kevin Durant')
Thompson <- filter(shots_data, name == 'Klay Thompson')
Curry <- filter(shots_data, name == 'Stephen Curry')
court_file <- '../images/nba-court.jpg'

#create raste object
court_image <- rasterGrob(
  readJPEG(court_file),
  width = unit(1, "npc"),
  height = unit(1, "npc")
)

#4.1 Shot charts with court background for each player
Iguodala_shot_chart <- ggplot(data = Iguodala) +
  annotation_custom(court_image, -250, 250, -50, 420) + 
  geom_point(aes(x = x, y = y, color = shot_made_flag)) + 
  ylim(-50, 420) +
  ggtitle('Shot Chart: Andre Iguodala (2016 season)') + 
  theme_minimal()
ggsave(
  filename = '../images/andre-iguodala-shot-chart.pdf',
  width = 6.5, height = 5, units = "in")

Green_shot_chart <- ggplot(data = Green) +
  annotation_custom(court_image, -250, 250, -50, 420) + 
  geom_point(aes(x = x, y = y, color = shot_made_flag)) + 
  ylim(-50, 420) +
  ggtitle('Shot Chart: Draymond Green (2016 season)') + theme_minimal()
ggsave(
  filename = '../images/draymond-green-shot-chart.pdf',
  width = 6.5, height = 5, units = "in")

Durant_shot_chart <- ggplot(data = Durant) +
  annotation_custom(court_image, -250, 250, -50, 420) + 
  geom_point(aes(x = x, y = y, color = shot_made_flag)) + 
  ylim(-50, 420) +
  ggtitle('Shot Chart: Kevin Durant (2016 season)') + theme_minimal()
ggsave(
  filename = '../images/kevin-durant-shot-chart.pdf',
  width = 6.5, height = 5, units = "in")

Thompson_shot_chart <- ggplot(data = Thompson) +
  annotation_custom(court_image, -250, 250, -50, 420) + 
  geom_point(aes(x = x, y = y, color = shot_made_flag)) + 
  ylim(-50, 420) +
  ggtitle('Shot Chart: Klay Thompson (2016 season)') + theme_minimal()
ggsave(
  filename = '../images/klay-thompson-shot-chart.pdf',
  width = 6.5, height = 5, units = "in")

Curry_shot_chart <- ggplot(data = Curry) +
  annotation_custom(court_image, -250, 250, -50, 420) + 
  geom_point(aes(x = x, y = y, color = shot_made_flag)) + 
  ylim(-50, 420) +
  ggtitle('Shot Chart: Stephen Curry (2016 season)') + theme_minimal()
ggsave(
  filename = 'images/stephen-curry-shot-chart.pdf',
  width = 6.5, height = 5, units = "in")

#4.2) facetted shot chart
#create one graph, using facettin, to show all the shot charts in one image.

gsw_shot_charts <- ggplot(data = shots_data)+ 
  annotation_custom(court_image, -250, 250, -50, 420) + 
  geom_point(aes(x = x, y = y, color = shot_made_flag)) + 
  ylim(-50, 420) +
  facet_wrap(~ name)+
  ggtitle('Shot Chart: Shot Charts: GSW (2016 season)') + 
  theme_minimal()+ theme(legend.position="top")

ggsave(
  filename = '../images/gsw-shot-charts.pdf',
  width = 8, height = 7, units = "in")

png(filename= "../images/gsw-shot-charts.png",width = 768, height = 672 ,units = "px")
gsw_shot_charts
dev.off()







