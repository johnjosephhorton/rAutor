#' Extracts coefficients from a model
#'
#' @param m  model
#' @param num.periods.pre how many pre-period indicators are used
#' @param num.periods.post how many post-period indicators are used
#' @param felm.model whether it is a lfe/felm model
#' @return data frame
#' @importFrom plm vcovHC
#' @export

ExtractCoef <- function(m, num.periods.pre, num.periods.post, felm.model = FALSE){
    max.length <- (num.periods.pre + num.periods.post + 1)
    betas <- coef(m)[1:max.length]
    if (felm.model){
        ses <- sqrt(diag(vcov(m)))[1:max.length]
    } else {
        ses <- sqrt(diag(plm::vcovHC(m,type="HC0",cluster="group")))[1:max.length]
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
    df.effects <- data.frame(t, effect = new.beta, se = new.ses)
    rownames(df.effects) <- df.effects$t
    df.effects
}
