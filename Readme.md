# Percolation

Further development has been moved to this project:
> https://github.com/discoleo/Percolation


To run the shiny app:
```
setwd(".../Percolation/R")
source("Percolation.App.R")

# Start Shiny App:
shinyApp(ui=ui, server=server)
```

**Note:**
- Requires Rcpp to compile some of the functions;

## Example
```
### Basic Example:
# - Base R, without Shiny app;
d = c(200, 50)
x = runif(d[1])
pChange = 1/3
m.cor = rgrid.correl(d, pChange = pChange)
p = 0.53
m = as.grid.correl(x, m.cor, p=p)
m = flood.all(m)
plot.rs(m)

# More examples in file:
# Percolation.Examples.R;
```

## TODO:

- clean Percolation.md;
- split View in Shiny app (for large materials);


## Bibliography


### Introduction

1. Percolation: a Mathematical Phase Transition.
  > https://www.youtube.com/watch?v=a-767WnbaCQ

2. Hugo Duminil-Copin. Sixty years of percolation.
  > https://www.ihes.fr/~duminil/publi/2018ICM.pdf


### Applications

1. Various applications of porous materials in Chemistry & Physics, including Catalysis, Chromatography, Molecular Sieves.

2. Fluid Mechanics 101: CFD Analysis of a Lead-Cooled Nuclear Reactor.
  > https://www.youtube.com/watch?v=u17fjAjAGvQ
- modeling of the core as a porous material:
  - see 33:30 - 39:25 (Pattern) - 40:40 (Heat losses; actual use of porous media) - 43:40;
  - pump as porous zone: 43:40;
  - heat exchanger as block of porous material: 45:20;

3. NPTEL: Lec 10 Percolation Theory and applications in biological tissues
  > https://www.youtube.com/watch?v=0WeiTnhUoGQ
- CNT = Carbon Nano-Tubes
- CNF = Carbon Nano-Fibers


### Advanced

1. I. Manolescu, L.V. Santoro: Widths of crossings in Poisson Boolean percolation. (2022)
  > https://arxiv.org/abs/2211.11661


**Lectures:**

1. IHES: Eveliina Peltola - On crossing probabilities in critical random-cluster models. (2022)
  > https://www.youtube.com/watch?v=Zg8g_0KF8SA

2. IAS: On Crossing Probabilities in Critical Random-Cluster Models - Eveliina Peltola. (2023)
  > https://www.youtube.com/watch?v=1Z9acHxYFoA

3. IMS Medallion Lecture: "Deformed Polynuclear Growth in (1+1) Dimensions" - Alexei Borodin. (2022)
  > https://www.youtube.com/watch?v=KZntINdhTM4

4. CRM: Jeremy Quastel: Polynuclear growth and the Toda lattice. (2022)
  > https://www.youtube.com/watch?v=yWcAEp_CvCM&list=PLHaWeIntAtAJ-isWJZxdMGAAicT3lBEtT&index=3


### Random Patterns & Landscapes

1. TK Remmel. Distributions of Hyper-Local Configuration Elements to Characterize, Compare, and Assess Landscape-Level Spatial Patterns. (2020)
  > https://doi.org/10.3390/e22040420

2. TK Remmel. An Incremental and Philosophically Different Approach to Measuring Raster Patch Porosity. (2018)
  > https://doi.org/10.3390/su10103413


3. Package ShapePattern: see Ref 1 & 2;
  > https://cran.r-project.org/web/packages/ShapePattern/index.html

