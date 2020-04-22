
abstract type AbstractAxisGraph{T,G,A} <: AbstractGraph{T} end

const AbstractWeightedAxisGraph{T,U,G<:AbstractSimpleWeightedGraph{T,U},A} = AbstractAxisGraph{T,G,A}

Base.eltype(g::AbstractAxisGraph{T}) where {T} = T

LightGraphs.nv(g::AbstractAxisGraph) = nv(parent(g))
function LightGraphs.vertices(g::AbstractAxisGraph)
    return AxisIndicesArray(vertices(parent(g)), (axes(g),))
end

LightGraphs.has_vertex(g::AbstractAxisGraph, x...) = has_vertex(parent(g), x...)

@inline LightGraphs.has_edge(g::AbstractAxisGraph, x...) = has_edge(parent(g), x...)

function LightGraphs.add_vertex!(g::AbstractAxisGraph)
    add_vertex!(parent(g))
    StaticRanges.grow_last!(axes(g))
    return g
end

LightGraphs.ne(g::AbstractAxisGraph) = ne(parent(g))
LightGraphs.edges(g::AbstractAxisGraph) = edges(parent(g))

function LightGraphs.add_edge!(g::AbstractAxisGraph, u, v)
    return add_edge!(parent(g), to_index(axes(g)), to_index(axes(g), v))
end
function LightGraphs.add_edge!(g::AbstractAxisGraph, u, v, val)
    return add_edge!(parent(g), to_index(axes(g)), to_index(axes(g), v), val)
end

function LightGraphs.rem_edge!(g::AbstractAxisGraph, u, v)
    return rem_edge!(parent(g), to_index(axes(g), u), to_index(axes(g), v))
end

function LightGraphs.inneighbors(g::AbstractAxisGraph, v)
    return inneighbors(parent(g), to_index(axes(g), v))
end
function LightGraphs.outneighbors(g::AbstractAxisGraph, v)
    return outneighbors(parent(g), to_index(axes(g), v))
end

Base.issubset(g::AbstractAxisGraph, h::AbstractGraph) = issubset(parent(g), h)


LightGraphs.is_directed(::Type{<:AbstractAxisGraph{T,G}}) where {T,G}= is_directed(G)

SimpleWeightedGraphs.weighttype(::Type{<:AbstractAxisGraph{T,G}}) where {T,G} = weighttype(G)

# TODO these should be AxisIndicesArrays
SimpleWeightedGraphs.degree_matrix(g::AbstractAxisGraph, args...) = degree_matrix(parent(g), args...)
function LightGraphs.adjacency_matrix(g::AbstractAxisGraph, args...)
    return adjacency_matrix(parent(g), args...)
end

function LightGraphs.laplacian_matrix(g::AbstractAxisGraph, args...)
    return laplacian_matrix(parent(g), args...)
end

function LightGraphs.pagerank(g::AbstractAxisGraph, α=0.85, n::Integer=100, ϵ=1.0e-6)
    return pagerank(parent(g), α, n, ϵ)
end

function SimpleWeightedGraphs.get_weight(g::AbstractAxisGraph, u, v)
    return get_weight(parent(g), to_index(axes(g), u), to_index(axes(g), v))
end

LightGraphs.connected_components(g::AbstractAxisGraph) = connected_components(parent(g))

function LightGraphs.induced_subgraph(g::AbstractAxisGraph, vlist)
    return induced_subgraph(parent(g), to_index(axes(g), vlist))
end

###
### Base
###
Base.zero(g::AbstractAxisGraph) = AxisGraph(zero(parent(g)), axes(g))

Base.copy(g::AbstractAxisGraph) = AxisGraph(copy(parent(g)), copy(axes(g)))
function Base.show(io::IO, g::AbstractAxisGraph{T}) where {T}
    dir = is_directed(parent(g)) ? "directed" : "undirected"
    print(io, "{$(nv(g)), $(ne(g))} $dir axis $T graph")
end

function Base.show(io::IO, g::AbstractWeightedAxisGraph{T,U}) where {T,U}
    dir = is_directed(parent(g)) ? "directed" : "undirected"
    print(io, "{$(nv(g)), $(ne(g))} $dir axis $T graph with $U weights")
end

