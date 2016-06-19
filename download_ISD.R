library(ISDr)
source("loadISDdatabase.R")

history <- getISDhistory() 

indiana <- history %>%
  filter(STATE == "IN") %>%
  mutate(BEGIN = as.integer(substr(BEGIN, 1, 4)),
         END = as.integer(substr(END, 1, 4))) %>%
  filter(BEGIN >= 1999) %>%
  apply(1, function(row){
    begin <- as.integer(row["BEGIN"])
    if(is.na(begin)){
      begin <- 1999
    }
    end <- as.integer(row["END"])
    if(is.na(end)){
      end <- 2016
    }
    data.frame(USAF = row["USAF"], WBAN = row["WBAN"],
               YEAR = seq(begin, end),
               stringsAsFactors = FALSE)})

indiana <- Reduce(rbind, indiana)



apply(indiana, 1, function(row, history){
  df <- downloadISD(row["USAF"], row["WBAN"], row["YEAR"], history = history)
  loadISDdatabase(df, "D:/Weather/ISD_Indiana.sqlite", "Readings", "Download_Errors")
}, history = history)