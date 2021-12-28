rm(list=ls())

library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
getwd() #displays your working directory
setwd("/Users/joe/Documents/Data Analysis/Gitrepos/23. Bike/Divvy_Exercise/") #sets your working directory to simplify calls to data ... make sure to use your OWN username instead of mine ;)


#=====================
# STEP 1: COLLECT DATA
#=====================
# Upload Divvy datasets (csv files) here
df_202004<- read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202004-divvy-tripdata.csv")
df_202005<- read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202005-divvy-tripdata.csv")
df_202006<- read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202006-divvy-tripdata.csv")
df_202007 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202007-divvy-tripdata.csv")
df_202008 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202008-divvy-tripdata.csv")
df_202009 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202009-divvy-tripdata.csv")
df_202010 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202010-divvy-tripdata.csv")
df_202011 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202011-divvy-tripdata.csv")
df_202012 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202012-divvy-tripdata.csv")
df_202012 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202012-divvy-tripdata.csv")
df_202101 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202101-divvy-tripdata.csv")
df_202102 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202102-divvy-tripdata.csv")
df_202103 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202103-divvy-tripdata.csv")
df_202104 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202104-divvy-tripdata.csv")
df_202105 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202105-divvy-tripdata.csv")
df_202106 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202106-divvy-tripdata.csv")
df_202107 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202107-divvy-tripdata.csv")
df_202108 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202108-divvy-tripdata.csv")
df_202109 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202109-divvy-tripdata.csv")
df_202110 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202110-divvy-tripdata.csv")
df_202111 <-read_csv("~/Documents/Data Analysis/Gitrepos/23. Bike/202111-divvy-tripdata.csv")

 
#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# While comparing the  column names each of the files we found no mismtach between the column names
# so we joined the dataframes and then changed the column names as follows

# Converting the station ID from double to character before joining

df_202004$start_station_id <- as.character(df_202004$start_station_id)
df_202005$start_station_id <- as.character(df_202005$start_station_id)
df_202006$start_station_id <- as.character(df_202006$start_station_id)
df_202007$start_station_id <- as.character(df_202007$start_station_id)
df_202008$start_station_id <- as.character(df_202008$start_station_id)
df_202009$start_station_id <- as.character(df_202009$start_station_id)
df_202010$start_station_id <- as.character(df_202010$start_station_id)
df_202011$start_station_id <- as.character(df_202011$start_station_id)
df_202004$end_station_id <- as.character(df_202004$end_station_id)
df_202005$end_station_id <- as.character(df_202005$end_station_id)
df_202006$end_station_id <- as.character(df_202006$end_station_id)
df_202007$end_station_id <- as.character(df_202007$end_station_id)
df_202008$end_station_id <- as.character(df_202008$end_station_id)
df_202009$end_station_id <- as.character(df_202009$end_station_id)
df_202010$end_station_id <- as.character(df_202010$end_station_id)
df_202011$end_station_id <- as.character(df_202011$end_station_id)




# Stack individual data frames into one big data frame
df <- bind_rows(df_202004,df_202005,df_202006,df_202007,df_202008,df_202009,df_202010,df_202011,df_202012,
                df_202101,df_202102,df_202103,df_202104,df_202105,df_202106,df_202107,df_202108,df_202109,df_202110,
                df_202111)

# POSIX - Portable operating system interface
 
#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Inspect the new table that has been created
colnames(df)  #List of column names
nrow(df)  #How many rows are in data frame?
dim(df)  #Dimensions of the data frame?
head(df)  #See the first 6 rows of data frame.  Also tail(all_trips)
str(df)  #See list of columns and data types (numeric, character, etc)
summary(df)  #Statistical summary of data. Mainly for numerics


# There are a few problems we will need to fix:
# (1) The data can only be aggregated at the ride-level, which is too granular. We will want to add some additional columns of data -- such as day, month, year -- that provide additional opportunities to aggregate the data.
# (2) We will want to add a calculated field for length of ride  the  data did not have the "tripduration" column. 
# (3) There are some rides where tripduration shows up as negative, including several hundred rides where Divvy took bikes out of circulation for Quality Control reasons.
# We will want to delete these rides.


#(1) Making year, month day and time columns
df$date <- as.Date(df$started_at) #The default format is yyyy-mm-dd
df$month <- format(df$date, "%m")
df$day <- format(df$date, "%d")
df$year <- format(df$date, "%Y")
df$day_of_week <- format(df$date, "%A")


#if a subset does not contain any values from a specific level
# Begin by seeing how many observations fall under each usertype
table(df$member_casual)
table(df$member_casual,df$day_of_week)

#      Friday Monday Saturday Sunday Thursday Tuesday Wednesday
#casual 548146 415440   853238 713968   431272  400461    414837
#member 687496 623848   696248 595854   683687  689164    708660


# To see the preference of the member types on the types rideable bikes
table(df$member_casual,df$rideable_type)

 
# Add a "ride_length" calculation to all_trips (in seconds)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/difftime.html
df$ride_length <- difftime(df$ended_at,df$started_at)

 
# comparison of mean ride_length between member types
df %>% group_by(member_casual) %>% summarise(Me=mean(ride_length))
 
#boxplot( ride_length~member_casual,data=df)



# Convert "ride_length" from Factor to numeric so we can run calculations on the data
is.factor(df$ride_length)
df$ride_length <- as.numeric(as.character(df$ride_length))
is.numeric(df$ride_length)


# Remove  data rows that has negative ride lengths
 
# https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
df <- df[-which(df$ride_length<0),]


#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================
# Descriptive analysis on ride_length (all figures in seconds)
mean(df$ride_length) #straight average (total ride length / rides)
median(df$ride_length) #midpoint number in the ascending array of ride lengths
max(df$ride_length) #longest ride
min(df$ride_length) #shortest ride


# You can condense the four lines above to one line using summary() on the specific attribute
summary(df$ride_length)


# Compare members and casual users
aggregate(df$ride_length ~ df$member_casual, FUN = mean)
aggregate(df$ride_length ~ df$member_casual, FUN = median)
aggregate(df$ride_length ~ df$member_casual, FUN = max)
aggregate(df$ride_length ~ df$member_casual, FUN = min)


# See the average ride time by each day for members vs casual users
aggregate(df$ride_length ~ df$member_casual + df$day_of_week, FUN = mean)


# Notice that the days of the week are out of order. Let's fix that.
df$day_of_week <- ordered(df$day_of_week, 
                                    levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

aggregate(df$ride_length ~ df$member_casual + df$day_of_week, FUN = mean)
 


# analyze ridership data by type and weekday
df %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()                                                        #calculates the number of rides and average duration 
  ,average_duration = mean(ride_length)) %>%                 # calculates the average duration
  arrange(member_casual, weekday)                                                                # sorts


# Let's visualize the number of rides by rider type
df %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")


# Let's create a visualization for average duration
df %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")


#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================
# Create a csv file that we will visualize in Excel, Tableau, or my presentation software
 
write.csv(df, file = '~/Documents/Data Analysis/Gitrepos/23. Bike/Final.csv')


#You're done! Congratulations!

# To idenify the top station
start_station<- df %>% group_by(start_station_id) %>% summarize(ME=mean(ride_length))


## Saving data for Tableau

df_new<-df[,-c(1,3:12,14)]

write.csv(df_new, file = '~/Documents/Data Analysis/Gitrepos/23. Bike/Final.csv') 
 
# Using the Final.csv we ploted the figures in Tabuleau

