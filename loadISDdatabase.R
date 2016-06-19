# x <- downloadISD(usaf = 720266, wban = 54809, year = 2015, getISDhistory(),
#                  parameters = c("USAF", "WBAN", "DATE", "TIME", "LATITUDE",
#                                 "LONGITUDE", "WIND_DIR", "WIND_SPEED", "TEMP",
#                                 "DEW_POINT_TEMP", "SEA_LEVEL_PRESSURE"))
# y <- downloadISD(43, 33, year = 2015, getISDhistory())



#' @export
loadISDdatabase <- function(ISD_data, sqliteDB, readings_table, error_table,
                            append = TRUE, overwrite = FALSE){
  # ISD_data = x; sqliteDB = "D:/Weather/ISD.sqlite"; readings_table = "readings"; error_table = "download_errors"; append = TRUE; overwrite = FALSE
  con <- dbConnect(RSQLite::SQLite(), sqliteDB)
  if(tail(class(ISD_data), n = 1) == "error"){
    class(ISD_data) <- "data.frame"
    table_name <- error_table
  }else{
    table_name <- readings_table
  }
  dbWriteTable(con, table_name, ISD_data, append = append, overwrite = overwrite)
  dbDisconnect(con)
}