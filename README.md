# PhaseSpace

The app does interactive visualisation of high dimensional objects mapped to 3D. It’s designed to visualise the phase space of optimisation problems.

I did this work as an art project to create stunning visualisations of complex mathematical objects. The concept arose out of work that we did on cluster analysis of Marxan solutions. The objects the app visualises are generated in the same way we generate 3D cluster analysis objects for Marxan solutions. The R code for 3D cluster analysis is slow for large objects, so instead I wrote an entirely new way of doing 3D visualisation using Processing. Processing is a highly efficient language build on Java that does very efficient 3D graphics.

Visually categorising phase spaces as ergodic or non-ergodic is a useful tool for algorithm selection. For example, the simulated thermal annealing used by Marxan is well suited for solving problems with ergodic phase space.

It has keyboard controls for cycling through different phase space objects, for rotating precisely in 3 dimensions, and for precisely zooming in and out. Solutions in a phase space can be colour coded for specific attributes, e.g. colour coded by cost or species representation. The controls allow a unique way to explore phase space topology. They also produce beautiful images and animations.
