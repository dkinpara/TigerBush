# TigerBush

### Author: Daniel Kinpara
### Date: September 2015

### Introduction
The present application simulates the vegetation genesis known as Tiger Bush. It is based on Thiery, D'Herbes & Valentin (1995) paper. The study states that the Tiger Bush can be replicated through a successional model simulating rainfall regimes and the nutrients present in the soil.

The model is based on a cellular automata developed through two hypotheses, one of synergy and another of competition between plants for natural resources. The model uses a convolution matrix in order to determine the effect of the surrounding plants on a giving spot. The shiny app presents a square matrix of 80 x 80.

### Running the simulation
There're six different paramenters you can use to setup the initial forest coverage and the simulation behavior:

1. **Adult tree density**: It sets the initial forest coverage with watered adult trees, ranging from 0 to 60% of the total area.
2. **Iterations**: The number of iterations the model will apply the convolution matrix. Higher the number, more time the model takes to calculate the map matrix.
3. **Correction factor**: It helps to mimic the trees' growth and death through iterations. Higher values make the changes to take place immediately.
4. **Competition weight**: It controls the pressure of the competition among plants in the model.
5. **Sinergy weight**: It controls the degree of sinergy among plants.
6. **Forest stage**: The forest coverage is a composition of four stages of the plant: 0 - death or no tree; 1 - young tree or senescent tree; 2 - small tree or stressed adult tree; and 4 - watered adult tree. This radio button controls the proportion of stage 1 and stage 2 trees. Note that the Adult Tree control sets the proportion of stage 0 and stage 3 trees.

While you setup the initial parameters of the model, the Initial Stage Map will reflect instantly the changes. The Simulated Map will be modified only after you hit the Simulate button. Give some time to the app to run the simulation.

### Cited Literature
Thiery, J.M, D'Herbes, J.M., Valentin, C. A model simulating the genesis of banded vegetation patterns in Niger. *Journal of Ecology*, n.83, p.497-507, 1995.

The paper can be downloaded [here](http://goo.gl/TTjxCC)

The app is published at Shiny. You can run it [here](https://dkinpara.shinyapps.io/TigerBush)
