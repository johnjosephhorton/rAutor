#' Generates a formula for use in dynamic model
#'
#' @param x regressor of interst
#' @param num.periods.pre number of pre-periods
#' @param num.periods.post number of post periods
#' @return a string that can be used as a formula
#' @export

GenFormula <- function(x, num.periods.pre, num.periods.post){
    LagTerm <- function(var.name, i){
      paste0("I(", var.name, " - ", var.name, ".lag.", i, "):t", i)
    }

    LeadTerm <- function(var.name, i){
      paste0("I(",var.name, ".lead.", i, "-", var.name, "):tn", i)
    }

    if (num.periods.pre < 1){
        lead.terms <- ""
    } else {
        lead.terms <- paste0(sapply(1:num.periods.pre,  function(i) LeadTerm(x,i)), collapse = " + ")
    }
    lag.terms <-  paste0(sapply(1:num.periods.post, function(i) LagTerm(x,i)), collapse = " + ")
    if (lead.terms == "" & lag.terms != ""){
      formula <- paste0("~ ", x, " + ", lag.terms)
    }
    if (lead.terms == "" & lag.terms == ""){
      formula <- paste0("~ + ", x)
    }
    if (lead.terms != "" & lag.terms == ""){
      formula <- paste0("~ ", x, " + ",lead.terms)
    }
    if (lead.terms != "" & lag.terms != ""){
     formula <- paste0("~ ", x, " + ",lead.terms, " + ", lag.terms)
    }
    formula
}
