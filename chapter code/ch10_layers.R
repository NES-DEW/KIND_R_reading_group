# knitr::purl("https://raw.githubusercontent.com/hadley/r4ds/main/layers.qmd")
# ch10_layers.R

library(tidyverse)

mpg %>%
  ggplot() +
  geom_

library(ggthemes)
# 
# p <- ggplot(mtcars) +
#   geom_col(aes(x = wt, y = mpg, fill = factor(gear))) +
#   facet_wrap(~am)
# 
# p + 
#   theme_excel_new() + 
#   scale_fill_excel_new()

# aesthetic mappings

# Left
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# Right
ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point() 

# Left
ggplot(mpg, aes(x = displ, y = hwy, size = class)) +
  geom_point() 

# Right
ggplot(mpg, aes(x = displ, y = hwy, alpha = class)) +
  geom_point()

diamonds |>
  ggplot() +
  geom_point(aes(x = carat, y=price), alpha=1/5)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(color = "blue")

# shapes
shapes <- tibble(
  shape = c(0, 1, 2, 5, 3, 4, 6:19, 22, 21, 24, 23, 20),
  x = (0:24 %/% 5) / 2,
  y = (-(0:24 %% 5)) / 4
)
ggplot(shapes, aes(x, y)) + 
  geom_point(aes(shape = shape), size = 5, fill = "red") +
  geom_text(aes(label = shape), hjust = 0, nudge_x = 0.15) +
  scale_shape_identity() +
  expand_limits(x = 4.1) +
  scale_x_continuous(NULL, breaks = NULL) + 
  scale_y_continuous(NULL, breaks = NULL, limits = c(-1.2, 0.2)) + 
  theme_minimal() +
  theme(aspect.ratio = 1/2.75)


ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy, color = "blue"))


# exercises 10.2.1----

# Create a scatterplot of hwy vs. displ where the points are pink filled in triangles.

mpg %>%
  ggplot(aes(x = hwy, y = displ)) +
  geom_point(fill = "pink", shape = 24, size = 3)

# Why did the following code not result in a plot with blue points?
  # 
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy), color = "blue")

# What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
mpg %>%
  ggplot(aes(x = hwy, y = displ)) +
  geom_point(fill = "pink", shape = 24, size = 3, color = "steelblue4", stroke = 2)

# What happens if you map an aesthetic to something other than a variable name, like aes(color = displ < 5)? Note, you’ll also need to specify x and y.



# geoms ----
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth()

# Left
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()

# Right
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth()

# Left
ggplot(mpg, aes(x = displ, y = hwy, shape = drv)) + 
  geom_smooth()

# Right
ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) + 
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() +
  geom_smooth(aes(linetype = drv))


# Left
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

# Middle
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv))

# Right
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    shape = "circle open", size = 3, color = "red"
  )


# Left
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)

# Middle
ggplot(mpg, aes(x = hwy)) +
  geom_density()

# Right
ggplot(mpg, aes(x = hwy)) +
  geom_boxplot()


# ridges ----

library(ggridges)
mpg
ggplot(mpg, aes(x = hwy, y = class, fill = class, color = class)) +
  geom_density_ridges(scale=0.8, alpha = 0.5, show.legend = FALSE)

# exercises 10.3.1 ---- 

# What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
mpg
mpg %>%
  ggplot(aes(y = displ, x = drv, fill = hwy)) +
  geom_area()

df <- data.frame(
  g = c("a", "a", "a", "b", "b", "b"),
  x = c(1, 3, 5, 2, 4, 6),
  y = c(2, 5, 1, 3, 6, 7)
)

df
a <- ggplot(df, aes(x, y, fill = g)) +
  geom_area()
a

# ----

# Earlier in this chapter we used show.legend without explaining it:
  
  # ggplot(mpg, aes(x = displ, y = hwy)) +
  # geom_smooth(aes(color = drv), show.legend = FALSE)

# What does show.legend = FALSE do here? What happens if you remove it? Why do you think we used it earlier?

# ----

# What does the se argument to geom_smooth() do?
  
# Recreate the R code necessary to generate the following graphs. Note that wherever a categorical variable is used in the plot, it’s drv.
# (https://r4ds.hadley.nz/layers#exercises-1)


# facets ----

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~cyl)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free_y")


# Exercises 10.4.1 ----
# What happens if you facet on a continuous variable?
  
# What do the empty cells in the plot above with facet_grid(drv ~ cyl) mean? Run the following code. How do they relate to the resulting plot?
  
#   ggplot(mpg) +
#   geom_point(aes(x = drv, y = cyl))
# 
# What plots does the following code make? What does . do?
# 
#   ggplot(mpg) +
#   geom_point(aes(x = displ, y = hwy)) +
#   facet_grid(drv ~ .)
# 
# ggplot(mpg) +
#   geom_point(aes(x = displ, y = hwy)) +
#   facet_grid(. ~ cyl)
# 
# Take the first faceted plot in this section:
# 
#   ggplot(mpg) +
#   geom_point(aes(x = displ, y = hwy)) +
#   facet_wrap(~ class, nrow = 2)
# 
# What are the advantages to using faceting instead of the color aesthetic? What are the disadvantages? How might the balance change if you had a larger dataset?
# 
#   Read ?facet_wrap. What does nrow do? What does ncol do? What other options control the layout of the individual panels? Why doesn’t facet_grid() have nrow and ncol arguments?
# 
#   Which of the following plots makes it easier to compare engine size (displ) across cars with different drive trains? What does this say about when to place a faceting variable across rows or columns?
# 
#   ggplot(mpg, aes(x = displ)) +
#   geom_histogram() +
#   facet_grid(drv ~ .)
# 
# ggplot(mpg, aes(x = displ)) +
#   geom_histogram() +
#   facet_grid(. ~ drv)
# 
# Recreate the following plot using facet_wrap() instead of facet_grid(). How do the positions of the facet labels change?
# 
#   ggplot(mpg) +
#   geom_point(aes(x = displ, y = hwy)) +
#   facet_grid(drv ~ .)


# Statistical transformations ----
ggplot(mpg) + 
  geom_point(aes(x = drv, y = cyl))


ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)


## -----------------------------------------------------------------------------------
#| fig-show: hide

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)


## -----------------------------------------------------------------------------------
#| fig-show: hide
#| message: false

ggplot(mpg, aes(x = displ)) + 
  geom_histogram() + 
  facet_grid(drv ~ .)

ggplot(mpg, aes(x = displ)) + 
  geom_histogram() +
  facet_grid(. ~ drv)


## -----------------------------------------------------------------------------------
#| fig-show: hide

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)


## -----------------------------------------------------------------------------------
#| fig-alt: |
#|   Bar chart of number of each cut of diamond. There are roughly 1500
#|   Fair, 5000 Good, 12000 Very Good, 14000 Premium, and 22000 Ideal cut
#|   diamonds.

ggplot(diamonds, aes(x = cut)) + 
  geom_bar()


## -----------------------------------------------------------------------------------
#| label: fig-vis-stat-bar
#| echo: false
#| out-width: "100%"
#| fig-cap: |
#|   When creating a bar chart we first start with the raw data, then
#|   aggregate it to count the number of observations in each bar,
#|   and finally map those computed variables to plot aesthetics.
#| fig-alt: |
#|   A figure demonstrating three steps of creating a bar chart.
#|   Step 1. geom_bar() begins with the diamonds data set. Step 2. geom_bar()
#|   transforms the data with the count stat, which returns a data set of
#|   cut values and counts. Step 3. geom_bar() uses the transformed data to
#|   build the plot. cut is mapped to the x-axis, count is mapped to the y-axis.

knitr::include_graphics("images/visualization-stat-bar.png")


## -----------------------------------------------------------------------------------
#| warning: false
#| fig-alt: |
#|   Bar chart of number of each cut of diamond. There are roughly 1500
#|   Fair, 5000 Good, 12000 Very Good, 14000 Premium, and 22000 Ideal cut
#|   diamonds.

diamonds |>
  count(cut) |>
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity")


## -----------------------------------------------------------------------------------
#| fig-alt: |
#|   Bar chart of proportion of each cut of diamond. Roughly, Fair
#|   diamonds make up 0.03, Good 0.09, Very Good 0.22, Premium 0.26, and
#|   Ideal 0.40.

ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) + 
  geom_bar()


## -----------------------------------------------------------------------------------
#| fig-alt: |
#|   A plot with depth on the y-axis and cut on the x-axis (with levels
#|   fair, good, very good, premium, and ideal) of diamonds. For each level
#|   of cut, vertical lines extend from minimum to maximum depth for diamonds
#|   in that cut category, and the median depth is indicated on the line
#|   with a point.

ggplot(diamonds) + 
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )


## -----------------------------------------------------------------------------------
#| fig-show: hide

ggplot(diamonds, aes(x = cut, y = after_stat(prop))) + 
  geom_bar()
ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop))) + 
  geom_bar()


## -----------------------------------------------------------------------------------
#| layout-ncol: 2
#| fig-width: 4
#| fig-alt: |
#|   Two bar charts of drive types of cars. In the first plot, the bars have
#|   colored borders. In the second plot, they're filled with colors. Heights
#|   of the bars correspond to the number of cars in each cut category.

# Left
ggplot(mpg, aes(x = drv, color = drv)) + 
  geom_bar()

# Right
ggplot(mpg, aes(x = drv, fill = drv)) + 
  geom_bar()


## -----------------------------------------------------------------------------------
#| fig-alt: |
#|   Segmented bar chart of drive types of cars, where each bar is filled with
#|   colors for the classes of cars. Heights of the bars correspond to the
#|   number of cars in each drive category, and heights of the colored
#|   segments are proportional to the number of cars with a given class
#|   level within a given drive type level.

ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar()


## -----------------------------------------------------------------------------------
#| layout-ncol: 2
#| fig-width: 4
#| fig-alt: |
#|   Segmented bar chart of drive types of cars, where each bar is filled with
#|   colors for the classes of cars. Heights of the bars correspond to the
#|   number of cars in each drive category, and heights of the colored
#|   segments are proportional to the number of cars with a given class
#|   level within a given drive type level. However the segments overlap. In
#|   the first plot the bars are filled with transparent colors
#|   and in the second plot they are only outlined with color.

# Left
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(alpha = 1/5, position = "identity")

# Right
ggplot(mpg, aes(x = drv, color = class)) + 
  geom_bar(fill = NA, position = "identity")


## -----------------------------------------------------------------------------------
#| layout-ncol: 2
#| fig-width: 4
#| fig-alt: |
#|   On the left, segmented bar chart of drive types of cars, where each bar is
#|   filled with colors for the levels of class. Height of each bar is 1 and
#|   heights of the colored segments represent the proportions of cars
#|   with a given class level within a given drive type.
#|   On the right, dodged bar chart of drive types of cars. Dodged bars are
#|   grouped by levels of drive type. Within each group bars represent each
#|   level of class. Some classes are represented within some drive types and
#|   not represented in others, resulting in unequal number of bars within each
#|   group. Heights of these bars represent the number of cars with a given
#|   level of drive type and class.

# Left
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "fill")

# Right
ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "dodge")


## -----------------------------------------------------------------------------------
#| echo: false
#| fig-alt: |
#|   Scatterplot of highway fuel efficiency versus engine size of cars that
#|   shows a negative association.

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()


## -----------------------------------------------------------------------------------
#| fig-alt: |
#|   Jittered scatterplot of highway fuel efficiency versus engine size of cars.
#|   The plot shows a negative association.

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(position = "jitter")


## -----------------------------------------------------------------------------------
#| fig-show: hide

ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point()


## -----------------------------------------------------------------------------------
#| fig-show: hide

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(position = "identity")


## -----------------------------------------------------------------------------------
#| layout-ncol: 2
#| fig-width: 3
#| message: false
#| fig-alt: |
#|   Two maps of the boundaries of New Zealand. In the first plot the aspect
#|   ratio is incorrect, in the second plot it is correct.

nz <- map_data("nz")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()


## -----------------------------------------------------------------------------------
#| layout-ncol: 2
#| fig-width: 3
#| fig-asp: 1
#| fig-alt: |
#|   There are two plots. On the left is a bar chart of clarity of diamonds,
#|   on the right is a Coxcomb chart of the same data.

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = clarity, fill = clarity), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1)

bar + coord_flip()
bar + coord_polar()


## -----------------------------------------------------------------------------------
#| fig-show: hide

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()


## -----------------------------------------------------------------------------------
#| label: fig-visualization-grammar
#| echo: false
#| fig-alt: |
#|   A figure demonstrating the steps for going from raw data to table of
#|   frequencies where each row represents one level of cut and a count column
#|   shows how many diamonds are in that cut level. Then, these values are
#|   mapped to heights of bars.
#| fig-cap: |
#|   Steps for going from raw data to a table of frequencies to a bar plot where
#|   the heights of the bar represent the frequencies.

knitr::include_graphics("images/visualization-grammar.png")


