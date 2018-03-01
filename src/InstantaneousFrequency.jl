"""
    function IF(C ;order=4, fs=1)
Calculate instantaneous frequencies
"""
function IF(C; order=4, fs=1)

	n,N = size(C)
    t   = 1:n
	Phi = zeros(n-1,N)

	@inbounds for i =1:N
        H1 = Spline1D(t, C[:,i], k = order)
        Phi[:,i] = (fs/2π) .* diff(unwrap(angle.(hilbert(H1(t)))))
    end

	return Phi
end

function unwrap!(v::AbstractVector, lim=π)
  for i in 2:length(v)
    while unwrapped[i] - unwrapped[i-1] >= lim
      unwrapped[i] -= 2*lim
    end
    while unwrapped[i] - unwrapped[i-1] <= -lim
      unwrapped[i] += 2*lim
    end
  end
  return unwrapped
end

unwrap(v) = unwrap!(copy(v))
