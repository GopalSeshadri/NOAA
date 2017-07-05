library(dplyr)
library(testthat)


testthat::test_that("noaatesting", {
  raw.noaa.df <- readr::read_tsv(system.file("extdata", "signif.txt", package = "NOAA"))
  noaa.df <- NOAA::eq_location_clean(raw.noaa.df)
  noaa.df2 <- NOAA::eq_clean_data(raw.noaa.df)
  timeline1 <- NOAA::get_timeline(noaa.df, "*","2000-01-01","2010-01-01")

  mexico.df <- noaa.df  %>% dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000)
  map1 <-  NOAA::eq_map(mexico.df, "DATE")

  testthat::expect_that(noaa.df, testthat::is_a("data.frame"))
  testthat::expect_that(noaa.df2, testthat::is_a("data.frame"))
  testthat::expect_that(timeline1, testthat::is_a("ggplot"))
  testthat::expect_that(map1, testthat::is_a("leaflet"))

})
