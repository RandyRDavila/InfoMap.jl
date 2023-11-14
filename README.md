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
Old code length: 4.583249826949124
New code length: 4.0656671754823455
Old code length: 4.0656671754823455
New code length: 3.773975178344286
Old code length: 3.773975178344286
New code length: 3.6957501017081045
Old code length: 3.6957501017081045
New code length: 2.8016724011444145
Old code length: 2.8016724011444145
New code length: 2.3207303568337903
2-element Vector{Vector{Int64}}:
 [1, 2, 3]
 [5, 6, 4]

```