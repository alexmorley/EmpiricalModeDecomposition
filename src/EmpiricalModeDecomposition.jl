module EmpiricalModeDecomposition

# package code goes here
using DSP
using Images
using Interpolations

include("util.jl")
include("IntrinsicModeFunctions.jl")
include("InstantaneousFrequency.jl")

export findExtrema
export IMF

end # module
