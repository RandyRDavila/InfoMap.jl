# InfoMap

[![Build Status](https://github.com/RandyRDavila/InfoMap.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/RandyRDavila/InfoMap.jl/actions/workflows/CI.yml?query=branch%3Amain)

A simple implementation of the InfoMap community detection algorithm.

```julia
julia> using Graphs, InfoMap

julia> g = SimpleGraph(6)

julia> add_edge!(g, 1, 2)

julia> add_edge!(g, 1, 3)

julia> add_edge!(g, 2, 3)

julia> add_edge!(g, 2, 4)

julia> add_edge!(g, 4, 5)

julia> add_edge!(g, 4, 6)

julia> add_edge!(g, 5, 6)

julia> infomap(g)
2-element Vector{Vector{Int64}}:
 [1, 3, 2]
 [4, 6, 5]
```