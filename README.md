# Is the Devil in the Details?

This project aims to discover whether factor analysis can be used to simplify the interpetation of the parameters of a regression model, potentially simplifying many variables into a few latent variables.

## Data

The data can be found [here](https://www.sciencedirect.com/science/article/pii/S235234092600435X). It is licensed under creative commons attribution 4.0. 

The data is cleaned with `cleaning.r`, and then should be put in the `data\` directory if it is not automatically set there.


## Main findings

Factor analysis find latent factors in the data that adequately summarize the variables in such a way that the regression model errors are the same. This allows us to interpret a model with fewer parameters, making interpretation simpler. 