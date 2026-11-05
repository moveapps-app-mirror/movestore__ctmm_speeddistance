# Estimate Average Speed and Distance Moved (ctmm)

MoveApps

Github repository: https://github.com/ctmm-initiative/ctmmMoveApp_speeddistance

## Description
This app estimates the average speed an animal moved based on a continuous-time movement model that had been fitted to the data using the App "Fit a Continuous-Time Movement Model (ctmm)" before. By multiplication of the estimated speed and the time the animal was tracked a distance that the animal moved is estimated.

## Documentation
Given a ctmm movement model and telemetry data, multiple realizations of each individual's trajectory are simulated to estimate the time-averaged speed. These speeds are then proportional to distance traveled. Both tortuosity (non straight-line motion between the data) and telemetry error are accounted for.

This app can be used in a ctmm-worklfow, once a continuous time model was estimated ("Fit a Continuous-Time Movement Model (ctmm)" App). For more details about the method, please refer to the accompanying [publication](https://movementecologyjournal.biomedcentral.com/articles/10.1186/s40462-019-0177-1) and the [reference of the speed function](https://rdrr.io/cran/ctmm/man/speed.html) in the ctmm package. 

### Input data
The app requires a *ctmm model with data* as input. 

### Output data
The app returns the input *ctmm model with data* as output. 

### Artefacts

`speed.csv`: The estimated average speed of each animal over its tracking time. The table consists of five columns, which are: `est` the estimated speed with a lower (`low`) and upper (`high`) confidence interval, the units (`unit`) and `id` of the animal. 

`distance.csv`: The estimated total distance each animal moved over its tracked period. The table consists of five columns, which are: `est` the estimated distance with a lower (`low`) and upper (`high`) confidence interval, the units (`unit`) and `id` of the animal. 


### Settings 
none

### Most common errors
Please make an issue [here](https://github.com/ctmm-initiative/ctmmMoveApp_speeddistance/issues) if you repeatedly encounter a specific error.

### Null or error handling
If the few data points are available, speed can not be estimated and `NA` is returned. 
