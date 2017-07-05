# library(readr)
# library(dplyr)
# library(tidyr)
# library(readr)
# library(stringr)
# library(lubridate)

#' Clean Data
#'
#' Adds a DATE column and changes the type of LATITUDE and LONGITUDE column to \code{numeric}.
#' Also pads zeros to make YEAR columns four digits.
#'
#' @param data a data.frame containing NOAA earthquake data.
#'
#' @return A data.frame with DATE column in POSIXct format and LATITUDE and LONGITUDE column in numeric class.
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr filter mutate select
#' @importFrom tidyr unite
#' @importFrom stringr str_pad
#' @importFrom lubridate ymd years
#' @importFrom readr read_tsv
#'
#' @examples
#' \dontrun{
#' noaa.df <- eq_clean_data(readr::read_tsv("data-raw/signif.txt"))
#' noaa.df <- eq_clean_data(raw.noaa.df)
#' }
#'
#' @export
eq_clean_data <- function(data) {

  temp <- data %>%

    dplyr::mutate(offset = ifelse(YEAR <0, YEAR , 0),

                  YEAR = ifelse(YEAR <0, "0000", stringr::str_pad(as.character (YEAR),4,"left","0"))) %>%

    tidyr::unite(date_utd,YEAR,MONTH,DAY, remove = FALSE) %>%

    dplyr::mutate(date_ymd = lubridate::ymd(date_utd, truncated = 2),
                  LONGITUDE = as.numeric(LONGITUDE),
                  LATITUDE = as.numeric(LATITUDE)) %>%

    dplyr::mutate(DATE = date_ymd + lubridate::years(offset),
                  YEAR = as.integer(YEAR) + as.integer(offset)) %>%

    dplyr::select(-date_ymd,-offset,-date_utd)


  temp
}

#'
#' Location Clean
#'
#' The country name from LOCATION_NAME column is stripped out. And the column data is converted into Title case.
#'
#' @param data a data.frame containing NOAA earthquake data.
#'
#' @return A data.frame with country name removed from LOCATION_NAME column. And the column is converted into Title case.
#'
#' @note This function makes a call to \code{eq_clean_data()} function to make the process simple.
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr filter mutate
#' @importFrom stringr str_to_title str_trim
#' @importFrom readr read_tsv
#'
#' @examples
#' \dontrun{
#' noaa.df <- eq_location_clean(readr::read_tsv("data-raw/signif.txt"))
#' noaa.df <- eq_location_clean(raw.noaa.df)
#' }
#'
#' @export
eq_location_clean <- function(data)
{
  temp <- eq_clean_data(data) %>% dplyr::mutate(LOCATION_NAME = stringr::str_to_title(stringr::str_trim(gsub('.*:(.*)','\\1',LOCATION_NAME))))
  temp
}


