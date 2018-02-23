function findExtrema(signal::AbstractArray)
    maxima  = [x.I[1] for x in Images.findlocalmaxima(signal, 1)]
    maxvals = signal[maxima]
    
    minima  = [x.I[1] for x in Images.findlocalminima(signal, 1)]
    minvals = signal[minima]
    
    return maxima,minima,maxvals,minvals
end
