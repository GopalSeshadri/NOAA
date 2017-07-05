
<!-- README.md is generated from README.Rmd. Please edit that file -->
NOAA package
============

This package contains following functions.

eq\_clean\_data()
-----------------

It adds the column DATE and changes the type of LONGITUDE and LATITUDE columns. It takes a dataframe with NOAA earthquake data as input and returns a dataframe with DATE column and it also changes the type of LONGITUDE and LATITUDE column to numeric.

``` r
raw.noaa.df <- readr::read_tsv(system.file("extdata", "signif.txt", package = "NOAA"))
#> Parsed with column specification:
#> cols(
#>   .default = col_integer(),
#>   FLAG_TSUNAMI = col_character(),
#>   SECOND = col_character(),
#>   EQ_PRIMARY = col_double(),
#>   EQ_MAG_MW = col_double(),
#>   EQ_MAG_MS = col_double(),
#>   EQ_MAG_MB = col_character(),
#>   EQ_MAG_ML = col_double(),
#>   EQ_MAG_MFA = col_character(),
#>   EQ_MAG_UNK = col_double(),
#>   COUNTRY = col_character(),
#>   STATE = col_character(),
#>   LOCATION_NAME = col_character(),
#>   LATITUDE = col_double(),
#>   LONGITUDE = col_double(),
#>   MISSING = col_character(),
#>   DAMAGE_MILLIONS_DOLLARS = col_character(),
#>   TOTAL_MISSING = col_character(),
#>   TOTAL_MISSING_DESCRIPTION = col_character(),
#>   TOTAL_DAMAGE_MILLIONS_DOLLARS = col_character()
#> )
#> See spec(...) for full column specifications.
noaa.df <- NOAA::eq_clean_data(raw.noaa.df)
```

eq\_location\_clean()
---------------------

It removes the country name from LOCATION\_NAME column and also makes it Title case. This function makes an internal call to **eq\_clean\_data()** to ease the process. We could just call **eq\_location\_clean()** instead of calling both functions.

``` r
raw.noaa.df <- readr::read_tsv(system.file("extdata", "signif.txt", package = "NOAA"))
#> Parsed with column specification:
#> cols(
#>   .default = col_integer(),
#>   FLAG_TSUNAMI = col_character(),
#>   SECOND = col_character(),
#>   EQ_PRIMARY = col_double(),
#>   EQ_MAG_MW = col_double(),
#>   EQ_MAG_MS = col_double(),
#>   EQ_MAG_MB = col_character(),
#>   EQ_MAG_ML = col_double(),
#>   EQ_MAG_MFA = col_character(),
#>   EQ_MAG_UNK = col_double(),
#>   COUNTRY = col_character(),
#>   STATE = col_character(),
#>   LOCATION_NAME = col_character(),
#>   LATITUDE = col_double(),
#>   LONGITUDE = col_double(),
#>   MISSING = col_character(),
#>   DAMAGE_MILLIONS_DOLLARS = col_character(),
#>   TOTAL_MISSING = col_character(),
#>   TOTAL_MISSING_DESCRIPTION = col_character(),
#>   TOTAL_DAMAGE_MILLIONS_DOLLARS = col_character()
#> )
#> See spec(...) for full column specifications.
noaa.df <- NOAA::eq_location_clean(raw.noaa.df)
```

get\_timeline()
---------------

The wrapper function for geom\_timeline. Renders the timeline based on countries parameter. It takes the NOAA dataframe, a vector of countries and minimum and maximum values of timeline as input. It makes internal call to **geom\_timeline()** and renders the output based on the value we give at "countries" attribute. To render a timeline of earthquakes irrespective of countries we need to pass "\*" in the countries parameter.

``` r
NOAA::get_timeline(noaa.df, "*","2000-01-01","2010-01-01")
```

![](README-get_timeline-1.png)

``` r
NOAA::get_timeline(noaa.df, c("CHINA", "INDIA"),"2000-01-01","2010-01-01")
```

![](README-get_timeline-2.png) For the output of get\_timeline we could add the geom "geom\_timeline\_label()" which will add label to "n" number of earthquakes.

``` r
NOAA::get_timeline(noaa.df, c("CHINA", "INDIA"),"2000-01-01","2010-01-01") +
NOAA::geom_timeline_label(ggplot2::aes(x=DATE, location=LOCATION_NAME,xmin=xmin,xmax=xmax,size=EQ_PRIMARY,y=COUNTRY), n_max = 5)
```

![](README-geom_timeline_label-1.png) \#\# eq\_map() It creates an interactive map with popup based on **annot\_col** attribute. It takes the NOAA dataframe and annot\_col value as input. The value of annot\_col can be any column in the dataframe.

``` r
mexico.df <- dplyr::filter(noaa.df, COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000)
NOAA::eq_map(mexico.df, "DATE")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-6496fd9922aef0dde8b2">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["Thunderforest.Landscape",null,null,{"errorTileUrl":"","noWrap":false,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false}]},{"method":"addCircleMarkers","args":[[18.194,32.319,16.87,18.77,17.488,26.319,17.302,32.456,32.437,32.297,16.396,17.844,16.493,16.917,17.552,17.385,14.742,17.842],[-95.908,-115.322,-100.113,-104.104,-101.303,-86.606,-100.198,-115.315,-115.165,-115.278,-97.782,-99.963,-98.231,-99.381,-100.816,-100.656,-92.409,-95.524],[5.9,5.5,5.3,7.5,6.1,5.8,6,5.1,5.9,7.2,6.2,6.4,7.4,6.2,7.2,6.4,6.9,6.3],null,null,{"lineCap":null,"lineJoin":null,"clickable":true,"pointerEvents":null,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2,"dashArray":null},null,null,["2002-01-30","2002-02-22","2002-09-25","2003-01-22","2004-01-01","2006-09-10","2007-04-13","2008-02-09","2009-12-30","2010-04-04","2010-06-30","2011-12-11","2012-03-20","2013-08-21","2014-04-18","2014-05-08","2014-07-07","2014-07-29"],null,null,null,null]}],"limits":{"lat":[14.742,32.456],"lng":[-115.322,-86.606]}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
eq\_create\_label()
-------------------

It creates a label with Location, Magnitude and Total Deaths.

``` r
mexico.df<- dplyr::mutate(mexico.df, popup_text = NOAA::eq_create_label(mexico.df))
NOAA::eq_map(mexico.df, "popup_text")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-22e2e9c218764c97d529">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["Thunderforest.Landscape",null,null,{"errorTileUrl":"","noWrap":false,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false}]},{"method":"addCircleMarkers","args":[[18.194,32.319,16.87,18.77,17.488,26.319,17.302,32.456,32.437,32.297,16.396,17.844,16.493,16.917,17.552,17.385,14.742,17.842],[-95.908,-115.322,-100.113,-104.104,-101.303,-86.606,-100.198,-115.315,-115.165,-115.278,-97.782,-99.963,-98.231,-99.381,-100.816,-100.656,-92.409,-95.524],[5.9,5.5,5.3,7.5,6.1,5.8,6,5.1,5.9,7.2,6.2,6.4,7.4,6.2,7.2,6.4,6.9,6.3],null,null,{"lineCap":null,"lineJoin":null,"clickable":true,"pointerEvents":null,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2,"dashArray":null},null,null,["<b> Location : \u003c/b> San Andres Tuxtla, Tuxtepec <br> <b> Magnitude : \u003c/b> 5.9 <br>  <br>","<b> Location : \u003c/b> Mexicali, Baja California <br> <b> Magnitude : \u003c/b> 5.5 <br>  <br>","<b> Location : \u003c/b> Acapulco <br> <b> Magnitude : \u003c/b> 5.3 <br>  <br>","<b> Location : \u003c/b> Villa De Alvarez, Colima, Tecoman, Jalisco <br> <b> Magnitude : \u003c/b> 7.5 <br> <b> Total Deaths : \u003c/b> 29 <br>","<b> Location : \u003c/b> Guerrero, Mexico City <br> <b> Magnitude : \u003c/b> 6.1 <br>  <br>","<b> Location : \u003c/b> Gulf Of Mexico <br> <b> Magnitude : \u003c/b> 5.8 <br>  <br>","<b> Location : \u003c/b> Guerrero, Atoyac <br> <b> Magnitude : \u003c/b> 6 <br>  <br>","<b> Location : \u003c/b> Baja California <br> <b> Magnitude : \u003c/b> 5.1 <br>  <br>","<b> Location : \u003c/b> Mexicali <br> <b> Magnitude : \u003c/b> 5.9 <br>  <br>","<b> Location : \u003c/b> Baja California <br> <b> Magnitude : \u003c/b> 7.2 <br> <b> Total Deaths : \u003c/b> 2 <br>","<b> Location : \u003c/b> San Andres Huaxpaltepec <br> <b> Magnitude : \u003c/b> 6.2 <br> <b> Total Deaths : \u003c/b> 1 <br>","<b> Location : \u003c/b> Guerrero <br> <b> Magnitude : \u003c/b> 6.4 <br> <b> Total Deaths : \u003c/b> 2 <br>","<b> Location : \u003c/b> Guerrero, Oaxaca <br> <b> Magnitude : \u003c/b> 7.4 <br> <b> Total Deaths : \u003c/b> 2 <br>","<b> Location : \u003c/b> Acapulco <br> <b> Magnitude : \u003c/b> 6.2 <br>  <br>","<b> Location : \u003c/b> Guerrero; Mexico City <br> <b> Magnitude : \u003c/b> 7.2 <br>  <br>","<b> Location : \u003c/b> Tecpan <br> <b> Magnitude : \u003c/b> 6.4 <br>  <br>","<b> Location : \u003c/b> San Marcos <br> <b> Magnitude : \u003c/b> 6.9 <br> <b> Total Deaths : \u003c/b> 3 <br>","<b> Location : \u003c/b> Oaxaca <br> <b> Magnitude : \u003c/b> 6.3 <br> <b> Total Deaths : \u003c/b> 1 <br>"],null,null,null,null]}],"limits":{"lat":[14.742,32.456],"lng":[-115.322,-86.606]}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
This package contains the following geoms.

geom\_timeline()
----------------

A geom to render the timeline of earthquake with magnitude and total deaths.

geom\_timeline\_label()
-----------------------

A geom to add label to timeline of earthquake created by geom\_timeline.
