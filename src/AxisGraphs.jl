
module AxisGraphs

using StaticRanges
using AxisIndices
using LightGraphs
using SimpleWeightedGraphs
using AxisIndices: to_index

export
    AbstractAxisGraph,
    AbstractWeightedAxisGraph,
    AxisGraph

include("AbstractAxisGraph.jl")
struct AxisGraph{T,G<:AbstractGraph{T},A<:AbstractAxis} <: AbstractAxisGraph{T,G,A}
    graph::G
    axis::A
end

AxisGraph(g) = AxisGraph(g, SimpleAxis(OneToMRange(nv(g))))
AxisGraph(g, collection) = AxisGraph(g, Axis(collection, OneToMRange(nv(g))))

Base.parent(g::AxisGraph) = getfield(g, :graph)

# Although it seems weird to overload this for graphs it makes sense in the context
# of how an "axis" is defined (e.g., keys + indices)
Base.axes(g::AxisGraph) = getfield(g, :axis)

# Shouldn't these be performed on the type
#edgetype(g::AbstractMetaGraph) = edgetype(g.graph)

end # module
