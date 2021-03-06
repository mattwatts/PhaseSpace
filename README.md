# Phase Space

The app does interactive visualisation of high dimensional objects mapped to 3D. It’s designed to visualise the phase space of optimisation problems.

I did this work as an art project to create stunning visualisations of complex mathematical objects. The concept arose out of work on cluster analysis of Marxan solutions. The objects the app visualises are generated in the same way we generate 3D cluster analysis objects for Marxan solutions. The R code for 3D cluster analysis is slow for large objects.

## Processing

Phase Space uses Processing - an efficient language build on Java that does efficient 3D graphics.

Processing is a flexible software sketchbook and a language for the visual arts.

https://processing.org/

To run Phase Space you need to download and install Processing, then run Phase Space from Processing.

## Phase Space Topology

Visually categorising phase spaces as ergodic or non-ergodic is a useful tool for algorithm selection. For example, the simulated thermal annealing used by Marxan is well suited for solving problems with ergodic phase space. Simulated Quantum annealing is well suited for solving problems with non-ergodic phase space.

## Keyboard Controls

It has keyboard controls for cycling through different phase space objects, for rotating precisely in 3 dimensions, and for precisely zooming in and out. Solutions in a phase space can be colour coded for specific attributes, e.g. colour coded by cost or species representation. The controls allow a unique way to explore phase space topology. They also produce beautiful images and animations.

|Key           | What it does         |
|--------------|----------------------|
|-             | Next 3d object (down)|
|=             | Next 3d object (up)  |
|;             | Zoom Out             |
|/             | Zoom In              |
|(up arrow)    | Increase X axis      |
|(down arrow)  | Decrease X axis      |
|(left arrow)  | Decrease Y axis      |
|(right arrow) | Increase Y axis      |
|,             | Decrease Z axis      |
|.             | Increase Z axis      |

## Included Files

The app includes 8d to 14d phase space objects. Each included phase space file has every possible solution for a problem with that dimensionality. The 8d phase space has 2^8=256 solutions. The 14d phase space has 2^14=16384 solutions. Also included is the R code to generate 3d to 14d phase space object. The 14d phase space took a really long time to run. Above 14d, my computer ran out of memory with 64gb or RAM. It would be faster and more efficient to generate these in another language but I haven't had time to write the code yet.
