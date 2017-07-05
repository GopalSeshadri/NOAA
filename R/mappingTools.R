# library(dplyr)
# library(leaflet)

#' Eq Map
#'
#' A interactive map to show earthquakes on it as cirle points whose radius is determined by \code{EQ_PRIMARY} column.
#' It should also annotate a data  based on the \code{annot_col} value.
#'
#' @param data A data.frame containing NOAA earthquake data.
#' @param annot_col A column in \code{data} that has to be annotate.
#'
#' @return A interactive leaflet map with location marked based on the data and popup determined by \code{annot_col}.
#'
#' @importFrom leaflet leaflet addProviderTiles addCircleMarkers
#'
#' @examples
#' \dontrun{
#'  mexico.df <- noaa.df  %>% dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000)
#'  eq_map(mexico.df, "DATE")
#' }
#'
#' @export
eq_map <- function(data, annot_col)
{

  leaflet::leaflet() %>%
    leaflet::addProviderTiles("Thunderforest.Landscape") %>%
    leaflet::addCircleMarkers(data = data, radius = ~EQ_PRIMARY, lng = ~LONGITUDE, lat = ~LATITUDE, popup = ~data[[`annot_col`]])

}

# mexico.df <- noaa.df  %>% dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000)
# eq_map(mexico.df, "DATE")

#'
#' Eq Create Label
#'
#' Creates a label with column LOCATION_NAME, EQ_PRIMARY and TOTAL_DEATHS.
#'
#' @param data A data.frame containing NOAA earthquake data.
#'
#' @return A string with LOCATION_NAME, EQ_PRIMARY and TOTAL_DEATHS.
#'
#' @examples
#' \dontrun{
#' mexico.df<- mexico.df %>% dplyr::mutate(popup_text = eq_create_label(.))
#' eq_map(mexico.df, "popup_text")
#' }
#'
#' @export

eq_create_label <- function(data)
{
  words <- paste(ifelse(!is.na(data$LOCATION_NAME), paste("<b> Location : </b>", data$LOCATION_NAME), ""),
                 "<br>",
                 ifelse(!is.na(data$EQ_PRIMARY), paste("<b> Magnitude : </b>", data$EQ_PRIMARY), ""),
                 "<br>",
                 ifelse(!is.na(data$TOTAL_DEATHS), paste("<b> Total Deaths : </b>", data$TOTAL_DEATHS), ""),
                 "<br>")

  words
}

# mexico.df<- mexico.df %>% dplyr::mutate(popup_text = eq_create_label(.))
# eq_map(mexico.df, "popup_text")


