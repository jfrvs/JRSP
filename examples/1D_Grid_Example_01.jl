# Initial definitions

using Revise;
using JRSP;

# Variable Definitions

numberOfCells = 100; # number of cells
resLength = 2000.0; # reservoir length in meters
permeabilityArray = [100]; # mD
porosityValue = 0.2; # Rock porosity

# Geometry Definition; 1D Constructor

G = JRSP.Geometry(numberOfCells, resLength);
JRSP.geometryOverview;

# Rock definition; Isotropic permeability and constant porosity

uniformRock = JRSP.Rock(G, permeabilityArray, porosityValue);
#nonuniformRock = JRSP.Rock(G, permeabilityArray, porosityValue, porosityValue*0.1);

# Plot grid for inspection

JRSP.plotGrid(G);



