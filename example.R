library(magrittr)
library(dplyr)
library(ggplot2)
library(lfe)
library(stargazer)

library(rAutor)

set.seed(1234)
num.cities <- 100
num.weeks <- 100

fare.changes.per.city <- 3
possible.changes <- c(-0.10, 0.10)

city.level.effects <- runif(num.cities)
week.effects <- runif(num.weeks)

CreateCity <- function(num.weeks, fare.changes.per.city, possible.changes){
    p0 <- 1 
    price.change.dates <- sort(sample(1:num.weeks, fare.changes.per.city))
    effect.sizes <- sample(possible.changes, fare.changes.per.city, replace = TRUE)
    p <- p0 + 0*(1:num.weeks)
    delta.t.overall <- Inf + 1:num.weeks
    changes <- 0*(1:num.weeks) 
    for (i in 1:fare.changes.per.city){
        t <- price.change.dates[i]
        change <- effect.sizes[i]
        changes[t:num.weeks] <- change 
        p[t:num.weeks] <- p[t:num.weeks] * (1 + change)
        delta.t <- (1:num.weeks) - t
        delta.t[delta.t <= 0] <- Inf
        delta.t.overall <- pmin(delta.t.overall, delta.t)
    }  
    list(p, delta.t.overall, change)
}

# need to generate partial effects based on time since change. 

df <- data.frame()
for (i in 1:num.cities){
    results <- CreateCity(num.weeks, fare.changes.per.city, possible.changes) 
    df.new <- data.frame(
        week = 1:num.weeks,
        city.effect = city.level.effects[i], 
        week.effect = week.effects,
        city = i,
        p = as.numeric(results[[1]]),
        delta.t = as.numeric(results[[2]]),
        most.recent.change = results[[3]], 
        error = runif(num.weeks)/5
    )
    df <- rbind(df, df.new)
}


df$scale.effect <- with(df, ifelse(delta.t == Inf, 1, (1 - delta.t / (1 + delta.t))))

beta.coef <- -0.5

df %<>%
    mutate(beta = beta.coef) %>% 
    mutate(num.trips = exp(week.effect +
                           city.effect +
                           error +
                           beta * log(p) + (beta * most.recent.change * scale.effect) 
                           )) %>%  
    mutate(num.trips.instant = exp(week.effect +
                           city.effect +
                           error +
                           beta * log(p) 
                           ))


ggplot(data = df, aes(x = num.trips, y = num.trips.instant)) + geom_point()


m.instant <- felm(log(num.trips.instant) ~ log(p) | week + city | 0 | week + city, data = df)
m <- felm(log(num.trips) ~ log(p) | week + city | 0 | week + city, data = df)

stargazer(m, m.instant, type = "text")


