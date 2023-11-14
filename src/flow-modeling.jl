
function transition_probability(
    g::SimpleWeightedGraph,
    u::Int64,
    v::Int64,
)
    w(u, v) = SimpleWeightedGraph.get_weight(g, u, v)
    return w(u, v) / sum(w(u, v) for v in Graphs.neighbors(g, u))
end


function transition_probability(
    g::SimpleGraph,
    u::Int64,
    v::Int64,
)
    w(u, v) = Graphs.has_edge(g, u, v) ? 1 : 0
    return w(u, v) / sum(w(u, v) for v in Graphs.neighbors(g, u))
end

p(g::AbstractGraph, u::Int64, v::Int64) = transition_probability(g, u, v)

function stationary_node_visit_rate(
    g::SimpleWeightedGraph,
    v::Int64,
)
    w(u, v) = SimpleWeightedGraph.get_weight(g, u, v)
    s(v) = sum(w(u, v) for u in Graphs.neighbors(g, v)) # Node v's strength

    return s(v) / sum(s(u) for u in Graphs.vertices(g))
end

function stationary_node_visit_rate(
    g::SimpleGraph,
    v::Int64,
)
    w(u, v) = Graphs.has_edge(g, u, v) ? 1 : 0
    s(v) = sum(w(u, v) for u in Graphs.neighbors(g, v)) # Node v's strength

    return s(v) / sum(s(u) for u in Graphs.vertices(g))
end

p(g::AbstractGraph, v::Int64) = stationary_node_visit_rate(g, v)