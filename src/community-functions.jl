function find_community(
    partition::Vector{Vector{Int64}},
    node::Int64,
)
    for (i, community) in enumerate(partition)
        if node in community
            return i
        end
    end
end

function in_community(
    community::Vector{Int64},
    node::Int64,
)
    return node in community
end

function move_node!(
    partition::Vector{Vector{Int64}},
    node::Int64,
    from::Int64,
    to::Int64,
)
    push!(partition[to], node)
    deleteat!(partition[from], findfirst(==(node), partition[from]))
    if isempty(partition[from])
        deleteat!(partition, from)
    end
    return nothing
end
