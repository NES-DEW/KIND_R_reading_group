# ch05-07.R
# install.packages("styler")
# Ctrl + Shift + P

library(tidyverse)
library(nycflights13)

love


hate



# Style problems --------------------------------------

flights|>filter(dest=="IAH")|>group_by(year,month,day)|>summarize(n=n(),
                                                                  delay=mean(arr_delay,na.rm=TRUE))|>filter(n>10)

flights|>filter(carrier=="UA",dest%in%c("IAH","HOU"),sched_dep_time>
                  0900,sched_arr_time<2000)|>group_by(flight)|>summarize(delay=mean(
                    arr_delay,na.rm=TRUE),cancelled=sum(is.na(arr_delay)),n=n())|>filter(n>10)

# Styler --------------------------------------



flights |>  
  group_by(tailnum) |> 
  summarize(delay = mean(arr_delay, na.rm = TRUE), n = n())

library(glue)
var <- "thing"
glue("I want this to change {var}")


fb <- function(n) {
  out <- vector("character", length = 99)
  for (i in 1:n) {
    if (i %% 3 == 0)
      out[i] <- "fizz"
    if (i %% 5 == 0) {
      out[i] <-
        str_replace_all(paste0(out[i], "buzz", collapse = ""), "NA", "")
    }
    if (!grepl("z", out[i]))
      out[i] <- i
  }
  out
}

fb(99999)

## scripts -------------------------------
# Ctrl + Enter 
# Ctrl + Shift + S
# Ctrl + Shift + F10
# hierarchical naming
# projects
# death to setwd()
# relative paths
# shall we talk about here::here()?

library(pacman)
p_load(janitor)
?tabyl
?clean_names


mtcars %>%
  select(hp) %>%
  summarise(`Grand total` = sum(.)) # yarp

mtcars %>%
  lm(mpg ~ disp, data = .)

mtcars |>
  select(hp) |>
  summarise(`Grand total` =sum(.)) # narp

mtcars |>
  select(hp) |>
  sum()

mtcars %>%
  (\(x) lm(mpg ~ disp, data = x))() 




   