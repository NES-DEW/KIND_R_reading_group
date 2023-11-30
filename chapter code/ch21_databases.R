# knitr::purl("https://raw.githubusercontent.com/hadley/r4ds/main/databases.qmd")

# introduction ----

library(DBI)
library(dbplyr)
library(tidyverse)

# Database basics ----
# Connecting to a database ----

# DBI to connect to a database
## con <- DBI::dbConnect(
##   RMariaDB::MariaDB(),
##   username = "foo"
## )

# then specific DBMS package (or odbc) to translate into SQL or whatever
## con <- DBI::dbConnect(
##   RPostgres::Postgres(),
##   hostname = "databases.mycompany.com",
##   port = 1234
## )

# use duckdb to create a temp in-process DB, and DBI to connect to it
con <- DBI::dbConnect(duckdb::duckdb())

# or the proper "store the db in the /duckdb dir" version
## con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "duckdb")

# write arbitrary data to duckdb - note there are more efficient direct routes like duckdb_read_csv() that miss out the data loading into R step
dbWriteTable(con, "mpg", ggplot2::mpg)
dbWriteTable(con, "diamonds", ggplot2::diamonds)

# list our tables
dbListTables(con)

# get a table
con |> 
  dbReadTable("diamonds") |> 
  as_tibble()

# or use dbGetQuery to run some sql

sql <- "
  SELECT carat, cut, clarity, color, price 
  FROM diamonds 
  WHERE price > 15000
"
as_tibble(dbGetQuery(con, sql))

# dbplyr ----
# reference https://dbplyr.tidyverse.org/reference/

# create a tbl object to represent a db table
diamonds_db <- tbl(con, from = "diamonds")
diamonds_db

# then do (lazy) dplyr
big_diamonds_db <- diamonds_db |> 
  filter(price > 15000) |> 
  select(carat:clarity, price) 

big_diamonds_db # note metadata in preview

big_diamonds_db |>
  show_query() # sql translation

big_diamonds_db |>
  collect() # proper tibble

# other examples for more structured dbs - https://i.stack.imgur.com/FqyMq.png
## diamonds_db <- tbl(con, in_schema("sales", "diamonds"))
## diamonds_db <- tbl(con, in_catalog("north_america", "sales", "diamonds"))

# or with bits of SQL
## diamonds_db <- tbl(con, sql("SELECT * FROM diamonds"))

# SQL ----

dbplyr::copy_nycflights13(con) # adds whole flights data to local db 
# TAKES PLENTY OF TIME...

flights <- tbl(con, "flights")
planes <- tbl(con, "planes")

options(dplyr.strict_sql = TRUE) # force errors if translation is unknown

# most of this is about queries with SELECT
# case insensitive, but conventionally SHOUTY

# write order matters   SELECT / FROM  / WHERE    / GROUP BY / ORDER BY
# order of execution is FROM  / WHERE / GROUP BY / SELECT   / ORDER BY

# love the use of show_query() as an SQL teaching tool
flights |> show_query()
planes |> show_query()

# WHERE == filter()
# ORDER BY == arrange()
flights |> 
  filter(dest == "IAH") |> 
  arrange(dep_delay) |>
  show_query()

# GROUP BY == group_by()
flights |> 
  group_by(dest) |> 
  summarize(dep_delay = mean(dep_delay, na.rm = TRUE)) |> 
  show_query()

# SELECT == select(), mutate(), rename(), relocate(), summarise()
# yikes!
# select() version - supply a column name
planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  show_query()

# SELECT x AS y == rename() - aliasing
# !! old = new !!
planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  rename(year_built = year) |> 
  show_query()

# relocate or ordered select()
# quoted "year" and "type" - reserved in duckdb
planes |> 
  select(tailnum, type, manufacturer, model, year) |> 
  relocate(manufacturer, model, .before = type) |> 
  show_query()

# SELECT with calcs == mutate()
flights |> 
  mutate(
    speed = distance / (air_time / 60)
  ) |> 
  show_query()

# GROUP BY == group_by(), with calcs in SELECT
# COUNT(*) == n()
# AVG(price) == mean(price)
diamonds_db |> 
  group_by(cut) |> 
  summarize(
    n = n(),
    avg_price = mean(price, na.rm = TRUE)
  ) |> 
  show_query()

# WHERE with reminders about
  # ' rather than "
  # OR rather than |
  # =  rather than ==
  
flights |> 
  filter(dest == "IAH" | dest == "HOU") |> 
  show_query()

flights |> 
  filter(arr_delay > 0 & arr_delay < 20) |> 
  show_query()

# IN not %in%
flights |> 
  filter(dest %in% c("IAH", "HOU")) |> 
  show_query()

# NULL not NA - +1 on https://modern-sql.com/concept/three-valued-logic
flights |> 
  group_by(dest) |> 
  summarize(delay = mean(arr_delay)) # Missing values are always removed in SQL aggregation functions.

flights |> 
  filter(!is.na(dep_delay)) |> 
  show_query()

# HAVING like WHERE, but evaluated later (after the summarise)
diamonds_db |> 
  group_by(cut) |> 
  summarize(n = n()) |> 
  filter(n > 100) |> 
  show_query()

# ORDER BY and DESC
flights |> 
  arrange(year, month, day, desc(dep_delay)) |> 
  show_query()

# subqueries - need a proper SQL person to hold my hand through this, but basically doing other query parts within the FROM
flights |> 
  mutate(
    year1 = year + 1,
    year2 = year1 + 1
  ) |> 
  show_query()

flights |> 
  mutate(year1 = year + 1) |> 
  filter(year1 == 2014) |> 
  show_query()

# joins
flights |> 
  left_join(planes |> rename(year_built = year), by = "tailnum") |> 
  show_query()
# SQL names caused dplyr names, so easy to translate


## Exercises ----

# What is distinct() translated to? How about head()?
  
# Explain what each of the following SQL queries do and try recreate them using dbplyr.

# SELECT * 
#   FROM flights
# WHERE dep_delay < arr_delay

# SELECT *, distance / (air_time / 60) AS speed
# FROM flights

# Function translations ----

# functions to show the query
summarize_query <- function(df, ...) {
  df |> 
    summarize(...) |> 
    show_query()
}

mutate_query <- function(df, ...) {
  df |> 
    mutate(..., .keep = "none") |> 
    show_query()
}

# mean is easy, median isn't
flights |> 
  group_by(year, month, day) |>  
  summarize_query(
    mean = mean(arr_delay, na.rm = TRUE),
    median = median(arr_delay, na.rm = TRUE)
  )

# OVER for window function to replicate grouped mutate
flights |> 
  group_by(year, month, day) |>  
  mutate_query(
    mean = mean(arr_delay, na.rm = TRUE),
  )

# similar window function
flights |> 
  group_by(dest) |>  
  arrange(time_hour) |> 
  mutate_query(
    lead = lead(arr_delay),
    lag = lag(arr_delay)
  )

# CASE WHEN == case_when() 
flights |> 
  mutate_query(
    description = if_else(arr_delay > 0, "delayed", "on-time")
  )

flights |> 
  mutate_query(
    description = 
      case_when(
        arr_delay < -5 ~ "early", 
        arr_delay < 5 ~ "on-time",
        arr_delay >= 5 ~ "late"
      )
  )

# also replaces many non-directly translatable R functions
flights |> 
  mutate_query(
    description =  cut(
      arr_delay, 
      breaks = c(-Inf, -5, 5, Inf), 
      labels = c("early", "on-time", "late")
    )
  )