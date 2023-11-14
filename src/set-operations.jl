
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