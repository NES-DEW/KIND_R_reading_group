# this is a summary of the R snippets from chapter 3 of R4DS 2e

#knitr::purl("https://raw.githubusercontent.com/hadley/r4ds/main/workflow-basics.qmd", documentation=0, output="chapter code/workflow_basics.R")

1 / 200 * 30
(59 + 73 + 2) / 3
sin(pi / 2)

x <- 3 * 4

primes <- c(2, 3, 5, 7, 11, 13)

primes * 2
primes - 1

## object_name <- value

# create vector of primes
primes <- c(2, 3, 5, 7, 11, 13)

# multiply primes by 2
primes * 2

## i_use_snake_case
## otherPeopleUseCamelCase
## some.people.use.periods
## And_aFew.People_RENOUNCEconvention

x

this_is_a_really_long_name <- 2.5

r_rocks <- 2^3

## r_rock
## #> Error: object 'r_rock' not found
## R_rocks
## #> Error: object 'R_rocks' not found

## function_name(argument1 = value1, argument2 = value2, ...)

seq(from = 1, to = 10)

seq(1, 10)

x <- "hello world"

knitr::include_graphics("screenshots/rstudio-env.png")

my_variable <- 10
my_varıable

## libary(todyverse)
## 
## ggplot(dTA = mpg) +
##   geom_point(maping = aes(x = displ y = hwy)) +
##   geom_smooth(method = "lm)

## my_bar_plot <- ggplot(mpg, aes(x = class)) +
##   geom_bar()
## my_scatter_plot <- ggplot(mpg, aes(x = cty, y = hwy)) +
##   geom_point()
## ggsave(filename = "mpg-plot.png", plot = my_bar_plot)
