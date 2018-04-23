@testset "StatsBase" begin

    X  = [0,0,sqrt(2),sqrt(2)]
    zX = zscore_base(X,1:2)
    @test all(isnan.(zX[1:2]))
    @test zX[3:4] == [Inf,Inf]
    @test zscore_base(X,[1,3]) == zscore_base(X,[2,4]) == (X.-sqrt(2)/2)
end
