module CodecleanR
  class VertexCounter < ProvJSONParser
    attr_reader :map
    attr_reader :files
    attr_reader :instructions
    attr_reader :libraries
    attr_reader :packages

    def initialize
      @map = Hash.new(0)
      @files = Hash.new
      @instructions = Hash.new
      @libraries = Hash.new
      @packages = Hash.new
    end

    def add key
      @map[key]=@map[key]+1
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
        @instructions[k]=v['rdt:name']
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

    def show provrgl
			puts 'Files'
			puts '-----'
      @files.each do |key, value|
        if is_input provrgl, value
					puts "Input #{value}"
				else
					puts "Output #{value}"
				end
      end
			puts "\n\n"
			puts 'Packages'
			puts '--------'
      packages_show
    end

		def packages_show
			@packages.each do |key, value|
				if !['datasets', 'utils', 'graphics', 'grDevices', 'methods', 'stats', 'RDataTracker', 'devtools'].include?(key)
        	puts "#{key} v#{value}"
        end
			end
		end

		def is_input provrgl, file_id
			provrgl.source_code(file_id, self).empty?
		end

    def install
      instructions = Array.new
      @packages.each do |key, value|
        if key == 'base'
          instructions << "  sudo dnf -y -v install R-#{value}"
	        instructions << "  sudo dnf -y -v install R"
          instructions << "  sudo su - -c \"R -e \\\\\\\"install.packages(\'devtools\', repos=\'http://cran.rstudio.com/\', dependencies = TRUE)\\\\\\\"\""
        elsif !['datasets', 'utils', 'graphics', 'grDevices', 'methods', 'stats', 'RDataTracker', 'devtools'].include?(key)
          instructions << "  sudo su - -c \"R -e \\\\\\\"require('devtools');install_version(\'#{key}\', version=\'#{value}\', repos=\'http://cran.rstudio.com/\')\\\\\\\"\""
        end
      end
      return instructions
    end
  end
end
