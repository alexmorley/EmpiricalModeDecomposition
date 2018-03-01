module EmpiricalModeDecomposition

# package code goes here
using DSP
using Images
using Interpolations
using Dierckx

include("util.jl")
include("IntrinsicModeFunctions.jl")
include("InstantaneousFrequency.jl")

export findExtrema
export IMF
export IF

end # module
