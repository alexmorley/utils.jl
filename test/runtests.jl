using utils
using Base.Test

for testfile in ["base.jl","sorting.jl","statsbase.jl"]
    include(joinpath(@__DIR__,testfile))
end
