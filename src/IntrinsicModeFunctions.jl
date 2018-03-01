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
    
    residue  = zeros(Float64, size(y)...)
    copy!(residue, y)
    eps = 0.00001
    avg = zeros(n)     # pre-allocation for mean envelope
    d   = zeros(n-1,1) # pre-allocation for diff(residue)

    n_modes = 0;
    for i = 1:N # for each IMF
        verbose && println("Computing $i of $N...")
        fill!(avg, 1.0)
        sd = 2*toldev

        while (mean(abs.(avg)) > tolzero && sd > toldev) # do sift?
            sift!(f, avg, residue, eps)
        end

        copy!(residue, f[:,i])

        n_modes += 1
        # Check to see if it's worth continuing or if the remainder is monotone
        is_monotone!(d, residue, tolzero) && break 
    end

    C = zeros(n,N)
    C[:,1] = y - f[:,1]
    for i = 2:n_modes
        C[:,i] = f[:,i-1]-f[:,i]
    end

    return C
end

minorder(x) = length(x) > 1 ? length(x) - 1 : 1

"""
    function sift!(f, avg, residue, eps, use_fortran = false)
Interpolate a spline through the maxima and minima then get the average of the
two. Everything is done in place and nothing is returned.

If use_fortrain is true then we use Dierckx (a fortran library) for interpolation. Otherwise we use (a fork of_ interpolations.jl - which is very beta at the moment).
"""
function sift!(f, avg, residue, eps, use_fortran=true)
    # Interpolate a spline through the maxima and minima
    tmax, tmin, max_ar, min_ar  = findExtrema(residue)
   
    debug = get_mean_envelope!(avg,t,tmax,max_ar,tmin,min_ar,use_fortran)

    residue .= residue .- avg

    sd = mean((avg.^2) ./ ((y-f[:,i]).^2 + eps) )

    f[:,i] .= f[:,i] .+ avg
    return nothing
end

function get_mean_envelope!(avg,t,tmax,max_ar,tmin,min_ar,use_fortran)
    maxorder = 4
	if use_fortran
		p_max = (length(max_ar) > maxorder) ? maxorder : minorder(max_ar)
		p_min = (length(min_ar) > maxorder) ? maxorder : minorder(min_ar)

		S1 = Spline1D(tmax, max_ar, k = p_max)
		S2 = Spline1D(tmin, min_ar, k = p_min)
		avg   .= (S1(t) .+ S2(t)) / 2
        return avg,S1(t),S2(t)
	else
        S1 = interpolate((tmax,), max_ar, Gridded(Cubic(Natural())))
        S2 = interpolate((tmin,), min_ar, Gridded(Cubic(Natural())))
        avg   .= (S1[t] .+ S2[t]) / 2
        return avg,S1[t],S2[t]
    end
end

function is_monotone!(d, residue, tolzero)
    c  = mean(abs.(residue))
    d .= diff(residue) 
    is_m = all(d .+ c .* tolzero .> 0) || all(d .- c .* tolzero .< 0)
    return is_m
end
