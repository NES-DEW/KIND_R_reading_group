knitr::purl("https://raw.githubusercontent.com/hadley/r4ds/main/data-transform.qmd", documentation=0, output="chapter code/ch04_data-transform_ex.R")

library(nycflights13)
library(tidyverse)

# 4.2.5 Exercises ----
# 1. In a single pipeline for each condition, find all flights that meet the condition:Had an arrival delay of two or more hours
# Flew to Houston (IAH or HOU)
# Were operated by United, American, or Delta
# Departed in summer (July, August, and September)
# Arrived more than two hours late, but didn’t leave late
# Were delayed by at least an hour, but made up over 30 minutes in flight

# 2. Sort flights to find the flights with longest departure delays. Find the flights that left earliest in the morning.

# 3. Sort flights to find the fastest flights. (Hint:Try including a math calculation inside of your function.)

# 4. Was there a flight on every day of 2013 ?

# 5. Which flights traveled the farthest distance ? Which traveled the least distance ?

# 6.  Does it matter what order you used filter() and arrange() if you’re using both ? Why /
#   why not ? Think about the results and how much work the functions would have to do.

# 4.3.5 Exercises ----

# 1. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
#   
# 2.  Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
# 
# 3. What happens if you specify the name of the same variable multiple times in a select() call?
#   
# 4.  What does the any_of() function do? Why might it be helpful in conjunction with this vector?
#   
variables <- c("year", "month", "day", "dep_delay", "arr_delay")
# 
# 5. Does the result of running the following code surprise you? How do the select helpers deal with upper and lower case by default? How can you change that default?
#   
flights |> 
  select(contains("TIME"))
# 
# 6. Rename air_time to air_time_min to indicate units of measurement and move it to the beginning of the data frame.
# 
# 7. Why doesn’t the following work, and what does the error mean?
  
flights |> 
  select(tailnum) |> 
  arrange(arr_delay)


# 4.5.7 Exercises ----

# 1. Which carrier has the worst average delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))
# 
# 2. Find the flights that are most delayed upon departure from each destination.
# 
# 3. How do delays vary over the course of the day. Illustrate your answer with a plot.
# 
# 4. What happens if you supply a negative n to slice_min() and friends?
#   
# 5. Explain what count() does in terms of the dplyr verbs you just learned. What does the sort argument to count() do?
#   
# 6. Suppose we have the following tiny data frame:

df <- tibble(
    x = 1:5,
    y = c("a", "b", "a", "a", "b"),
    z = c("K", "K", "L", "L", "K")
  )
# 
# a) Write down what you think the output will look like, then check if you were correct, and describe what group_by() does.
# 
df |>
  group_by(y)
# 
# b)  Write down what you think the output will look like, then check if you were correct, and describe what arrange() does. Also comment on how it’s different from the group_by() in part (a)?
#   
df |>
  arrange(y)
# 
# c) Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does.
# 
df |>
  group_by(y) |>
  summarize(mean_x = mean(x))
# 
# d) Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does. Then, comment on what the message says.
# 
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
# 
# e) Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does. How is the output different from the one in part (d).
# 
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")
# 
# f) Write down what you think the outputs will look like, then check if you were correct, and describe what each pipeline does. How are the outputs of the two pipelines different?
#   
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
# 
df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))