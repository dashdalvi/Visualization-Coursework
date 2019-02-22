
## Example Data: `Housing prices'

##   Let's look at housing prices.
housing <- read.csv("./landdata-states.csv")
head(housing[1:5])


## `ggplot2' VS Base Graphics

##   Compared to base graphics, `ggplot2'
##    is more verbose for simple / canned graphics
##    is less verbose for complex / custom graphics
##    does not have methods (data should always be in a `data.frame')
##    uses a different system for adding plot elements

## `ggplot2' VS Base for simple graphs

##   Base graphics histogram example:

hist(housing$Home.Value)

##   `ggplot2' histogram example:

library(ggplot2)
ggplot(housing, aes(x = Home.Value)) +
  geom_histogram()

##   Base wins!

## `ggplot2' Base graphics VS `ggplot' for more complex graphs:

##   Base colored scatter plot example:

plot(Home.Value ~ Date,
     data=subset(housing, State == "MA"))
points(Home.Value ~ Date, col="red",
       data=subset(housing, State == "TX"))
legend(1975, 400000,
       c("MA", "TX"), title="State",
       col=c("black", "red"),
       pch=c(1, 1))

##   `ggplot2' colored scatter plot example:

ggplot(subset(housing, State %in% c("MA", "TX")),
       aes(x=Date,
           y=Home.Value,
           color=State))+
  geom_point()

##   `ggplot2' wins!

## Geometric Objects And Aesthetics

## Aesthetic Mapping

##   In ggplot land /aesthetic/ means "something you can see". Examples
##   include:
##    position (i.e., on the x and y axes)
##    color ("outside" color)
##    fill ("inside" color)
##    shape (of points)
##    linetype
##    size

##   Each type of geom accepts only a subset of all aesthetics refer to the
##   geom help pages to see what mappings each geom accepts. Aesthetic
##   mappings are set with the `aes()' function.

## Geometic Objects (`geom')

##   Geometric objects are the actual marks we put on a plot. Examples
##   include:
##    points (`geom_point', for scatter plots, dot plots, etc)
##    lines (`geom_line', for time series, trend lines, etc)
##    boxplot (`geom_boxplot', for, well, boxplots!)
##   A plot must have at least one geom; there is no upper limit. You can
##   add a geom to a plot using the `+' operator

##   You can get a list of available geometric objects using the code
##   below:
##   help.search("geom_", package = "ggplot2")
##   or simply type `geom_<tab>' in any good R IDE (such as Rstudio or ESS)
##   to see a list of functions starting with `geom_'.

## Points (Scatterplot)

##   Now that we know about geometric objects and aesthetic mapping, we can
##   make a ggplot. `geom_point' requires mappings for x and y, all others
##   are optional.

hp2001Q1 <- subset(housing, Date == 2001.25) 
ggplot(hp2001Q1,
       aes(y = Structure.Cost, x = Land.Value)) +
  geom_point()

ggplot(hp2001Q1,
       aes(y = Structure.Cost, x = log(Land.Value))) +
  geom_point()

## Lines (Prediction Line)

##   A plot constructed with `ggplot' can have more than one geom. In that
##   case the mappings established in the `ggplot()' call are plot defaults
##   that can be added to or overridden. Our plot could use a regression
##   line:

hp2001Q1$pred.SC <- predict(lm(Structure.Cost ~ log(Land.Value), data = hp2001Q1))

p1 <- ggplot(hp2001Q1, aes(x = log(Land.Value), y = Structure.Cost))

p1 + geom_point(aes(color = Home.Value)) +
  geom_line(aes(y = pred.SC))

## Smoothers

##   Not all geometric objects are simple shapes the smooth geom includes a
##   line and a ribbon.

p1 +
  geom_point(aes(color = Home.Value)) +
  geom_smooth()

## Text (Label Points)

##   Each `geom' accepts a particualar set of mappings for example
##   `geom_text()' accepts a `labels' mapping.

p1 + 
  geom_text(aes(label=State), size = 3)



## Aesthetic Mapping VS Assignment

##   Note that variables are mapped to aesthetics with the `aes()'
##   function, while fixed aesthetics are set outside the `aes()' call.
##   This sometimes leads to confusion, as in this example:

p1 +
  geom_point(aes(size = 2),# incorrect! 2 is not a variable
             color="red") # this is fine -- all points red

## Mapping Variables To Other Aesthetics

##   Other aesthetics are mapped in the same way as x and y in the previous
##   example.

p1 +
  geom_point(aes(color=Home.Value, shape = region))

## Exercise I

##   The data for the exercises is available in the
##   `dataSets/EconomistData.csv' file. Read it in with
dat <- read.csv("./EconomistData.csv")
head(dat)

ggplot(dat, aes(x = CPI, y = HDI, size = HDI.Rank)) + geom_point()

##   Original sources for these data are
##     [http://www.transparency.org/content/download/64476/1031428]
##     [http://hdrstats.undp.org/en/indicators/display_cf_xls_indicator.cfm?indicator_id=103106&lang=en]

##   These data consist of /Human Development Index/ and /Corruption
##   Perception Index/ scores for several countries.

##   1. Create a scatter plot with CPI on the x axis and HDI on the y axis.
##   2. Color the points blue.
##   3. Map the color of the the points to Region.
##   4. Make the points bigger by setting size to 2
##   5. Map the size of the points to HDI.Rank

## Statistical Transformations

ggplot(housing , aes(x=State, y=Home.Value)) + 
  geom_bar(stat="identity")



## Scale Modification Examples

##   Start by constructing a dotplot showing the distribution of home
##   values by Date and State.

p3 <- ggplot(housing,
             aes(x = State,
                 y = Home.Price.Index)) + 
        theme(legend.position="top",
              axis.text=element_text(size = 6))
(p4 <- p3 + geom_point(aes(color = Date),
                       alpha = 0.5,
                       size = 1.5,
                       position = position_jitter(width = 0.25, height = 0)))

##   Now modify the breaks for the x axis and color scales

p4 + scale_x_discrete(name="State Abbreviation") +
  scale_color_continuous(name="",
                         breaks = c(1976, 1994, 2013),
                         labels = c("'76", "'94", "'13"))

##   Next change the low and high values to blue and red:
p4 +
  scale_x_discrete(name="State Abbreviation") +
  scale_color_continuous(name="",
                         breaks = c(1976, 1994, 2013),
                         labels = c("'76", "'94", "'13"),
                         low = "blue", high = "red")


## Using different color scales


##   Start by using a technique we already know map State to color:
p5 <- ggplot(housing, aes(x = Date, y = Home.Value))
p5 + geom_line(aes(color = State))

##   There are two problems here there are too many states to distinguish
##   each one by color, and the lines obscure one another.

## Faceting to the rescue

##   We can remedy the deficiencies of the previous plot by faceting by
##   state rather than mapping state to color.

(p5 <- p5 + geom_line() +
   facet_wrap(~State, ncol = 10))

##   There is also a `facet_grid()' function for faceting in two
##   dimensions.

## Themes

## Themes

##   The `ggplot2' theme system handles non-data plot elements such as
##    Axis labels
##    Plot background
##    Facet label backround
##    Legend appearance
##   Built-in themes include:
##    `theme_gray()' (default)
##    `theme_bw()'
##    `theme_classc()'
p5 + theme_linedraw()

p5 + theme_light()

## Overriding theme defaults

##   Specific theme elements can be overridden using `theme()'. For
##   example:
p5 + theme_minimal() +
  theme(text = element_text(color = "turquoise"))

##   All theme options are documented in `?theme'.


