@testset "Base Extensions" begin

bins = 0:0.1:1.0
@test nextpow2(bins) == 0:0.1:1.6

@test allequal([false])   # assume equality for length 1 arrays
@test allequal([0.00, 0, 0im])# check for equivilancy across types

end
