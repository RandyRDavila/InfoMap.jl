"""
    transition_probability(g::SimpleWeightedGraph, u::Int64, v::Int64)::Float64

Calculate the transition probability from node `u` to node `v` in a weighted graph.

This function computes the probability of transitioning from one node to another in a
`SimpleWeightedGraph` by dividing the weight of the edge connecting `u` to `v` by the
sum of the weights of all edges connected to `u`.

# Arguments
- `g::SimpleWeightedGraph`: The graph in which the nodes are located.
- `u::Int64`: The starting node.
- `v::Int64`: The target node.

# Returns
- `Float64`: The transition probability from node `u` to node `v`.
"""

function transition_probability(
    g::SimpleWeightedGraph,
    u::Int64,
    v::Int64,
)
    w(u, v) = SimpleWeightedGraphs.get_weight(g, u, v)
    return w(u, v) / sum(w(u, v) for v in Graphs.neighbors(g, u))
end

"""
    transition_probability(g::SimpleGraph, u::Int64, v::Int64)::Float64

Calculate the transition probability from node `u` to node `v` in an unweighted graph.

In an unweighted graph (`SimpleGraph`), this function treats the presence of an edge as
a weight of 1. It computes the probability of transitioning from node `u` to `v` by
considering the number of neighboring nodes of `u`.

# Arguments
- `g::SimpleGraph`: The unweighted graph in which the nodes are located.
- `u::Int64`: The starting node.
- `v::Int64`: The target node.

# Returns
- `Float64`: The transition probability from node `u` to node `v`.
"""

function transition_probability(
    g::SimpleGraph,
    u::Int64,
    v::Int64,
)
    w(u, v) = Graphs.has_edge(g, u, v) ? 1 : 0
    return w(u, v) / sum(w(u, v) for v in Graphs.neighbors(g, u))
end

# Alias for transition_probability
p(g::AbstractGraph, u::Int64, v::Int64) = transition_probability(g, u, v)

"""
    stationary_node_visit_rate(g::SimpleWeightedGraph, v::Int64)::Float64

Compute the stationary visitation rate of a node in a weighted graph.

This function calculates the rate at which a random walker would visit a given
node `v` in a `SimpleWeightedGraph`. The rate is determined by the relative
strength of the node `v` (sum of the weights of its edges) to the total strength
of all nodes in the graph.

# Arguments
- `g::SimpleWeightedGraph`: The weighted graph.
- `v::Int64`: The node for which the visitation rate is being calculated.

# Returns
- `Float64`: The stationary visitation rate of node `v`.
"""
function stationary_node_visit_rate(
    g::SimpleWeightedGraph,
    v::Int64,
)
    w(u, v) = SimpleWeightedGraphs.get_weight(g, u, v)
    s(v) = sum(w(u, v) for u in Graphs.neighbors(g, v)) # Node v's strength

    return s(v) / sum(s(u) for u in Graphs.vertices(g))
end

"""
    stationary_node_visit_rate(g::SimpleGraph, v::Int64)::Float64

Compute the stationary visitation rate of a node in an unweighted graph.

In an unweighted graph (`SimpleGraph`), this function calculates the visitation
rate of a node `v` based on its degree (number of connected edges). The rate is
the ratio of the node's degree to the total degree of all nodes in the graph.

# Arguments
- `g::SimpleGraph`: The unweighted graph.
- `v::Int64`: The node for which the visitation rate is being calculated.

# Returns
- `Float64`: The stationary visitation rate of node `v`.
"""
function stationary_node_visit_rate(
    g::SimpleGraph,
    v::Int64,
)
    w(u, v) = Graphs.has_edge(g, u, v) ? 1 : 0
    s(v) = sum(w(u, v) for u in Graphs.neighbors(g, v)) # Node v's strength

    return s(v) / sum(s(u) for u in Graphs.vertices(g))
end

p(g::AbstractGraph, v::Int64) = stationary_node_visit_rate(g, v)
