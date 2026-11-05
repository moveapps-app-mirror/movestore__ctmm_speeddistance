# Estimate Average Speed and Distance Moved (ctmm)

MoveApps

GitHub repository: https://github.com/movestore/ctmm_speeddistance

## Description
Estimate the average speed and total distance moved for each of a set of
tracked animals based on a fitted continuous-time movement model.

## Documentation
This App estimates two quantities for each animal, both with a 95% confidence
interval:

1. **The average speed** of the animal over its tracking period.
2. **The total distance** the animal moved over its tracking period. This is
   the average speed multiplied by the time between the first and the last
   location.

To estimate the average speed for a given animal, the App uses the
animal's fitted continuous-time movement model (CTMM) to simulate many
possible movement trajectories that the animal could have taken through its
recorded locations. This accounts for both tortuosity of movement (i.e.
non-linear movement between recorded locations) and for telemetry error.
This produces estimates that don't depend on the sampling interval in the way
that straight-line distance estimates do.

This App is part of a ctmm workflow. You must run the *Fit a Continuous-Time
Movement Model (ctmm)* App before this one, as the App needs a fitted model
for each animal.

Note that the average speed only describes the periods in which the animal was
tracked. The distance, however, covers the full time range of tracking. If
the animal was only tracked during part of the day (e.g. only during daylight
hours) and moves less when it isn't tracked, the distance overestimates the
distance it actually moved.

See the ctmm documentation of [`speed()`][1] for more details on the method.

[1]: https://ctmm-initiative.github.io/ctmm/reference/speed.html

### Application scope
#### Generality of App usability
This App was developed for any taxonomic group.

#### Required data properties
Speed can only be estimated from a movement model with a velocity component.
The *Fit a Continuous-Time Movement Model (ctmm)* App may not select such
a model. In these cases, the App returns no estimate (see *Errors and null
handling* below).

### Input type
`ctmm model with data`: a list with two elements, as produced by the *Fit a
Continuous-Time Movement Model (ctmm)* App:

1. A list containing the selected `ctmm` model for each animal.
2. The tracking data (an object of type `telemetry.list`).

### Output type
`ctmm model with data`: the input, unchanged.

### Artefacts
`speed.csv`: the estimated average speed of each animal over its tracking
period. It contains the following columns:
  - `id`: the name of the animal.
  - `unit`: the unit of the speed (meters per second).
  - `low`, `est`, `high`: the estimated speed and the lower and upper bounds
    of its 95% confidence interval.

`distance.csv`: the estimated total distance each animal moved over its
tracking period. It contains the following columns:
  - `id`: the name of the animal.
  - `unit`: the unit of the distance (meters).
  - `low`, `est`, `high`: the estimated distance and the lower and upper
    bounds of its 95% confidence interval.

### Settings
This App has no settings.

### Changes in output data
The input data remain unchanged.

### Errors and null handling
**No estimate for an animal:** In some cases ctmm is unable to estimate an
animal's speed. The App then reports `NA` for that animal in both
`speed.csv` and `distance.csv`, and writes the reason given by ctmm to the
App's log.

In most cases, this happens when the input model has no velocity component
(i.e. IID or OU models). These models describe movement as having no
well-defined speed, so speed and distance can't be estimated. ctmm reports
this as "Movement model is fractal". This often results from long sampling
intervals relative to how long the animal keeps moving in the same direction,
or from tracking data with few locations.

**Performance:** The simulations are repeated until the estimate is precise
enough, which can take a minute or more per animal for long tracks.

### Technical details
The speed is estimated separately for each animal with [`ctmm::speed()`][1],
from the animal's model and its tracking data, with ctmm's default settings.
The confidence interval reflects both the uncertainty in the model parameters
and the variation between the simulated trajectories. The distance is the
estimated speed and its confidence interval multiplied by the time between
the animal's first and last location.

The method is described in Noonan, M. J., Fleming, C. H., Akre, T. S.,
Drescher-Lehman, J., Gurarie, E., Harrison, A.-L., Kays, R., & Calabrese,
J. M. (2019). Scale-insensitive estimation of speed and distance traveled from
animal tracking data. *Movement Ecology*, 7(1).
https://doi.org/10.1186/s40462-019-0177-1

The ctmm package is described in Calabrese, J. M., Fleming, C. H., &
Gurarie, E. (2016). ctmm: An R package for analyzing animal relocation data as
a continuous-time stochastic process. *Methods in Ecology and Evolution*,
7(9), 1124–1132. https://doi.org/10.1111/2041-210X.12559
