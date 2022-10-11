# Growth-rate
This is a function that will calculate growth rates between all possible time intervals in R.

- Start by loading the two packages:

```
library(tidyverse)
library(SciViews)
```

- Now you can activate the function by running the following code:

```
growth_rate_calculation <- function(df,t_col=1,N_col=2) { #0
  
  mylist <- data.frame(t_i=0,t_f=0,t_d=0, N_i=0,N_f=0,r=0) #2
  
  for (i in 1:nrow(df)) { #3
    for (f in 1:nrow(df)) { #4
      t_delta = df[f,t_col]-df[i,t_col] #5
      if (t_delta>0){ #6
        growth_rate = ( ln(df[f,N_col]/df[i,N_col]) ) / t_delta #7
        mylist <- mylist %>% #8
          add_row(t_i=df[i,t_col],t_f=df[f,t_col],t_d=t_delta, N_i=df[i,N_col],N_f=df[f,N_col],r=growth_rate)
      }
    }
  }
  return(mylist)
}
```


# Explanation of function:

0. A function named growth_rate_calculation()
  - Contains three input parameters:
  - df = input data.frame; t_col = column number containing time (default=1); N_col = column number containing population densities (default=2). 
  - Assuming you have time series in first column and population densities in the second, it is only necessary to input data.frame.

1. Library necessary yo use Ln function
2. Generate empty data.frame.
  - t_i=time initial, t_f=time final, t_d=time difference, N_i=population initial, N_f=population final, r=growth rate
3. Counter from 1 to number of rows in input data.frame
4. Second counter within first counter from 1 to number of rows in data.frame
5. Run through all possible time combinations to get delta t (time differences between time final and initial)
6. Include only time differences that are above 0 (makes no sense to include negative values)
7. Calculate growth rate based on the column with cell density values using the same row as time final and time initial
8. Append gathered and calculated values to the the empty "mylist"

# An example for you to run

- Generate a data frame with three columns named x, y and z.
- x = time
- y = population density over time for cell culture 1
- z = population density over time for cell culture 2

```
df <- data.frame(x=c(1:5), y=c(2,5,7,10,60), z=c(1,2,4,16,256))
```

Applying function:
Calculate growth rate using default column selection, column nr. 1 for time (x) and column nr. 2 (y) for density.
growth_rates_1 <- growth_rate_calculation(df) 

Calculate growth rate using time in column 1 and densities from column 3
growth_rates_2 <- growth_rate_calculation(df,1,3) 
Now you can open growth_rate dataset in R window and click on "r" column twice to get growth rates in descending order.

Find maximum growth rate:
growth_rate_max <- growth_rates_2 %>% filter(r==max(r))

Find the mean growth rate of the 5 highest maximum values
growth_rate_max <- growth_rates_2 %>% arrange(desc(r)) %>% filter(row_number() %in% c(1:5)) %>% summarise(mean=mean(r))

