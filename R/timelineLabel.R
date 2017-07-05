#' Geom Timeline Label
#'
#' A geom to add label to the earthquakes.
#' It should have an option \code{n_max} to select the n maximum earthquakes ordered by magnitude.
#'
#' @param mapping mapping
#' @param data data
#' @param stat stat
#' @param position position
#' @param na.rm na.rm
#' @param show.legend show.legend
#' @param inherit.aes inherit.aes
#' @param ... ...
#'
#' @return a ggplot2 object which can label earthquakes created by \code{geom_timeline}.
#'
#' @export
geom_timeline_label <- function(mapping = NULL, data = NULL, stat = "identity",
                                position = "identity", na.rm = FALSE,
                                show.legend = NA, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = geomTimelineLabel, stat = StatTimeline, mapping = mapping,
    data = data,  position = position,
    show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}
#'
#' An helper function for \code{draw_panel} of geomTimelineLabel.
#'
#' @param data data
#' @param panel_scales panel_scales
#' @param coord coord
#'
#' @importFrom grid segmentsGrob
#' @importFrom grid textGrob
#' @importFrom grid gTree
#' @importFrom grid gList
#'

draw_timelinelabel <- function(data, panel_scales, coord) {

  temp <-  data$n_max[1]

  if (nrow(data) > temp) {
    data <- data %>%
      dplyr::group_by(y) %>%
      dplyr::top_n(n = data$n_max[1], wt = size)
    data
  }

  coords <- coord$transform(data, panel_scales)

  # segmentsGrob to draw lines where we will plot our earthquake points
  my_segment_grob <- grid::segmentsGrob(
    x0 = grid::unit(coords$x,"native"),
    x1 = grid::unit(coords$x,"native"),
    y0 = grid::unit(coords$y,"native"),
    y1 = grid::unit(coords$y + 0.05,"native"),
    gp = grid::gpar(col = "grey", alpha = 0.75)
  )
  # textGrob for printing the location
  my_text_grob <- grid::textGrob(
    label = coords$location,
    x = grid::unit(coords$x,"native"),
    y = grid::unit(coords$y + 0.06,"native"),
    rot = 60,
    just = "left",
    gp = grid::gpar(fontsize = 10)
  )
  # group our grobs
  grid::gTree(children = grid::gList(my_segment_grob,my_text_grob))
}
#'
#' geomTimelineLabel
#'
#' @examples
#' \dontrun{
#' get_timeline(noaa.df, c("CHINA", "INDIA"),"2000-01-01","2010-01-01") +
#' geom_timeline_label(ggplot2::aes(x=DATE, location=LOCATION_NAME,xmin=xmin,xmax=xmax,size=EQ_PRIMARY,y=COUNTRY), n_max = 5)
#' }
#'
#' @export
geomTimelineLabel <- ggplot2::ggproto("geomTimelineLable", ggplot2::Geom,
                                      required_aes = c("x","location"),
                                      optional_aes = c("y","n_max"),
                                      default_aes = ggplot2::aes(y = 0.5, fontsize = 10, alpha = 0.5, colour = "blue", fill = "blue", size = 0),
                                      draw_key = ggplot2::draw_key_blank,

                                      draw_panel = draw_timelinelabel)



# get_timeline(noaa.df, c("CHINA", "INDIA"),"2000-01-01","2010-01-01") +
# geom_timeline_label(ggplot2::aes(x=DATE, location=LOCATION_NAME,xmin=xmin,xmax=xmax,size=EQ_PRIMARY,y=COUNTRY), n_max = 5)
