library(dplyr)
library(testthat)


testthat::test_that("noaatesting", {
  raw.noaa.df <- readr::read_tsv(system.file("extdata", "signif.txt", package = "NOAA"))
  noaa.df <- NOAA::eq_location_clean(raw.noaa.df)
  noaa.df2 <- NOAA::eq_clean_data(raw.noaa.df)
  timeline1 <- NOAA::get_timeline(noaa.df, "*","2000-01-01","2010-01-01")

  mexico.df <- noaa.df  %>% dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000)
  map1 <-  NOAA::eq_map(mexico.df, "DATE")

  mexico.df<- mexico.df %>% dplyr::mutate(popup_text = NOAA::eq_create_label(.))
  map2 <- NOAA::eq_map(mexico.df, "popup_text")


  testthat::expect_that(noaa.df, testthat::is_a("data.frame"))
  testthat::expect_that(noaa.df2, testthat::is_a("data.frame"))
  testthat::expect_that(noaa.df$DATE, testthat::is_a("Date"))
  testthat::expect_that(noaa.df$LONGITUDE, testthat::is_a("numeric"))
  testthat::expect_that(noaa.df$LATITUDE, testthat::is_a("numeric"))

  testthat::expect_that(timeline1, testthat::is_a("ggplot"))
  testthat::expect_that(map1, testthat::is_a("leaflet"))
  testthat::expect_that(mexico.df$popup_text, testthat::is_a("character"))

})
