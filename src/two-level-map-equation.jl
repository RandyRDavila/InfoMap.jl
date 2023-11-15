"""
    probability_walker_enters(g::AbstractGraph, m::Vector{Int64})::Float64

Calculate the total probability that a random walker enters a specified set
of nodes `m` from outside in graph `g`.

This function computes the sum of probabilities for all scenarios where a
walker, currently outside the set `m`, transitions into the set. It uses the
`p(g, u)` function to get the stationary node visit rate and `p(g, u, v)` for
the transition probability between nodes.

# Arguments
- `g::AbstractGraph`: The graph being analyzed.
- `m::Vector{Int64}`: A vector of node indices representing the set of nodes.

# Returns
- `Float64`: The total probability of a walker entering the set of nodes `m`.
"""
function probability_walker_enters(
    g::AbstractGraph,
    m::Vector{Int64},
)
    return sum(
        p(g, u)*p(g, u, v)
        for u in Graphs.vertices(g)
        for v in Graphs.vertices(g)
        if !(u in m) && v in m
    )
end

# Alias for probability_walker_enters
qm_in(g::AbstractGraph, m::Vector{Int64}) = probability_walker_enters(g, m)

"""
    probability_walker_leaves(g::AbstractGraph, m::Vector{Int64})::Float64

Calculate the total probability that a random walker leaves a specified set of
nodes `m` to go outside in graph `g`.

This function computes the sum of probabilities for all scenarios where a walker,
currently inside the set `m`, transitions out of the set. It uses the `p(g, u)`
function for the stationary node visit rate and `p(g, v, u)` for the transition
probability between nodes.

# Arguments
- `g::AbstractGraph`: The graph being analyzed.
- `m::Vector{Int64}`: A vector of node indices representing the set of nodes.

# Returns
- `Float64`: The total probability of a walker leaving the set of nodes `m`.
"""
function probability_walker_leaves(
    g::AbstractGraph,
    m::Vector{Int64},
)
    return sum(
        p(g, u)*p(g, v, u)
        for u in Graphs.vertices(g)
        for v in Graphs.vertices(g)
        if u in m && !(v in m)
    )
end

# Alias for probability_walker_leaves
qm_out(g::AbstractGraph, m::Vector{Int64}) = probability_walker_leaves(g, m)

"""
    total_use_rate_module_cookbook(g::AbstractGraph, m::Vector{Int64})::Float64

Compute the total use rate of a module `m` in a graph `g`.

This function calculates the total rate at which a random walker uses a module by
adding the probability that the walker leaves the module (`qm_out`) to the sum of
stationary visitation rates of nodes inside the module.

# Arguments
- `g::AbstractGraph`: The graph being analyzed.
- `m::Vector{Int64}`: A vector of node indices representing the module.

# Returns
- `Float64`: The total use rate of the module.
"""
function total_use_rate_module_cookbook(
    g::AbstractGraph,
    m::Vector{Int64},
)
    return qm_out(g, m) + sum(p(g, u) for u in m)
end

# Alias for total_use_rate_module_cookbook
p_circle_m(g::AbstractGraph, m::Vector{Int64}) = total_use_rate_module_cookbook(g, m)

"""
    codelength_in_module(g::AbstractGraph, m::Vector{Int64})::Float64

Calculate the codelength for a module `m` in a graph `g`.

This function computes the codelength, which is a measure of the information
required to describe the movements of a random walker within a module. It is
calculated using probabilities of the walker leaving the module and the relative
visitation rates of nodes within the module.

# Arguments
- `g::AbstractGraph`: The graph being analyzed.
- `m::Vector{Int64}`: A vector of node indices representing the module.

# Returns
- `Float64`: The codelength of the module.
"""
function codelength_in_module(
    g::AbstractGraph,
    m::Vector{Int64},
)
    return -1 * (qm_out(g, m)/p_circle_m(g, m)*log2(qm_out(g, m)/p_circle_m(g, m)) + sum((p(g, u)/p_circle_m(g, m))*log2((p(g, u)/p_circle_m(g, m))) for u in m))
end

# Alias for codelength_in_module
H(g::AbstractGraph, m::Vector{Int64}) = codelength_in_module(g, m)


q_in(g::AbstractGraph, M::Vector{Vector{Int64}}) = sum(qm_in(g, m) for m in M)

"""
    code_length_index_module(g::AbstractGraph, M::Vector{Vector{Int64}})::Float64

Compute the codelength for an index module in a graph `g`.

This function calculates the codelength of an index module, which represents the
information needed to describe transitions of a random walker between different
modules. The codelength is calculated based on the probability of entering each module.

# Arguments
- `g::AbstractGraph`: The graph being analyzed.
- `M::Vector{Vector{Int64}}`: A vector of vectors, each representing a module with node indices.

# Returns
- `Float64`: The codelength for the index module.
"""
function code_length_index_module(
    g::AbstractGraph,
    M::Vector{Vector{Int64}},
)
    return -1 * sum((qm_in(g, m)/q_in(g, M))*log2((qm_in(g, m)/q_in(g, M))) for m in M)
end

# Alias for code_length_index_module
H(g::AbstractGraph, M::Vector{Vector{Int64}}) = code_length_index_module(g, M)

"""
    map_equation(g::AbstractGraph, M::Vector{Vector{Int64}})::Float64

Calculate the map equation value for a partition of graph `g` into modules `M`.

The map equation is a measure used in network science to determine the effectiveness
of a network partitioning. It calculates the weighted sum of codelengths for
individual modules and the index module, representing the overall information
required to describe a random walker's movement in the network.

# Arguments
- `g::AbstractGraph`: The graph being analyzed.
- `M::Vector{Vector{Int64}}`: A vector of vectors, each representing a module with node indices.

# Returns
- `Float64`: The map equation value for the given partitioning of the graph.
"""
function map_equation(
    g::AbstractGraph,
    M::Vector{Vector{Int64}},
)
    return q_in(g, M)*H(g, M) + sum(p_circle_m(g, m)*H(g, m) for m in M)
end

# Alias for map_equation
L(g::AbstractGraph, M::Vector{Vector{Int64}}) = map_equation(g, M)
