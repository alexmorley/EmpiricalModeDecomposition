using EmpiricalModeDecomposition
using Base.Test

# Testing Script for EMD module
using Base.Test

samples = 50000
t = linspace(1,100,samples)
modei = [sin.(5*i.*t) for i in 5:-1:1]

modesi = [sum(modei[1:N]) for N in 2:5]

imfsi = [IMF(modesi[N-1], N=N) for N in 2:5]

for (n,imfs) in enumerate(imfsi)
    errs = [sum(abs.(imfs[:,N] .- modei[N]))/sum(abs.(modei[N])) for N in 1:(n+1)]
    println("Average Mode Recovery Error for $(n+1) Modes is: $errs")
end

println("""
    Assessing performance on simulated data:
        5 sin waves at freqs 25,20,15,10,5 Hz.
        Samples: $samples
        Noise: None
    """
)

for (n,imfs) in enumerate(imfsi)
    errs = [sum(abs.(imfs[:,N] .- modei[N]))/sum(abs.(modei[N])) for N in 1:(n+1)]
    println("Mode Recovery Error for $(n+1) Modes is:\n\tAverage $errs")
    
    edge = floor(Int,samples/5)
    errs = [sum(abs.(imfs[1:edge,N] .- modei[N][1:edge]))/sum(abs.(modei[N][1:edge])) for N in 1:(n+1)]
    println("\tEdge Effects: $errs")
    
    edge = floor(Int,samples/5)
    errs = [sum(abs.(imfs[edge:(end-edge),N] .- modei[N][edge:(end-edge)])
            )/sum(abs.(modei[N][edge:(end-edge)])) for N in 1:(n+1)]
    println("\tErrors without Edge Effects: $errs\n\n")
end
