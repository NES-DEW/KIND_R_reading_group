# knitr::purl("https://raw.githubusercontent.com/hadley/r4ds/main/base-R.qmd")

library(tidyverse)

# 27.2 Selecting multiple elements with [ ----

## 27.2.1 Subsetting vectors ----

x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)] # keep with +ive ints
x[c(1, 1, 5, 5, 5, 2)] # replacement for expansion
x[c(-1, -3, -5)] # drop with -ive ints

x <- c(10, 3, NA, 5, 8, 1, NA) 
x[!is.na(x)] # subset with logicals
x[x %% 2 == 0]

x <- c(abc = 1, def = 2, xyz = 5) # subset named vector with names
x[c("xyz", "def")]


## 27.2.2 Subsetting data frames ----

df <- tibble(
  x = 1:3, 
  y = c("a", "e", "f"), 
  z = runif(3)
)

df[1, 2] # Select first row and second column
df[, c("x" , "y")] # Select all rows and columns x and y
df[df$x > 1, ] # Select rows where `x` is greater than 1 and all columns


df1 <- data.frame(x = 1:3, y = c("a", "e", "f")) # df[, cols] in df
# returns vector if col selects a single column
# and a data frame if multiple cols
df1[, "x"] # vec
df1[, "x" , drop = FALSE] # df
df1[, c("x", "y")] #df

df2 <- tibble(x = 1:3)
# in tibble always returns tibble
df2[, "x"]


## 27.2.3 dplyr equivalents ----

#### filter ----

df <- tibble(
  x = c(2, 3, 1, 1, NA), 
  y = letters[1:5], 
  z = runif(5)
)

df |> filter(x > 1)

# same as
df[!is.na(df$x) & df$x > 1, ]

# which drops missing values
df[which(df$x > 1), ]

#### arrange ----

df |> arrange(x, y)

# same as
df[order(df$x, df$y), ]

#### select / relocate ----

df |> select(x, z)

# same as
df[, c("x", "z")]

#### subset ----

df |> 
  filter(x > 1) |> 
  select(y, z)

# same as
df |> subset(x > 1, c(y, z))

### 27.2.4 Exercises ----

# 1. Create functions that take a vector as input and return:
#   
    # The elements at even-numbered positions.
    # Every element except the last value.
    # Only even values (and no missing values).

# 2. Why is x[-which(x > 0)] not the same as x[x <= 0]? Read the documentation for which() and do some experiments to figure it out.


## 27.3 Selecting a single element with $ and [[ ----

### 27.3.1 Data frames ----
tb <- tibble(
  x = 1:4,
  y = c(10, 4, 1, 21)
)

# by position
tb[[1]]

# by name
tb[["x"]]
tb$x

#### mutate ----
# create
tb$z <- tb$x + tb$y
tb

# see also the gist: https://gist.github.com/hadley/1986a273e384fb2d4d752c18ed71bedf

### $ ----

max(diamonds$carat)

levels(diamonds$cut)


#### pull ----

diamonds |> pull(carat) |> max()

diamonds |> pull(cut) |> levels()


### 27.3.2 Tibbles ----

df <- data.frame(x1 = 1)
df$x # dfs match prefixes
df$z # dfs don't really care if you match non-existing cols


# tibbles are strict ("lazy and surly")
tb <- tibble(x1 = 1)

tb$x
tb$z


### 27.3.3 Lists ----
l <- list(
  a = 1:3, 
  b = "a string", 
  c = pi, 
  d = list(-1, -5)
)


# [ gets you a sub-list
str(l[1:2])

str(l[1])

str(l[4])


# [[ gets you an item
str(l[[1]])

str(l[[4]])

str(l$a)


### 27.3.4 Exercises ----

# 1. What happens when you use [[ with a positive integer that’s bigger than the length of the vector? What happens when you subset with a name that doesn’t exist?

# 2. What would pepper[[1]][1] be? What about pepper[[1]][[1]]?

## 27.4 Apply family ----

## lapply == purrr::map
## dfs are lists of cols, so lapply over df applies f to each col

df <- tibble(a = 1, b = 2, c = "a", d = "b", e = 4)

# First find numeric columns
num_cols <- sapply(df, is.numeric) # sapply = simplified apply so returns named vec
lapply(df, is.numeric) # c&C - returns list
num_cols 

# Then transform each column with lapply() then replace the original values
df[, num_cols] <- lapply(df[, num_cols, drop = FALSE], \(x) x * 2)
# [, num_cols, drop = FALSE] subsets to named cols and returns a df
# \(x) really struggle with the new anon function syntax

df

vapply(df, is.numeric, logical(1)) # similar to sapply but stricter, so need to supply class and length of output as third arg

diamonds |> 
  group_by(cut) |> 
  summarize(price = mean(price))

tapply(diamonds$price, diamonds$cut, mean) # returns single summary as named vec
# summary gist: https://gist.github.com/hadley/c430501804349d382ce90754936ab8ec

## 27.5 for loops ----

paths <- dir("data/gapminder", pattern = "\\.xlsx$", full.names = TRUE)
files <- map(paths, readxl::read_excel)

files <- vector("list", length(paths))

seq_along(paths)

for (i in seq_along(paths)) {
  files[[i]] <- readxl::read_excel(paths[[i]])
}

do.call(rbind, files) ### !!!HELP ME

out <- NULL
for (path in paths) {
  out <- rbind(out, readxl::read_excel(path))
}

## 27.6 Plots ----

hist(diamonds$carat)

plot(diamonds$carat, diamonds$price)