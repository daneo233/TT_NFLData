library(tidyverse)
#reading data direct from github. need to use raw to get the actual file
data <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2018-08-28/nfl_2010-2017.csv")
head(data)
#initial guess on plotting averages of rushing and receiving. individual player season averages messes this up
RushData %>% ggplot() +
  geom_point(aes(x=rush_avg, y=rec_avg))
#filtered to only better rushers
RushData <- filter(data, data$rush_avg>4)
#trying to see the actual position symantics
data$position
summarize(data$position)
head(data)
#Grouping data by team and year, and establishing new variables
#for the rush and receiving data
GroupedData <-group_by(data, team, game_year) %>% 
  summarize(rush_yds=sum(rush_yds, na.rm=TRUE), rush_avg=sum(rush_yds, na.rm=TRUE)/sum(rush_att, na.rm=TRUE), rush_tds=sum(rush_tds, na.rm=TRUE), rec_yds=sum(rec_yds, na.rm=TRUE), rec_avg=sum(rec_yds, na.rm=TRUE)/sum(rec, na.rm=TRUE), rec_tds=sum(rec_tds, na.rm=TRUE))
head(GroupedData)
#plotting out the points. still messy too many teams and years
GroupedData  %>%  ggplot(aes(x=rush_avg, y=rec_avg)) +
  geom_point()+
  geom_text(mapping=aes(label=team))
#filtered to just the 2016 year
GroupedData %>% filter(game_year=="2016") %>%
  ggplot(aes(x=rush_avg, y=rec_avg)) +
  geom_text(mapping=aes(label=team))
#creating a new basic variable that is the 
#"sum average" of rushing and receiving data specifically for GB
GroupedData %>% mutate(sum_avg=rush_avg+rec_avg) %>%
  filter(team=="GB") %>%
  ggplot(aes(x=game_year, y=sum_avg)) +
  geom_line()
