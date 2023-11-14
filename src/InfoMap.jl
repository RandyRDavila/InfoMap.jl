module InfoMap

using Graphs
using Random
using SimpleWeightedGraphs


include("flow-modeling.jl")
include("two-level-map-equation.jl")
include("set-operations.jl")


function infomap(g::AbstractGraph; max_iter = 1_000)
    M0 = [[v] for v in Graphs.vertices(g)]
    i = 1
    while i < max_iter
        good_nodes = find_nodes_with_neighbors_in_different_communities(g, M0)
        random_node = rand(good_nodes)
        # Find random_node's community
        target_community = findfirst(m -> random_node in m, M0)

        possible_neighbors = [
            v for v in Graphs.neighbors(g, random_node) if !(v in M0[target_community])
        ]
        iter = 1
        while isempty(possible_neighbors)
            good_nodes = find_nodes_with_neighbors_in_different_communities(g, M0)
            random_node = rand(good_nodes)
            possible_neighbors = [
                v for v in Graphs.neighbors(g, random_node) if !(v in M0[target_community])
            ]
            iter += 1
            iter > 100 && return M0
        end

        target_neighbor = rand(possible_neighbors)

        new_community = findfirst(m -> target_neighbor in m, M0)

        M1 = deepcopy(M0)

        push!(M1[new_community], random_node)
        M1[target_community] = setdiff(M1[target_community], [random_node])
        isempty(M1[target_community]) && deleteat!(M1, target_community)

        abs(L(g, M1) - L(g, M0)) < 1e-6 && return M0

        if L(g, M1) < L(g, M0)
            # println("Old code length: ", L(g, M0))
            # println("New code length: ", L(g, M1))
            M0 = deepcopy(M1)
        end
        i += 1
    end
    return M0
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
export map_equation
export L

export infomap

end
