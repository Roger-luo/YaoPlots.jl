using YaoPlots, Yao
using Test, Compose

@testset "LabelBlock" begin
    x = put(5, (2,3)=>matblock(rand_unitary(4)))
    cb = LabelBlock(x, "x")
    @test mat(copy(cb)) == mat(cb)
    @test isunitary(cb)
    @test ishermitian(cb) == ishermitian(x)
    @test isreflexive(cb) == isreflexive(x)
    @test mat(cb) == mat(x)
    reg = rand_state(5)
    @test apply!(copy(reg), cb) ≈ apply!(copy(reg), x)
    @test cb' isa LabelBlock && mat(cb') ≈ mat(cb)'
    @test (cb').name == "x†" && (cb'').name == "x"

    y = put(5, (3,4)=>matblock(rand_unitary(4)))
    cc = chsubblocks(cb, y)
    @test YaoPlots.is_continuous_chunk([1,2,3]) == true
    @test YaoPlots.is_continuous_chunk([1,2,4]) == false
    @test YaoPlots.is_continuous_chunk([3,2,4]) == true
    
    c1 = chain(5, [put(5, (2,3)=>label(SWAP, "SWAP")), put(5, 2=>label(I2, "id")), put(5, 2=>label(X, "X")), control(5, (5,3), (2,4,1)=>put(3, (1,3)=>label(SWAP, "SWAP")))])
    c2 = chain(5, [put(5, (2,3)=>label(SWAP, "SWAP")), put(5, 2=>label(I2, "id")), put(5, 2=>label(X, "X")), control(5, (5,3), (2,4,1)=>put(3, (1,2)=>label(SWAP, "SWAP")))])

    @test vizcircuit(c1) isa Compose.Context
    @test_throws ErrorException vizcircuit(c2)
end
