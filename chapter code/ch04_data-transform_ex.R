# knitr::purl("https://raw.githubusercontent.com/hadley/r4ds/main/data-transform.qmd", documentation=0, output="chapter code/ch04_data-transform_ex.R")

library(nycflights13)
library(tidyverse)

# distinct
# new pipe for later on (John is a massive fan)
data(mtcars)
data(starwars)
data(flights)
data(words)

flights |> 
  distinct(day)

flights |> 
  select(day) |>
  distinct()

flights |> 
  group_by(day, month) |>
  count()


# 4.2.5 Exercises ----
# 1. In a single pipeline for each condition, find all flights that meet the condition:

# Had an arrival delay of two or more hours
names(flights)

flights |>
  filter(arr_delay >= 120)

# Flew to Houston (IAH or HOU)

flights |>
  filter(dest == "IAH" | dest == "HOU")

# Were operated by United, American, or Delta

flights |>
  filter(carrier %in% c("UA", "AA", "DL")) 

# Departed in summer (July, August, and September)

flights |>
  filter(month %in% 7:9)

# Arrived more than two hours late, but didn’t leave late

names(flights)

flights |>
  filter(arr_delay > 120 & dep_delay < 1)

# Were delayed by at least an hour, but made up over 30 minutes in flight

names(flights)

flights |>
  filter(dep_delay >= 60 & arr_delay > 30) |>
  mutate(made_up = dep_delay - arr_delay) 


flights |>
  mutate(made_up = dep_delay - arr_delay) |>
  filter(dep_delay >= 60 & made_up > 30)
  
  
# 2. Sort flights to find the flights with longest departure delays. Find the flights that left earliest in the morning.

# 3. Sort flights to find the fastest flights. (Hint:Try including a math calculation inside of your function.)

# 4. Was there a flight on every day of 2013 ?

# 5. Which flights traveled the farthest distance ? Which traveled the least distance ?

# 6.  Does it matter what order you used filter() and arrange() if you’re using both ? Why /

#   why not ? Think about the results and how much work the functions would have to do.


#.by
flights

gr <- flights |>
  group_by(month) |>
  summarise(mean = mean(dep_delay, na.rm=T))

by

waldo::compare(gr, by)

# 4.3.5 Exercises ----

# 1. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
#   
# 2.  Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.


colz <- c("dep_time", "dep_delay", "arr_time", "arr_delay")

flights |>
  select(dep_time, dep_delay, arr_time, arr_delay)

flights |>
  select(any_of(colz))

flights |>
  select(starts_with("dep") | starts_with("arr"))

flights[colz]
flights[c(4, 6, 7, 9)]

flights[,colz]
flights[,c(4,6,7,9)]

flights %>% select(colz)

library(data.table)

flights[,c(4,6,7,9)]

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

flights |> 
  group_by(carrier, dest) |> 
  summarize(mean_cd = mean(arr_delay, na.rm=T)) |>
  arrange(desc(mean_cd)) |>
  summarize(dest, mean_cd, mean_c = mean(mean_cd, na.rm=T)) |>
  arrange(desc(mean_c))

flights |> 
  group_by(carrier) |>
  summarise(mean = mean(arr_delay, na.rm=T)) |>
  arrange(desc(mean))

flights |> 
  group_by(origin) |>
  summarise(mean = mean(arr_delay, na.rm=T))

flights |> 
  group_by(dest) |>
  summarise(mean = mean(arr_delay, na.rm=T)) |>
  arrange(desc(mean))

flights |> 
  group_by(carrier, dest) |> 
  summarize(mean_cd = mean(arr_delay, na.rm=T)) |>
  arrange(desc(mean_cd))

# 2. Find the flights that are most delayed upon departure from each destination.
# 

names(flights)

flights |>
  group_by(dest) |>
  slice_max(dep_delay) |>
  select(carrier, dest, dep_delay) |>
  arrange(desc(dep_delay))

# 3. How do delays vary over the course of the day. Illustrate your answer with a plot.

names(flights)

flights |>
  mutate(hour = factor(hour)) |>
  ggplot() +
  geom_boxplot(aes(x=hour, y=arr_delay))

flights |>
  group_by(hour) |>
  mutate(hour_av = mean(arr_delay, na.rm=T)) |>
  distinct(hour, hour_av)


  ggplot() +
  geom_point(aes(x=hour, y=hour_av))

#4. What happens if you supply a negative n to slice_min() and friends?
  flights |>
    group_by(dest) |>
    slice_min(dep_delay, n=-8000)
  
  
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