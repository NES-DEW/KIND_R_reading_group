# knitr::purl("https://raw.githubusercontent.com/hadley/r4ds/main/data-tidy.qmd", documentation=0, output="chapter code/ch06_data-tidying.R")

# updates to pivot_thing - more verbose, but clearer?

# are we doing more than one thing at a time here?

# billboard is a weirdo

# constant normal form 

# what vars (things measured in the context of those vars) and where vars (where they apply) - or keys, should uniquely ID what var
# e.g. rainfall would be your what var, and long-lat your where





library(tidyverse)
library(datapasta)

table1 <- tibble::tribble(
  ~country, ~year, ~cases, ~population,
  "Afghanistan", "1999", "745", "19987071",
  "Afghanistan", "2000", "2666", "20595360",
  "Brazil", "1999", "37737", "172006362",
  "Brazil", "2000", "80488", "174504898",
  "China", "1999", "212258", "1272915272",
  "China", "2000", "213766", "1280428583"
) |>
  mutate(cases = as.numeric(cases), population = as.numeric(population))


table2 <- tibble::tribble(
   ~country, ~year, ~type, ~count,
  "Afghanistan", "1999", "cases", "745",
  "Afghanistan", "1999", "population", "19987071",
  "Afghanistan", "2000", "cases", "2666",
  "Afghanistan", "2000", "population", "20595360",
  "Brazil", "1999", "cases", "37737",
  "Brazil", "1999", "population", "172006362",
  "Brazil", "2000", "cases", "80488"
  ) |>
  mutate(count = as.numeric(count))

table3 <- tibble::tribble(
  ~country, ~year, ~rate,
  "Afghanistan", "1999", "745/19987071",
  "Afghanistan", "2000", "2666/20595360",
  "Brazil", "1999", "37737/172006362",
  "Brazil", "2000", "80488/174504898",
  "China", "1999", "212258/1272915272",
  "China", "2000", "213766/1280428583"
)

table1 |> 
  ggplot(aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) 

table2 |> 
  filter(type == "cases") |>
  ggplot(aes(x = year, y = count)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country))

table3 |>
  separate(rate, "/", into=c("cases", "popn")) |>
  mutate(cases = as.numeric(cases), popn = as.numeric(popn)) |>
  ggplot(aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) 


#> 
# Compute rate per 10,000
table1 |>
  mutate(rate = cases / population * 10000)

# Compute total cases per year
table1 |> 
  group_by(year) |> 
  summarize(total_cases = sum(cases))

# Visualize changes over time
ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000)) # x-axis breaks at 1999 and 2000

billboard |>
  pivot_longer(everything(), values_transform = as.character)
                                                    
billboard |>
  pivot_longer(!c(artist, track, date.entered))

billboard |>
  pivot_longer(contains("wk")) |>
  drop_na(value) |>
  mutate(name = as.numeric(str_replace_all(name, "^[a-z]+", "")))

billboard |>
  pivot_longer(contains("wk"), names_to = "week", values_to = "position") |>
  drop_na(position) |>
  mutate(week = parse_number(week))

anscombe %>%
  pivot_longer(
    everything(),
    # cols_vary = "slowest",
    names_to = c(".value", "set"),
    names_pattern = "(.)(.)"
  ) 
  # ggplot() +
  # geom_point(aes(x=x,y=y)) +
  # facet_wrap(~set)



billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank"
  )

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  )

billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  )
billboard_longer

billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) + 
  geom_line(alpha = 0.25) + 
  scale_y_reverse()

df <- tribble(
  ~id,  ~bp1, ~bp2,
   "A",  100,  120,
   "B",  140,  115,
   "C",  120,  125
)

df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )

who2 |>
  pivot_longer(
    !(country:year),
    names_to = c("diagnosis", "gender", "age"),
    names_sep = "_",
    values_to = "count"
  ) |>
  drop_na(count)




,
names_pattern = "new_?(.*)_(.)(.*)"


who2 |> 
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"), 
    names_sep = "_",
    values_to = "count"
  )

household

household |> 
  pivot_longer(
    cols = !family, 
    names_to = c(".value", "child"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )

cms_patient_experience

cms_patient_experience |> 
  distinct(measure_cd, measure_title)

cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )

cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)

df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

df |> 
  distinct(measurement) |> 
  pull()

df |> 
  select(-measurement, -value) |> 
  distinct()

df |> 
  select(-measurement, -value) |> 
  distinct() |> 
  mutate(x = NA, y = NA, z = NA)

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)

df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

df |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)
