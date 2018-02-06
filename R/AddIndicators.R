#' Returns a data.frame with appropriate pre/post indicators for a change in some indepdent variable.
#'
#' @param df data frame
#' @param num.periods.post how many post-change indicators are needed
#' @param num.periods.pre how many pre-change indicators are needed
#' @param independent.variable the indepenent variable
#' @param grouping.variable the experimental units (e.g., states, cities, people)
#' @param epsilon minimally detectable change in var.name
#' @return A dataframe with indicators added.
#' @import magrittr
#' @import dplyr
#' @export


AddIndicators  <- function(df, num.periods.post, num.periods.pre, independent.variable, grouping.variable, epsilon = 0.01) {
    if("grouping.variable" %in% colnames(df)) stop("You can't have a column named grouping.variable")
    if("independent.variable" %in% colnames(df)) stop("You can't have a column named independent.variable")

    df[["grouping.variable"]] = df[[grouping.variable]]
    df[["independent.variable"]] = df[[independent.variable]]

    for (i in 1:num.periods.post) {
      df %<>% group_by(grouping.variable) %>% mutate(hc = HasChange(independent.variable, i, epsilon))
      df %<>% group_by(grouping.variable) %>% mutate(cp = CherryPickedOK(independent.variable, i, epsilon))
      df[[paste0("t",i)]] = with(df, hc * cp)
      df %<>% group_by(grouping.variable) %>%
        mutate(lag.term = dplyr::lag(independent.variable,i))
      df %<>% mutate(delta.lag = independent.variable - lag.term)
      df[[paste0(independent.variable, ".lag.delta.", i)]] = ifelse(is.na(df$delta.lag), 0,
                                                                    df$delta.lag)
      df[[paste0(independent.variable,".lag.",i)]] = df$lag.term
    }

    for(i in -num.periods.pre:-1){
      df %<>% group_by(grouping.variable) %>% mutate(hc = HasChange(independent.variable, i, epsilon))
      df %<>% group_by(grouping.variable) %>% mutate(cp = CherryPickedOK(independent.variable, i, epsilon))
      df[[paste0("tn",abs(i))]] = with(df, hc * cp)
      df %<>% group_by(grouping.variable) %>%
        mutate(lead.term = dplyr::lead(independent.variable,abs(i)))
      df[[paste0(independent.variable, ".lead.",abs(i))]] = df$lead.term

      df %<>% mutate(delta.lead = lead.term - independent.variable)
      df[[paste0(independent.variable, ".lead.delta.", abs(i))]] = ifelse(is.na(df$delta.lead), 0,
                                                                    df$delta.lead)

    }
    df %>% ungroup %>% select(-hc, -cp, -grouping.variable, -independent.variable, -lag.term, -lead.term)
}










