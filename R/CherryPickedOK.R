#' Detects whether there is a change in some vector "k" places away
#'
#' @param x numerical vector of interest
#' @param k number of positions
#' @param epsilon minimally detectable change
#' @return cv a vector of booleans for whether or not there was a change.

CherryPickedOK <- function(x, k, epsilon){
    sc <- SumChanges(x, k, epsilon)
    ifelse(sc == 0 | is.na(sc), TRUE, FALSE)
}
