module AxisGraphs

using AxisIndices
using LightGraphs
using SimpleWeightedGraphs
using Base: @propagate_inbounds
using AxisIndices: to_index

export AbstractAxisGraph, AxisGraph

abstract type AbstractAxisGraph{T,G,A} <: AbstractGraph{T} end

struct AxisGraph{T,G<:AbstractGraph{T},A} <: AbstractAxisGraph{T,G,A}
    graph::G
    axes::A
end

AxisGraph(g) = AxisGraph(g, (SimpleAxis(Base.OneTo(nv(g))),))
AxisGraph(g, collection) = AxisGraph(g, (Axis(collection, Base.OneTo(nv(g))),))

Base.parent(g::AxisGraph) = getfield(g, :graph)

# Although it seems weird to overload this for graphs it makes sense in the context
# of how an "axis" is defined (e.g., keys + indices)
Base.axes(g::AxisGraph) = getfield(g, :axes)

# Shouldn't these be performed on the type
Base.eltype(g::AxisGraph{T}) where {T} = T
#edgetype(g::AbstractMetaGraph) = edgetype(g.graph)

###
### Vertices
###
LightGraphs.nv(g::AbstractAxisGraph) = nv(parent(g))
LightGraphs.vertices(g::AbstractAxisGraph) = vertices(parent(g))

LightGraphs.has_vertex(g::AbstractAxisGraph, x...) = has_vertex(parent(g), x...)
@inline LightGraphs.has_edge(g::AbstractAxisGraph, x...) = has_edge(parent(g), x...)

@propagate_inbounds function LightGraphs.add_vertex!(g::AbstractAxisGraph, u, v,)
    return add_vertex!(parent(g), to_index(axes(g, 1), u), to_index(axes(g, 1), v))
end

@propagate_inbounds function LightGraphs.rem_vertex!(g::AbstractAxisGraph, u, v)
    return rem_vertex!(parent(g), to_index(axes(g, 1), u), to_index(axes(g, 1), v))
end

###
### Edges
###
LightGraphs.ne(g::AbstractAxisGraph) = ne(parent(g))
LightGraphs.edges(g::AxisGraph) = edges(parent(g))

@propagate_inbounds function LightGraphs.add_edge!(g::AbstractAxisGraph, u, v)
    return add_edge!(parent(g), to_index(axes(g, 1), u), to_index(axes(g, 1), v))
end
@propagate_inbounds function LightGraphs.add_edge!(g::AbstractAxisGraph, u, v, val)
    return add_edge!(parent(g), to_index(axes(g, 1), u), to_index(axes(g, 1), v), val)
end

@propagate_inbounds function LightGraphs.rem_edge!(g::AbstractAxisGraph, u, v)
    return rem_edge!(parent(g), to_index(axes(g, 1), u), to_index(axes(g, 1), v))
end


function LightGraphs.inneighbors(g::AbstractAxisGraph, v)
    return inneighbors(parent(g), to_index(axes(g, 1), v))
end
function LightGraphs.outneighbors(g::AbstractAxisGraph, v)
    return outneighbors(parent(g), to_index(axes(g, 1), v))
end

Base.Base.issubset(g::AbstractAxisGraph, h::AbstractGraph) = issubset(parent(g), h)


LightGraphs.is_directed(::Type{<:AbstractAxisGraph{T,G}}) where {T,G} = is_directed(G)

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
    return get_weight(parent(g), to_index(axes(g, 1), u), to_index(axes(g, 1), v))
end

LightGraphs.connected_components(g::AbstractAxisGraph) = connected_components(parent(g))

function LightGraphs.induced_subgraph(g::AbstractAxisGraph, vlist)
    return induced_subgraph(parent(g), to_index(axes(g, 1), vlist))
end

###
### Base
###
Base.zero(g::AbstractAxisGraph) = AxisGraph(zero(parent(g)), axes(g, 1))

Base.copy(g::AbstractAxisGraph) = AxisGraph(copy(parent(g)), copy(axes(g, 1)))

end # module
