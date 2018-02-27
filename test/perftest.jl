using BenchmarkTools, Compat, EmpiricalModeDecomposition

x = rand(1000)
t1000   = @benchmark fs = EmpiricalModeDecomposition.IMF($x)
@show t1000

x = rand(10000)
t10000  = @benchmark fs = EmpiricalModeDecomposition.IMF($x)
@show t10000

x = rand(100000)
t100000 = @benchmark fs = EmpiricalModeDecomposition.IMF($x)
@show t100000
