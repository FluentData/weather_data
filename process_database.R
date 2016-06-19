library(ISDr)

con <- dbConnect(RSQLite::SQLite(), "D:/Weather/ISD_Indiana.sqlite")
dbListTables(con)
errors <- dbReadTable(con, "Download_Errors")
readings <- dbReadTable(con, "Readings")
dbDisconnect(con)

history <- getISDhistory() %>%
  mutate(USAF = as.integer(USAF),
         WBAN = as.integer(WBAN))

in_stations <- readings %>% 
  select(USAF, WBAN) %>%
  distinct() %>%
  left_join(history) %>%
  mutate(ID = seq_along(USAF)) %>%
  rename(STATION_NAME = STATION.NAME, ELEV_M = ELEV.M.) %>%
  select(ID, USAF:END)

readings_ <- readings %>%
  left_join(select(in_stations, ID:WBAN)) %>%
  select(ID, DATE:SEA_LEVEL_PRESSURE_QUALITY)

con <- dbConnect(RSQLite::SQLite(), "D:/Weather/weather_Indiana.sqlite")
dbListTables(con)
dbWriteTable(con, "readings", readings_)
dbWriteTable(con, "stations", in_stations)
dbWriteTable(con, "codes", ISD_lookup)
dbListTables(con)
dbDisconnect(con)
