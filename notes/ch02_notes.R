#KIND Network - R Reading Group - Visualisations
#(turn this into rmarkdown with knitr::spin("notes/ch02_notes.R"))

#The R Reading Group is looking at the 2nd edition of R For Data Science: 
#https://r4ds.hadley.nz/ 

#The first edition is available here:    
#https://r4ds.had.co.nz/data-visualisation.html  

#The R Reading Group Github can be found here:
#https://github.com/NES-DEW/KIND_R_reading_group

#We're focusing on Chapter 2 Data visualization 
#This is a new chapter for the 2nd edition
#There are additional visualization sections in Chapters 10 (Layers), Chapter 11 (Exploratory Data Analysis) and Chapter 12 (Communication)
#The info in the first edition on visualisations predominantly matches the content from what is now Chapter 10 (layers)
#We will allude to these other chapters as we go through Chapter 2

#Install ggplot2 if you haven't already and call it from your library
#NB: ggplot2 might install with tidyverse 
#install.packages("ggplot2")
library(ggplot2)
#install.packages("tidyverse")
library(tidyverse)

library(palmerpenguins)
library(ggthemes)
#This is why I do everything in baseR

#view as tibble
palmerpenguins::penguins
glimpse(penguins)

#My preferences
#make dataframe
data <- penguins
#Run str to give more of an idea what kind of variables we're dealing with here
str(penguins)

#Ultimate goal for the chapter:
#Recreate a scatterplot of the relationship between flipper length in mm on the x axis 
#and body mass in grams on the y axis
#for three species of penguin (Adelie, Chinstrap and Gentoo), using ggplot2

#First tell r you are making a plot and you're making it with the penguins data
ggplot(data = penguins)
#Creates a grey plot background
#Note - info on how to make a different theme for the background doesn't happen till the tail end of chapter 12 - we can embelllish this later

#next add is the aesthetics (aes)
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g))
#What this adds is labels that are the colnames of the variables we are interested in, and relevant axes scales, and some gridlines

#Next we add the relevant geometrical object that a plot uses to represent data i.e. a geom
#In this case because both x and y variables are numeric (well - body_mass_g is an integer) we can use a scatterplot which is geom_point
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

#If we want colors we need to use the American spelling of colour i.e. color and add it within the mapping brackets
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point()

#If you just wanted to change the points from black to e.g. blue you could just do this
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(color = "blue")

#Note if you try and specify a colour inside the aes section it thinks you're just labelling the points with the label "blue" 
#it will still choose your colour scheme
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, color = "blue")) +
  geom_point()

#If on the other hand you have corporatebranding and need to be very specific about colours you can specify these explicitly
levels(data$species)
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() + 
  scale_color_manual(values = c("Adelie" = "purple",
                                "Chinstrap" ="orange",
                                "Gentoo"="steelblue"))

#You actually don't need to specify the names of your levels as long as you know how many colours you need
#You can use hex codes for the perfect organisational pantone etc rather than named colors in the vector I've used here

nlevels(penguins$species) #we need 3 colors in the vector
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() + 
  scale_color_manual(values = c("red", "gold", "green"))

#Adding model fit is next
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  geom_smooth(method = "lm")

#Note we get one lm trendline per species - this is because of where we have species in the code, in the mapping. 
#If we move the info on species color to geom_point it will apply the linear model trendline to the whole dataset
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm")

#We add shape to the point aesthetics in case people are colour blind (or if you're submitting this to a journal that prints in b&w)
#Can be a waste of info if there's another variable you were interested in that could be defined by shape
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm")

#See later on in chapter for an example of this:
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

#You can explicitly specify that you want a color palette that is appropriate for colour blind people
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm") +
  scale_color_colorblind()

#We can add labels to the axes as sometimes these can be named rather obscurely and readers 
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species") + 
  scale_color_colorblind()

#How does our masterpiece compare to base R?
plot(penguins$flipper_length_mm, penguins$body_mass_g)
#Can add labels
plot(penguins$flipper_length_mm, penguins$body_mass_g, xlab = c("Flipper length"), ylab = c("Body Mass"))
#Can change shapes
plot(penguins$flipper_length_mm, penguins$body_mass_g, xlab = c("Flipper length"), ylab = c("Body Mass"), pch=2)
#Can add color
plot(penguins$flipper_length_mm, penguins$body_mass_g, xlab = c("Flipper length"), ylab = c("Body Mass"), pch=2, col = "blue")
#Can put colours in by factor level
plot(penguins$flipper_length_mm, penguins$body_mass_g, xlab = c("Flipper length"), ylab = c("Body Mass"), pch=2, 
     col = as.numeric(penguins$species)+1)

#Make shape a function of of species too
plot(penguins$flipper_length_mm, penguins$body_mass_g, xlab = c("Flipper length"), ylab = c("Body Mass"), 
     pch= as.numeric(penguins$species)+1, 
     col = as.numeric(penguins$species)+1)

#Add a legend
plot(penguins$flipper_length_mm, penguins$body_mass_g, xlab = c("Flipper length"), ylab = c("Body Mass"), 
     pch= as.numeric(penguins$species), 
     col = as.numeric(penguins$species))
legend(170, 6400, legend=c(levels(penguins$species)), col = 1:length(penguins$species), fill = c(1:length(penguins$species))) 

#Add a trendline
plot(penguins$flipper_length_mm, penguins$body_mass_g, xlab = c("Flipper length"), ylab = c("Body Mass"), 
     pch= as.numeric(penguins$species), 
     col = as.numeric(penguins$species))
legend(170, 6400, legend=c(levels(penguins$species)), col = 1:length(penguins$species), fill = c(1:length(penguins$species))) 
abline(lm(penguins$body_mass_g ~ penguins$flipper_length_mm), col = "purple")

#Moving on - geom_bar
#Bar plots are also useful - the sort of things often reported on go in bargraphs

ggplot(penguins, aes(x = species)) +
  geom_bar()

levels(penguins$species)

#Useful function is to be able to relevel a factor by frequency
ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()

#barplots can be useful if you have multiple factor variables too
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()

#later on in chapter 10 you see how complicated you can go with geom_bar (e.g. if you use fill by a factor variable with lots of levels)
#Starts to look a mess
#color = factor level (seems to put a colour around the bars but not fill them) 
#see version 1 of R for data science has a visual on this using diamonds dataset
#Can use fill = NA for an outline only bar graph
#Using dodge rather than fill if you want each category to have 1 bar per level of the x-axis variable
#Using fill = same factor), position = "fill" leads to prop stacked bars?
#Seems to be more detail on this (or visuals are just bigger) in the older version

#Histograms in ggplot are more of a faff
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)

#Avoid bothering to set your own binwidth by using base R
hist(penguins$body_mass_g, freq = T)
#Can turn it into a density plot by using freq=F
hist(penguins$body_mass_g, freq = F)

#geom_density in ggplot much more fun
ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

#Looking comparing densities can be useful for anova assumptions etc
ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 0.75)
#Want to explore geom_freqpoly which is covered in chapter 11 but seems to be doing something similar but with count?
ggplot(penguins, aes(x = body_mass_g)) + 
  geom_freqpoly(aes(color = species), binwidth = 500, linewidth = 0.75)

#Can install ggridges and make a Joy Division debut album cover! This is described in chapter 10 and wasn't previously in the book in the old version
#install.packages("ggridges")
library(ggridges)

#The next section of visualisations is about boxplots (also covered in further detail in Chapter 11)
#A lot of natural NHS data looks appaling in boxplots (Length of stay data?!) but they are a good simplistic one
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

#Geom density better for skewed data
ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.5)

#Can look at facet wraps
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)

#Facet wraps probably useful for chapter 11 when you're exploring your own data (e.g. wanting a correlation matrix) 
#but if you put them in a report, someone might quibble - depends on audience and people's preferences

#Combined plot is an earlier example we looked at where shape is used for island instead
#So there are choices for how we convey info - do you have support where you work for this or do you have to choose?
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

# Daft example with penguin unicode
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_text(aes(color = species, label = "🐧")) +
  geom_smooth(method = "lm") +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species") + 
  scale_color_colorblind()