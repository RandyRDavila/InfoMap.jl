
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

qm_in(g::AbstractGraph, m::Vector{Int64}) = probability_walker_enters(g, m)

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

qm_out(g::AbstractGraph, m::Vector{Int64}) = probability_walker_leaves(g, m)

function total_use_rate_module_cookbook(
    g::AbstractGraph,
    m::Vector{Int64},
)
    return qm_out(g, m) + sum(p(g, u) for u in m)
end

p_circle_m(g::AbstractGraph, m::Vector{Int64}) = total_use_rate_module_cookbook(g, m)

function codelength_in_module(
    g::AbstractGraph,
    m::Vector{Int64},
)
    return -1 * (qm_out(g, m)/p_circle_m(g, m)*log2(qm_out(g, m)/p_circle_m(g, m)) + sum((p(g, u)/p_circle_m(g, m))*log2((p(g, u)/p_circle_m(g, m))) for u in m))
end

H(g::AbstractGraph, m::Vector{Int64}) = codelength_in_module(g, m)


q_in(g::AbstractGraph, M::Vector{Vector{Int64}}) = sum(qm_in(g, m) for m in M)

function code_length_index_module(
    g::AbstractGraph,
    M::Vector{Vector{Int64}},
)
    return -1 * sum((qm_in(g, m)/q_in(g, M))*log2((qm_in(g, m)/q_in(g, M))) for m in M)
end

H(g::AbstractGraph, M::Vector{Vector{Int64}}) = code_length_index_module(g, M)

function map_equation(
    g::AbstractGraph,
    M::Vector{Vector{Int64}},
)
    return q_in(g, M)*H(g, M) + sum(p_circle_m(g, m)*H(g, m) for m in M)
end

L(g::AbstractGraph, M::Vector{Vector{Int64}}) = map_equation(g, M)