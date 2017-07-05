require 'find'
require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/topsort'
require 'rgl/transitivity'
require 'rgl/traversal'

module Encapsulator
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
      #@dg.add_edge v['prov:informed'], v['prov:informant']
    end

    def wasAssociatedWith k, v
      @dg.add_edge v['prov:activity'], v['prov:agent']
      @dg.add_edge v['prov:agent'], v['prov:plan'] unless !v.key? 'prov:plan'
    end

    def information
      str = "\n------\n"
      str += "Graph:\n"
      str += "------\n"
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

		def get_list file, vertices
			id = ''
			vertices.files.each do |k, v|
				if v == file
					id = k
					break
				end
			end
			if id==''
				return Array.new
			end
      tree = @dg.bfs_search_tree_from(id)
      g = @dg.vertices_filtered_by {|v| tree.has_vertex? v}
      list = g.vertices
		end

    def source_code file, vertices
			statements = Array.new
      list = get_list file, vertices
      list.delete_if { |v| !v.include?('p') }
      list = list.sort_by{ |m| m.tr('p', '').to_i }
      list.each do |v|
				next unless !vertices.instructions[v].nil?
        statements << vertices.instructions[v]
      end
      return statements
    end

		def script_inputs file
			inputs = Hash.new
			vertices = Encapsulator::VertexCounter.new.read_json_file(@filename)
			list = get_list file, vertices
			list.delete_if { |v| !vertices.is_input_with_id(self, v) }
			list.each do |v|
				next unless !vertices.files[v].nil?
				Find.find '..' do |path|
					if path.include? '/'+vertices.files[v]
						inputs[path.gsub vertices.files[v], '']= path
					end
				end
      end
			return inputs
		end

    def script output
      vertices = Encapsulator::VertexCounter.new.read_json_file(@filename)
      script = Array.new
      vertices.libraries.each do |k, v|
        script << v
      end
      statements = source_code output, vertices
      script << statements unless statements.empty?
    end
  end
end
