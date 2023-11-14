using InfoMap
using Test

@testset "InfoMap.jl" begin
    using Graphs

    g = SimpleGraph(6)
    add_edge!(g, 1, 2)
    add_edge!(g, 1, 3)
    add_edge!(g, 2, 3)
    add_edge!(g, 2, 4)
    add_edge!(g, 4, 5)
    add_edge!(g, 4, 6)
    add_edge!(g, 5, 6)

    @test transition_probability(g, 1, 2) ≈ 0.5
end
