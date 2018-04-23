using utils
using Base.Test

for testfile in ["sorting.jl"]
    include(joinpath(@__DIR__,testfile))
end
