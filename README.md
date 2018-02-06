# rAutor
R package for creating the proper lead/lead terms for complex difference-in-differences designs. 
The paper is motivated by [Autor (2003)](https://economics.mit.edu/files/589)---and particular Figure 3 from that paper.  

# How you use it
Suppose you have a city-week panel, like so, with 6 time periods and two cities, A and B. Also suppose we have some variable 
the can change week to week, in our case, price. 

```
   city week price
1     A    1     1
2     A    2     1
3     A    3     1
4     A    4     0
5     A    5     0
6     A    6     0
7     B    1     2
8     B    2     2
9     B    3     2
10    B    4     2
11    B    5     2
12    B    6     2
```

City A experiences a fare reduction, with the price going from 1 to 0 at the transition from week 3 to 4. 
We could estimate the effect of the price change on some outcome `y` with a regression of the form 
```
y ~ price + factor(city) + factor(week)
```
Althouh a good first start, this regression ignores any of the by-week adjustments and does not allow us to look for parallel trends. 
Suppose we want to see what the effect of a fare reduction is one week after a cut and whether it is diferent from the "long run" effect.
We want to run a regression of the form 
```
y ~ price +  I(price - lag(price,1)):t1
```
where the `lag` operator gets the price one time period back and `t1` is in indicator that the observation is occurring one period after 
the change. The `I(price - lag(price,1))` term is the size of the change. 
To compute the by-week effects, we can add the coefficient on `price` to the coefficient on the "difference" term. 



