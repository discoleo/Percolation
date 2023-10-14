# Porous Media: Percolation & Random Cluster Models


## Project

> Student: Adrian Ivan\
> Candidate BSc CS 2023\
> West University, Timisoara
>
> Supervisors:\
> Prof. Dr. Daniela Zaharie\
> Dr. med. Leonard Mada (Syonic SRL)\
>
> URL: https://github.com/adrian0010/Percolation
> 
> Based on Previous Projects (2020-2022)


## Processes

### Coupled Pore Process
- TODO: Pore & Block Process;

### Coupled Process: 2 Matrices
- function as.grid.m2(m1, m2, t, p=0.5, val = c(-1, 0));
- where: t = Mixing parameter;


## Statistics

### Number of Channels (Clusters)
- percolating clusters;
- non-percolating, but connected to the boundary;
- non-connected to the boundary;

### Length
- Average of Minimal length of percolating clusters;
- Note: a percolating cluster can have multiple outflows;

### Area
- percolating clusters;
- non-percolating, but connected to the boundary;
- non-connected to the boundary (i.e. fully bounded);
- area of background material;

### Minimal Diameter
- Minimal Diameter: V, H, absolute minimum;

### Dead-End Components
- area of dead-end branches (sub-channels) inside a percolating cluster;
- dead-end area with specified maximum inflow (e.g. inflow of 1 unit: should be easier to define and compute);


### Contact Surface
- Length of the Contact Surface: inner boundaries inside the cluster are counted as well;
- Length of Contact Hull Surface;


### Special Materials: Linear Channels with Blocks & Pores
> rgrid.channel()
- density of percolating channels;
- minimal & maximal length of percolating channels;
- minimal & maximal height of percolating channels: the cluster may span multiple linear channels;

