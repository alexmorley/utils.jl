using utils
using Test
using Statistics

for testfile in ["base.jl","sorting.jl","statsbase.jl","misc.jl"]
    include(joinpath(@__DIR__,testfile))
end
