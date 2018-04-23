N = 100
verbose = false

v = rand(N)
bubble_sort!(v)
@testset "Sorting Tests" begin
@test issorted(v)
for inds  =  [[1], [1,2], [1,2,10,11], 1:N, 50:N]
    verbose && println("Test Fixing Indicies: $inds")
    v     =   rand(N)
    fixed = falses(N)
    
    fixed[inds] = true
    vsorted_fixed = bubble_sort!(copy(v),fixed)
    @testset "Sorting with fixed indicies: $inds" begin
        @test vsorted_fixed[inds] == v[inds]
        @test Base.issorted(vsorted_fixed[setdiff(inds, linearindices(v))])
        @test vsorted_fixed == v[bubble_sort_perm(v::AbstractVector, fixed::AbstractVector)]
    end
end
end
