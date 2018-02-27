#Function to calculate intrinsic mode functions
#N is the maximum number of modes to find
"""
IMF(y; toldev=0.01, tolzero = 0.01, maxorder=4, N=5)
Calculate the intrinsic mode functions of the sequence y along timespan t.
"""
function IMF(y::Array{T,1};
             toldev::Float64   = 0.01,
             tolzero::Float64  = 0.01,
             maxorder::Int64   = 4,
             N::Int64          = 5,
             verbose::Bool     = false) where T<:Real


    n = length(y)
    t = collect(1:n)
    f = zeros(n,N)
    
    tempy  = zeros(Float64, size(y)...)
    tempy .= y
    eps = 0.00001
    avg = zeros(n)
    d   = zeros(n-1,1)

    n_modes = 0;
    for i = 1:N # for each IMF
        verbose && println("Computing $i of $N...")
        fill!(avg, 1.0)

        sd = 2*toldev

        while (mean(abs.(avg))>tolzero && sd > toldev)
            # Interpolate a spline through the maxima and minima
            tmax, tmin, max_ar, min_ar  = findExtrema(tempy)
     
			S1 = interpolate((tmax,), max_ar, Gridded(Cubic(Natural())))
            S2 = interpolate((tmin,), min_ar, Gridded(Cubic(Natural())))

            # Find mean of envelope
            avg   .= (S1[t] .+ S2[t]) / 2
            tempy .= tempy .- avg

            sd = mean( (avg.^2)./((y-f[:,i]).^2 + eps) )

            f[:,i] .= f[:,i] .+ avg
        end

        copy!(tempy, f[:,i])

        # Check to see if it's worth continuing or if the remainder is monotone
        c       = mean(abs.(tempy))
        d       .= diff(tempy)
        n_modes = n_modes + 1
        if all( d.+c.*tolzero .> 0) || all( d .- c .* tolzero .< 0)
            verbose && println("Remainder monotone: finishing up.")
            break
        end
    end

    C = zeros(n,N)
    C[:,1] = y - f[:,1]
    for i = 2:n_modes
        C[:,i] = f[:,i-1]-f[:,i]
    end

    return C
end

minorder(x) = length(x) > 1 ? length(x) - 1 : 1
