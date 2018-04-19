# EmpiricalModeDecomposition

Julia implementation of EMD as defined in :

> The empirical mode decomposition and the Hilbert spectrum for nonlinear and non-stationary time series analysis. Norden E. Huang, Zheng Shen, Steven R. Long, Manli C. Wu, Hsing H. Shih, Quanan Zheng, Nai-Chyuan Yen, Chi Chao Tung, Henry H. Liu
> [Link to Paper](http://rspa.royalsocietypublishing.org/content/454/1971/903)

## Set Up
To use the fortran library for interpolation then you can install simply using:
`Pkg.clone(https://github.com/alexmorley/EmpiricalModeDecomposition.git)`

**Alpha** To use the Julia package for interpolation you'll need to check out a specifc fork of Interpolations.jl. Available here https://github.com/JuliaMath/Interpolations.jl/pull/193

## Acknowledgements
This was inspired by [bnels/EMD.jl](https://github.com/bnels/EMD.jl) but should be faster and work with the latest versions of Julia.
