#' For a given vector x, for each position, return whether the value at that position is different
#' from the position k places away, with "different" determined by epsilon. If there is no position
#' k places away, then there is no change.
#'
#' @param x numerical vector of interest
#' @param k number of positions
#' @param epsilon minimally detectable change
#' @return cv a vector of booleans for whether or not there was a change.

HasChange <- function(x, k, epsilon){
    if (k > 0) {
        shift.type <- "lag"
    } else {
        shift.type <- "lead"
    }
    cv <- as.numeric(I(abs(x - data.table::shift(x, abs(k), type = shift.type)) > epsilon))
    cv[is.na(cv)] <- 0
    cv
}
