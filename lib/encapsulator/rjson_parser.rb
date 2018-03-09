require 'find'
require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/topsort'
require 'rgl/transitivity'
require 'rgl/traversal'

module Encapsulator
  class RJSONParser < ProvJSONParser
    attr_reader :dg
    attr_reader :map
    attr_reader :files
    attr_reader :instructions
    attr_reader :libraries
    attr_reader :packages
    attr_reader :file
    attr_reader :informed

    def initialize r_file, informed=false
      @dg = RGL::DirectedAdjacencyGraph.new # initialise the graph structure
      @map = Hash.new(0)
      @files = Hash.new
      @copies = Hash.new
      @instructions = Hash.new
      @libraries = Hash.new
      @packages = Hash.new
      @script = IO.readlines(r_file)
      @informed = informed
    end

    def get_operation start_line, end_line
      start_line-=1
      end_line-=1
      operation = ''
      for i in start_line..end_line
        operation += @script[i] unless @script[i].nil?
      end
      return operation
    end

    def add key
      @map[key]=@map[key]+1
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
      @dg.add_edge v['prov:informed'], v['prov:informant'] unless !informed
    end

    def wasAssociatedWith k, v
      @dg.add_edge v['prov:activity'], v['prov:agent']
      @dg.add_edge v['prov:agent'], v['prov:plan'] unless !v.key? 'prov:plan'
    end

    def entity k, v
      self.add v['rdt:type']
      if v['rdt:type'] == 'File'
        @files[k]=v['rdt:name']
      end
    end

    def activity k, v
      self.add v['rdt:type']
      if v['rdt:type'] == 'Operation'
        @instructions[k]=get_operation(v['rdt:startLine'].to_i, v['rdt:endLine'].to_i)
      end
      if /(library|require)\(('|")[a-zA-Z]+('|")/.match v['rdt:name']
        @libraries[k]=v['rdt:name']
      end
      if k == 'environment'
        v['rdt:installedPackages'].each do |l|
          packages[l['package']]=l['version']
        end
      end
    end

    def agent k, v
      self.add v['rdt:type']
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
      Dir.chdir('..') do
        @dg.write_to_graphic_file('svg')
      end
    end

    def jpg
      Dir.chdir('..') do
        @dg.write_to_graphic_file('jpg')
      end
    end

    def png
      Dir.chdir('..') do
        @dg.write_to_graphic_file('png')
      end
    end

		def get_list file
			id = ''
			@files.each do |k, v|
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

    def source_code file
			statements = Array.new
      list = get_list file
      list.delete_if { |v| !v.include?('p') }
      list = list.sort_by{ |m| m.tr('p', '').to_i }
      list.each do |v|
				next unless !@instructions[v].nil?
        statements << @instructions[v]
      end
      return statements
    end

		def script_inputs file
			inputs = Hash.new
			list = get_list file
			list.delete_if { |v| !is_input_with_id?(v) }
			list.each do |v|
				next unless !@files[v].nil?
				Find.find '..' do |path|
					if path.include? '/'+@files[v]
						inputs[path.gsub @files[v], '']= path
					end
				end
      end
			return inputs
		end

    def script output
      script = Array.new
      @libraries.each do |k, v|
        script << v
      end
      statements = source_code output
      script << statements unless statements.empty?
    end

    def show
      file_show
			puts "\n\n"
      packages_show
    end

    def file_show
      puts 'Files'
			puts '-----'
      @files.each do |key, value|
        if is_input? value
					puts "Input #{value}"
				else
					puts "Output #{value}"
				end
      end
    end

		def packages_show
      puts 'Packages'
			puts '--------'
			@packages.each do |key, value|
				if !['datasets', 'utils', 'graphics', 'grDevices', 'methods', 'stats', 'provR', 'devtools'].include?(key)
        	puts "#{key} v#{value}"
        end
			end
		end

    def is_input? file_name
			source_code(file_name).empty?
		end

		def is_input_with_id? id
			@files.each do |key, value|
        if id == key
					if is_input? value
						return true
					end
				end
      end
			return false
		end

    def install
      instructions = Array.new
      @packages.each do |key, value|
        if key == 'base'
          instructions << "  sudo dnf -y -v install R-#{value}"
	        instructions << "  sudo dnf -y -v install R"
          instructions << "  sudo su - -c \"R -e \\\\\\\"install.packages(\'devtools\', repos=\'http://cran.rstudio.com/\', dependencies = TRUE)\\\\\\\"\""
        elsif !['datasets', 'utils', 'graphics', 'grDevices', 'methods', 'stats', 'provR', 'devtools'].include?(key)
          instructions << "  sudo su - -c \"R -e \\\\\\\"require('devtools');install_version(\'#{key}\', version=\'#{value}\', repos=\'http://cran.rstudio.com/\')\\\\\\\"\""
        end
      end
      return instructions
    end
  end
end
