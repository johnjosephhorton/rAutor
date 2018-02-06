#' Extracts coefficients from a model 
#'
#' @param model 
#' @param number of periods pre 
#' @param number of periods post
#' @param felm.model 
#' @return data frame 
#' @export

ExtractCoef <- function(m, num.periods.pre, num.periods.post, felm.model = FALSE){
    max.length <- (num.periods.pre + num.periods.post + 1)
    betas <- coef(m)[1:max.length]
    if (felm.model){
        ses <- sqrt(diag(vcov(m)))[1:max.length]        
    } else {
        ses <- sqrt(diag(vcovHC(m,type="HC0",cluster="group")))[1:max.length]
    }
    num.coef <- length(betas)
    lr <- betas[1]
    se.lr <- ses[1]
    if (num.periods.pre > 0){
        leads <- betas[2:(1 + num.periods.pre)]
        se.leads <- ses[2:(1 + num.periods.pre)]
    }
    lags <- betas[(1 + num.periods.pre + 1):num.coef]
    se.lags <- ses[(1 + num.periods.pre + 1):num.coef]
    new.beta <- c(leads, lags + lr, lr)
    new.ses <-  c(se.leads, sqrt(se.lags^2 + se.lr^2), se.lr)
    t <- c(-num.periods.pre:-1, 1:(num.periods.post + 1))
    data.frame(t, effect = new.beta, se = new.ses)
}
