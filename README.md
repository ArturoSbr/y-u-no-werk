# Conditional means VS linear regression

This question was originally posted on StackOverflow ([link here](https://stackoverflow.com/questions/72065072/regression-coefficients-do-not-coincide-with-conditional-means)).

|    |         Y |   CONST |   T |   X1 |   X1T |   X2 |   X2T |
|---:|----------:|--------:|----:|-----:|------:|-----:|------:|
|  0 |  2.31252  |       1 |   1 |    0 |     0 |    1 |     1 |
|  1 | -0.836074 |       1 |   1 |    1 |     1 |    1 |     1 |
|  2 | -0.797183 |       1 |   0 |    0 |     0 |    1 |     0 |

I have a dependent variable (`Y`) and three binary columns (`T`, `X1` and `X2`). From this data we can create four groups:
1. `X1 == 0` and `X2 == 0`
1. `X1 == 0` and `X2 == 1`
1. `X1 == 1` and `X2 == 0`
1. `X1 == 1` and `X2 == 1`

Within each group, I want to calculate the difference in the mean of `Y` between `T == 1` and `T == 0`. I can do so with the following code:

```python
# Libraries
import pandas as pd

# Group by T, X1, X2 and get the mean of Y
t = df.groupby(['T','X1','X2'])['Y'].mean().reset_index()

# Reshape the result and rename the columns
t = t.pivot(index=['X1','X2'], columns='T', values='Y')
t.columns = ['Teq0','Teq1']

# I want to replicate these differences with a regression
t['Teq1'] - t['Teq0']

> X1  X2
> 0   0     0.116175
>     1     0.168791
> 1   0    -0.027278
>     1    -0.147601
```

# Problem
I want to recreate these results with the following regression model (`m`).
```python
# Libraries
from statsmodels.api import OLS

# Fit regression with interaction terms
m = OLS(endog=df['Y'], exog=df[['CONST','T','X1','X1T','X2','X2T']]).fit()

# Estimated values
m.params[['T','X1T','X2T']]

> T      0.162198
> X1T   -0.230372
> X2T   -0.034303
```

I was expecting the coefficients:
1. `T` = 0.116175
1. `T + X1T` = 0.168791
1. `T + X2T` = -0.027278
1. `T + X1T + X2T` = -0.147601

# Question
Why don't the regression coefficients match the results from `t['Teq1'] - t['Teq0']`?
