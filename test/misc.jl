@testset "NaNMath" begin

    X = ones(3,3)
    @test nanmapslices(mean, X, dims=1) == mapslices(mean, X, dims=1)
    @test nanmapslices(mean, X, dims=(1,2)) == mapslices(mean, X, dims=(1,2))
    X[1,2] = NaN
    @test nanmapslices(mean, X, dims=1) == nanmapslices(mean, X, dims=2)' == [1.0 1.0 1.0] 
    @test nanmapslices(mean, X, dims=(1,2)) == ones(1,1)

end

