# Calculating growth rate
This is a function that will calculate growth rates between all possible time intervals in R.


- Start by loading the packages:

```
library(SciViews)
library(tidyverse)
```

- Now you can activate the function by running the following code:

```
growth_rate_calculation <- function(df,t_col=1,N_col=2) { #0
	# library(SciViews) #1
  
  mylist <- data.frame(t_i=0,t_f=0,t_d=0, N_i=0,N_f=0,r=0) #2
  
  for (i in 1:nrow(df)) { #3
    for (f in 1:nrow(df)) { #4
      t_delta = df[f,t_col]-df[i,t_col] #5
      if (t_delta>0){ #6
        growth_rate = ( ln(df[f,N_col]/df[i,N_col]) ) / t_delta #7
        mylist <- mylist %>%
          add_row(t_i=df[i,t_col],t_f=df[f,t_col],t_d=t_delta, N_i=df[i,N_col],N_f=df[f,N_col],r=growth_rate) #8
      }
    }
  }
  return(mylist[-c(1), ]) #9
}
```


# Explanation behind the function
See numbers inside the function marked by `#Nr`:

0. A function named growth_rate_calculation()
	- Contains three input parameters:
		- **df** = input data.frame, 
		- **t_col** = column number containing time (default=1) 
		- **N_col** = column number containing population densities (default=2).
	- Assuming you have time series in first column and population densities in the second column, it is only necessary to input data.frame.
1. Library needed to use `Ln()` inside the function
2. Generate empty data.frame.
	- **t_i** = time initial
	- **t_f** = time final
	- **t_d** = time difference
	- **N_i** = population initial
	- **N_f** = population final
	- **r** = calculated growth rate
4. A counter that starts from 1 and goes up to the number of rows in the inputed data.frame
5. Second counter within first counter from 1 to number of rows in data.frame
6. Run through all possible time combinations to get delta t (time differences between time final and initial)
7. Include only time differences that are above 0 (makes no sense to include negative time values)
8. Calculate growth rate based on the column with cell density values using the same row as time final and time initial
9. Append gathered and calculated values to the the empty "mylist"
10. Return/print the dataframe containing the growth rates between all time intervals, but remove first row as it contains the empty generated data.

# An example for you to run

- Generate a data frame with three columns named x, y and z.
	- x = time
	- y = population density over time for cell culture 1
	- z = population density over time for cell culture 2

```
df <- data.frame(x=c(1:5), y=c(2,5,7,10,60), z=c(1,2,4,16,256))
```

- Applying function
	- Calculate growth rates using **default** column selection, where it selects column nr. 1 for time (x) and column nr. 2 (y) for density.
```
growth_rates_1 <- growth_rate_calculation(df) 
```

- Calculate growth rate by manually selecting the columns. Here we show how we select time from column nr. 1 and densities from column nr. 3:
```
growth_rates_2 <- growth_rate_calculation(df,1,3) 
```
- Now you can open `growth_rate_1` or `growth_rate_2` dataset in the RStudio window and click twice on the column named "r" to get growth rates in descending order.

- Extract maximum growth rate:
```
growth_rate_max <- growth_rates_2 %>% filter(r==max(r))
```

- Extract the mean growth rate of the 5 highest maximum values:
```
growth_rate_max <- growth_rates_2 %>% 
	arrange(desc(r)) %>% 
	filter(row_number() %in% c(1:5)) %>% 
	summarise(mean=mean(r))
```

- Calculate the mean with standard error.
- We must first create another function that can calculate standard error
```
se <- function(x) sd(x)/sqrt(length(x))
```

- Now we can use the top 5 growth rates to calculate mean and se
```
growth_rate_top5 <- growth_rates_2 %>% 
  arrange(desc(r)) %>% # Arrange growth rate in descending order (highest values first)
  filter(row_number() %in% c(1:5)) # Keep the five first rows (5 highest growth rate values)

growth_rate_top5_mean_se <- growth_rate_top5 %>% 
  summarise(Mean = mean(r), std_error = se(r)) # Calculate mean and standard error of growth rates (r)



```
