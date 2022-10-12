library(SciViews)
library(tidyverse)

growth_rate_calculation <- function(df,t_col=1,N_col=2) {
  
  mylist <- data.frame(t_i=0,t_f=0,t_d=0, N_i=0,N_f=0,r=0)
  
  for (i in 1:nrow(df)) {
    for (f in 1:nrow(df)) {
      t_delta = df[f,t_col]-df[i,t_col]
      if (t_delta>0){
        growth_rate = ( ln(df[f,N_col]/df[i,N_col]) ) / t_delta 
        mylist <- mylist %>%
          add_row(t_i=df[i,t_col],t_f=df[f,t_col],t_d=t_delta, N_i=df[i,N_col],N_f=df[f,N_col],r=growth_rate)
      }
    }
  }
  return(mylist[-c(1), ])
}

# EXAMPLE
df <- data.frame(x=c(1:5), y=c(2,5,7,10,60), z=c(1,2,4,16,256))

growth_rates_1 <- growth_rate_calculation(df)

growth_rates_2 <- growth_rate_calculation(df,1,3)

growth_rate_max <- growth_rates_2 %>% filter(r==max(r))

growth_rate_max <- growth_rates_2 %>% 
	arrange(desc(r)) %>% 
	filter(row_number() %in% c(1:5)) %>% 
	summarise(mean=mean(r))
  
  se <- function(x) sd(x)/sqrt(length(x))
  
  growth_rate_top5 <- growth_rates_2 %>% 
  arrange(desc(r)) %>% # Arrange growth rate in descending order (highest values first)
  filter(row_number() %in% c(1:5)) # Keep the five first rows (5 highest growth rate values)

growth_rate_top5_mean_se <- growth_rate_top5 %>% 
  summarise(Mean = mean(r), std_error = se(r)) # Calculate mean and standard error of growth rates (r)


