function findExtrema(signal::AbstractArray)
    maxima  = [x.I[1] for x in Images.findlocalmaxima(signal, 1)]
    maxvals = signal[maxima]
    
    minima  = [x.I[1] for x in Images.findlocalminima(signal, 1)]
    minvals = signal[minima]
    
    ## make sure at length extrema > 1        
    if isempty(maxvals)
        mm,tt = findmax(tempy)
        push!(maxima,tt)
        push!(maxvals,mm)
    end
    
    if isempty(minvals)
        mm,tt = findmin(tempy)
        push!(minima,tt)
        push!(minvals,mm)
    end

    return maxima,minima,maxvals,minvals
end
