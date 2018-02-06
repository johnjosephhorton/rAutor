#' Number of changes k places away
#'
#' @param x numerical vector of interest
#' @param k number of positions
#' @param epsilon minimally detectable change
#' @return v a vector of past changes

SumChanges <- function(x, k, epsilon){
    if (k < -1){
        X <- sapply(-1:(k + 1), function(i) HasChange(x, i, epsilon))
        v <- apply(X,1,sum)
    }
    if (k > 1){
        X <- sapply(1:(k-1), function(i) HasChange(x, i, epsilon))
        v <- apply(X,1,sum)
    }
    if (k == 1 || k == -1) {
        v <- rep(FALSE, length(x))
    }
    v
}
