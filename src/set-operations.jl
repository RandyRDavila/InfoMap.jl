
"""
    find_nodes_with_neighbors_in_different_communities(
        g::AbstractGraph,
        M::Vector{Vector{Int64}}
    )::Vector{Int64}

Identify nodes in a graph `g` that have neighbors in different communities than their own.

This function iterates through each community (module) in the set `M` and checks each node within
these communities. It identifies nodes that have at least one neighbor in a different community.
The function uses `Graphs.neighbors` to find neighboring nodes and `setdiff` to determine if these
neighbors are outside the current community.

# Arguments
- `g::AbstractGraph`: The graph being analyzed.
- `M::Vector{Vector{Int64}}`: A vector of vectors, where each inner vector represents a community
 or module of nodes in the graph.

# Returns
- `Vector{Int64}`: A vector containing the indices of nodes that have at least one neighbor in a
different community than their own.
"""
function find_nodes_with_neighbors_in_different_communities(
    g::AbstractGraph,
    M::Vector{Vector{Int64}},
)
    nodes = []
    for m in M
        for u in m
            possible_neighbors = setdiff(Graphs.neighbors(g, u), m)
            !isempty(possible_neighbors) && push!(nodes, u)
        end
    end
    return nodes
end
