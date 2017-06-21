require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/topsort'
require 'rgl/transitivity'

module CodecleanR
  class ProvJSONtoRGL < ProvJSONParser
    attr_reader :dg

    def initialize
      @dg = RGL::DirectedAdjacencyGraph.new # initialise the graph structure
    end

    def used k, v
      @dg.add_edge v['prov:activity'], v['prov:entity']
    end

    def wasGeneratedBy k, v
      @dg.add_edge v['prov:entity'], v['prov:activity']
    end

    def wasDerivedFrom k, v
      @dg.add_edge v['prov:generatedEntity'], v['prov:usedEntity']
    end

    def wasInformedBy k, v
      @dg.add_edge v['prov:informed'], v['prov:informant']
    end

    def wasAssociatedWith k, v
      @dg.add_edge v['prov:activity'], v['prov:agent']
      @dg.add_edge v['prov:agent'], v['prov:plan'] unless !v.key? 'prov:plan'
    end

    def information
      str = "Graph:\n"
      if @dg.directed?
        str += "directed\n"
      else
        str += "not directed\n"
      end

      if @dg.acyclic?
        str += "acyclic\n"
      else
        str += "not acyclic\n"
      end

      str += @dg.num_edges.to_s() +" edges.\n"
      str += @dg.num_vertices.to_s() +" vertices.\n"
      str += (@dg.num_edges.to_f/@dg.num_vertices).to_s() + " edges/vertices ratio.\n"
      puts str
    end

    def svg
      @dg.write_to_graphic_file('svg')
    end

    def jpg
      @dg.write_to_graphic_file('jpg')
    end

    def png
      @dg.write_to_graphic_file('png')
    end
  end
end
