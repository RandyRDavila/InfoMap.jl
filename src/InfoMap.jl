module InfoMap

using Graphs
using Random
using SimpleWeightedGraphs


include("flow-modeling.jl")
include("two-level-map-equation.jl")
include("set-operations.jl")
include("community-functions.jl")

"""
    infomap(g::AbstractGraph; max_iter = 1_000)::Vector{Vector{Int64}}

Perform the Infomap community detection algorithm on a graph `g`.

This function implements the Infomap algorithm, which is used for detecting
communities or modules in a network. It starts with each node in its own
community and iteratively moves nodes between communities to minimize the map
equation value, a measure of the effectiveness of the network partitioning.

# Arguments
- `g::AbstractGraph`: The graph on which to perform community detection.
- `max_iter::Int = 1_000`: (Optional) Maximum number of iterations to perform.
 Default is 1,000.

# Returns
- `Vector{Vector{Int64}}`: A vector of vectors, where each inner vector contains the node
indices of a detected community.

# Behavior
- The algorithm selects nodes with neighbors in different communities and
attempts to move them to optimize the map equation value.
- If a node has no neighbors outside its current community, the algorithm
selects another node.
- The process stops when the change in the map equation value falls below
a threshold (1e-6) or when the maximum number of iterations is reached.

# Example

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
"""
function infomap(
    g::AbstractGraph;
    max_iter = 1_000,
    tol = 1e-6
)
    # Initialize each node to be in its own community.
    partition = [[v] for v in Graphs.vertices(g)]

    # Find the initial map equation value.
    old_map = map_equation(g, partition)

    for i in 1:max_iter
        # Find nodes with at least one neighbor in different communities.
        good_nodes = find_nodes_with_neighbors_in_different_communities(g, partition)

        # If there are no such nodes, we're done.
        isempty(good_nodes) && return partition

        # Otherwise, select a node from the list of good nodes.
        for target_node in good_nodes

            # Find the community of the target node.
            target_community = find_community(partition, target_node)

            # Find the neighbors of the target node that are not in the same community.
            possible_neighbors = [
                v for v in Graphs.neighbors(g, target_node) if !in_community(partition[target_community], v)
            ]

            # If there are no such neighbors, select the next node in the list.
            isempty(possible_neighbors) && continue

            # Otherwise, select a neighbor at random.
            target_neighbor = rand(possible_neighbors)

            # Find the community of the target neighbor.
            new_community = find_community(partition, target_neighbor)

            # Move the node and find the new map equation value.
            move_node!(partition, target_node, target_community, new_community)
            new_map = map_equation(g, partition)

            # If the change in the map equation value is below the threshold, we're done.
            abs(new_map - old_map) < tol && return partition

            # Otherwise, check if the new map equation value is lower than the old one.
            if new_map < old_map
                # If so, keep the new partition and map equation value.
                old_map = new_map
                break
            else
                # Otherwise, move the node back to its original community.
                move_node!(partition, target_node, new_community, target_community)
            end

        end
    end
    return partition
end


export transition_probability
export stationary_node_visit_rate
export p
export qm_in
export qm_out
export p_circle_m
export codelength_in_module
export H
export q_in
export code_length_index_module
export L


export map_equation
export infomap

end
