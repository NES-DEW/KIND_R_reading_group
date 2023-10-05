# knitr::purl("https://raw.githubusercontent.com/hadley/r4ds/main/data-import.qmd", documentation=0, output="chapter code/ch08_data_import.R")

library(tidyverse)

# getting started ----
read_lines("data/students.csv") |> 
  cat(sep = "\n")

read_csv("data/students.csv") |> # reading from local copy
  knitr::kable()

students <- read_csv("data/students.csv") 

## students <- read_csv("https://pos.it/r4ds-students-csv") - to read from web

students

# missing data ----
students2 <- read_csv("data/students.csv", na = c("N/A", "")) # deciding what we want to code as proper NAs (NTM)

# comparison 
waldo::compare(students, students2)
students <- students2
rm(students2)

# non-syntactic names ----

students |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

students |> janitor::clean_names() # ntm

# data types ----

students |>
  janitor::clean_names() |>
  mutate(meal_plan = factor(meal_plan))

students2 <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age)) # ntm
  )

# I'd usually just coerce these, possibly with a mutate(case_when)
students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = case_when(age == "five" ~ "5", 
                    TRUE ~ age),
    age = as.numeric(age)# ntm
  )

# HW's solution is much cleaner

students <- students2
rm(students2)

# csv tricks ----

read_csv( # effectively tribble replacement
  "a,b,c
  1,2,3
  4,5,6"
)

read_csv( # skip
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2
)

read_csv( # comment
  "# A comment I want to skip
  x,y,z
  1,2,3",
  comment = "#"
)

read_csv( # make up col names
  "1,2,3
  4,5,6",
  col_names = FALSE
)

read_csv( # supply col names
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)

## 8.2.4 Exercises ----

# What function would you use to read a file where fields were separated with “|”?
  
# Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?
  
# What are the most important arguments to read_fwf()?
  
# Sometimes strings in a CSV file contain commas. To prevent them from causing problems, they need to be surrounded by a quoting character, like " or '. By default, read_csv() assumes that the quoting character will be ". To read the following text into a data frame, what argument to read_csv() do you need to specify?
  
# "x,y\n1,'a,b'"

#Identify what is wrong with each of the following inline CSV files. What happens when you run the code?
  
read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3")

#Practice referring to non-syntactic names in the following data frame by:
  
## Extracting the variable called 1.
## Plotting a scatterplot of 1 vs. 2.
## Creating a new column called 3, which is 2 divided by 1.
## Renaming the columns to one, two, and three.

annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

# 8.3 Controlling column types ----

read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")

simple_csv <- "
  x
  10
  .
  20
  30"

read_csv(simple_csv)

df <- read_csv( # force types, then see where fails
  simple_csv, 
  col_types = list(x = col_double())
)

problems(df)

read_csv(simple_csv, na = ".")

## 8.3.3 Column types


another_csv <- "
x,y,z
1,2,3"

read_csv(
  another_csv, 
  col_types = cols(.default = col_character())
)

# new to me

read_csv(
  another_csv,
  col_types = cols_only(x = col_character()) # Another useful helper is cols_only() which will read in only the columns you specify
)

sales_files <- c("data/01-sales.csv", "data/02-sales.csv", "data/03-sales.csv")
read_csv(sales_files, id = "file")

sales_files <- list.files("data", pattern = "sales\\.csv$", full.names = TRUE)

sales_files

## write_csv(students, "students.csv")

students
write_csv(students, "students-2.csv")
read_csv("students-2.csv")

write_rds(students, "students.rds")
read_rds("students.rds")

library(arrow)
write_parquet(students, "students.parquet")
read_parquet("students.parquet")
## #> # A tibble: 6 × 5
## #>   student_id full_name        favourite_food     meal_plan             age
## #>        <dbl> <chr>            <chr>              <fct>               <dbl>
## #> 1          1 Sunil Huffmann   Strawberry yoghurt Lunch only              4
## #> 2          2 Barclay Lynn     French fries       Lunch only              5
## #> 3          3 Jayendra Lyne    NA                 Breakfast and lunch     7
## #> 4          4 Leon Rossini     Anchovies          Lunch only             NA
## #> 5          5 Chidiegwu Dunkel Pizza              Breakfast and lunch     5
## #> 6          6 Güvenç Attila    Ice cream          Lunch only              6

file.remove("students-2.csv")
file.remove("students.rds")

tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)
