# -----------------------------------------------------------------------------
#
# "Tiger Bush" simulation: User interface side
#
# Author: Daniel Kinpara
# Date: September 22nd, 2015.
#
# -----------------------------------------------------------------------------

library(shiny)

shinyUI(fluidPage(
        titlePanel("Tiger Bush Simulation"),
        sidebarLayout(
                sidebarPanel(
                        sliderInput("arvores", "Adult tree density (%)",
                                    min = 0,
                                    max = 60,
                                    value = 30),
                        sliderInput("iteracao", "Iterations (k)",
                                    min = 1,
                                    max = 40,
                                    value = 4),
                        sliderInput("fator", "Correction factor (c)",
                                    min = .1,
                                    max = 1,
                                    value = .3),
                        sliderInput("a", "Competition weight (a)",
                                    min = 1,
                                    max = 3,
                                    value = 1),
                        sliderInput("b", "Sinergy weight (b)",
                                    min = 1,
                                    max = 3,
                                    value = 1),
                        radioButtons("floresta", label = h3("Forest stage"),
                                     choices = list("Young" = 1,
                                       "Stable" = 2,
                                       "Senescent" = 3),
                                     selected = 1),
                        actionButton("go", "Simulate")
                ),
                mainPanel(
                     tabsetPanel(
                         tabPanel("Plot",
                                   plotOutput("mapa"),
                                   plotOutput("mapaF")),
                         tabPanel("Documentation",
br(),
h2("Tiger Bush Simulation", align = "center"),
br(),
p("The present application simulates the vegetation genesis known as",
span("Tiger Bush.", style = "color:red"),"It is based in Thiery, D'Herbes &
Valentin (1995) paper. The study states that the Tiger Bush can be replicated
through a successional model simulating rainfall regimes and the nutrients
present in the soil."),
p("The model is based on a cellular automata developed through two hypotheses,
  one of synergy and another of competition between plants for natural 
  resources. The model uses a convolution matrix in order to determine the 
  effect of the surrounding plants on a giving spot. The shiny app presents 
  a square matrix of 80 x 80."),
h3("Running the simulation"),
p("There're six different paramenters you can use to setup the initial forest 
  coverage and the simulation behavior:"),
p(span("Adult tree density: ", style = "color:blue"), "It sets the initial 
  forest coverage with watered adult trees, ranging from 0 to 60% of the total 
  area."),
p(span("Iterations: ", style = "color:blue"), "The number of iterations the 
  model will apply the convolution matrix. Higher the number, more time the 
  model takes to calculate the map matrix."),
p(span("Correction factor: ", style = "color:blue"), "It helps to mimic the 
  trees' growth and death through iterations. Higher values make the changes 
  to take place immediately."),
p(span("Competition weight: ", style = "color:blue"), "It controls the 
  pressure of the competition among plants in the model."),
p(span("Sinergy weight: ", style = "color:blue"), "It controls the degree of 
  sinergy among plants."),
p(span("Forest stage: ", style = "color:blue"), "The forest coverage is a 
  composition of four stages of the plant: 0 - death or no tree; 1 - young tree 
  or senescent tree; 2 - small tree or stressed adult tree; and 4 - watered 
  adult tree. This radio button controls the proportion of stage 1 and stage 
  2 trees. Note that the Adult Tree control sets the proportion of stage 0 
  and stage 3 trees."),
p("While you setup the initial parameters of the model, the Initial Stage Map 
  will reflect instantly the changes. The Simulated Map will be modified 
  only after you hit the", span("Simulate", style = "color:red"), " button. 
  Give some time to the app to run the simulation.")
                         ),
                         tabPanel("Authoring",
                                  h3("Author"),
                                  p("Daniel Kinpara, 2015"),
                                  br(),
                                  h3("Cited Literature"),
p("Thiery, J.M, D'Herbes, J.M., Valentin, C. A model simulating the genesis of
  banded vegetation patterns in Niger.", em("Journal of Ecology"), "n.83,
  p.497-507, 1995."),
p("The paper can be downloaded here: http://goo.gl/TTjxCC")
                         )
                         )
                     )
               )
        )
)
