using BenchmarkTools, Compat, EmpiricalModeDecomposition

x = rand(10000)

@benchmark fs = EmpiricalModeDecomposition.IMF($x)
