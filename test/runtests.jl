
using Test
using AxisGraphs
using LightGraphs
using SimpleWeightedGraphs

@testset "Graph interface" begin
    adjmx1 = [0 1 0; 1 0 1; 0 1 0] # SimpleWeightedGraph
    adjmx2 = [0 1 0; 1 0 1; 1 1 0] # SimpleWeightedDiGraph
    # specific concrete generators - no need for loop
    @test @inferred(eltype(AxisGraph(SimpleWeightedGraph()))) == Int
    @test @inferred(eltype(AxisGraph(SimpleWeightedGraph(adjmx1)))) == Int

    @test @inferred(ne(AxisGraph(SimpleWeightedGraph(path_digraph(5))))) == 4
    @test @inferred(!is_directed(AxisGraph(SimpleWeightedGraph())))

    @test @inferred(eltype(AxisGraph(SimpleWeightedDiGraph()))) == Int
    @test @inferred(eltype(AxisGraph(SimpleWeightedDiGraph(adjmx2)))) == Int
    @test @inferred(ne(AxisGraph(SimpleWeightedDiGraph(path_graph(5))))) == 8
    @test @inferred(is_directed(typeof(AxisGraph(SimpleWeightedDiGraph()))))

    g = AxisGraph(Graph())
    add_vertex!(g)
    @test nv(g) == 1
    add_edge!(g, 1, 1)

    gdx = AxisGraph(SimpleWeightedDiGraph(path_digraph(4)))
    gx = AxisGraph(SimpleWeightedGraph())
end

