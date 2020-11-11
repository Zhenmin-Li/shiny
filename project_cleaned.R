library(dplyr)
library(lubridate)

#Load the data

tweets <- timetk::tk_tbl(data.table::fread("source_data/tweets_total.csv", encoding= "UTF-8"))

tweets$date <- ymd(tweets$date)
tweets <- tweets%>% filter(date >= "2016-07-18" & date <= "2022-10-18")#I leave a filter

date <- data.frame(date = seq(as.Date("2020-02-01"), as.Date("2020-10-18"), by = 1))
state <- distinct(tweets, location)
map <- merge(x = date, y = state, by = NULL)


temp <- tweets[,c("date","location","polarity")]


map <- map %>%
  full_join(temp, by = c("date","location")) 

map[is.na(map)] <-  runif(sum(is.na(map)), min = -1, max = 1)

data <- map %>% filter(date <= '2020-10-18' & location != 'Washington dc')

n <- data[3,c("location","date")];

k <- data.frame(date=as.Date(character()),
                location=character(), 
                polarity=numeric(),
                stringsAsFactors=FALSE)
curr1 <- data.frame(date=as.Date(character()),
                    location=character(), 
                    polarity=numeric(),
                    stringsAsFactors=FALSE)

for (row in 1:nrow(data)) {
  m <- data[row,c("location","date")];
  if(m[1,'location'] == n[1,'location'] & m[1,'date'] == n[1,'date']){
    next
  }
  else{
    k <- data[row,c("location","date", "polarity")]
    curr1 <- rbind(curr1,k)
    #print(k)
  }
  n <- data[row,c("location","date")];
}

write.csv(curr1,'derived_data/sentiment_afinn_ran.csv',row.names=FALSE)

# inputdate='2020-02-22'
# curr <- subset(curr1 %>% filter(date == inputdate),select=c(location, polarity))
# 
# 
# curr_list <- tibble::deframe(curr)
# 
# library(plotly)
# 
# g <- list(
#   scope = 'usa',
#   projection = list(type = 'albers usa'),
#   lakecolor = toRGB('white')
# )
# 
# plot_geo() %>%
#   add_trace(
#     z = ~curr_list, text = state.name, span = I(0),
#     locations = state.abb, locationmode = 'USA-states'
#   ) %>%
#   layout(geo = g)
# 
# ggplot(curr, aes(reorder(location, polarity), polarity)) + 
#   geom_col(aes(fill = location)) + coord_flip() + 
#   labs(x = "Team", y = "PTS") + 
#   geom_hline(aes(yintercept = mean(polarity)), color = "red")
# 
# ggplotly(ggplot(curr, aes_string('location'))+geom_histogram(aes(fill=location),
#                                                            position="dodge"));
