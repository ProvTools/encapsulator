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

    def show
      puts "\n\n-------------\nVertex types\n-------------\n"
      @map = @map.sort_by { |key, value| value }.reverse
      @map.each do |key, value|
        puts "#{key}:#{value}"
      end
      @files.each do |key, value|
        puts "#{key}:#{value}"
      end
      @packages.each do |key, value|
        puts "#{key}:#{value}"
      end
    end

    def install
      instructions = Array.new
      @packages.each do |key, value|
        if key == 'base'
          instructions << "  sudo -y -v dnf install R-#{value}"
          instructions << "  sudo su - -c \"R -e \\\\\\\"install.packages(\'devtools\', repos=\'http://cran.rstudio.com/\', dependencies = TRUE)\\\\\\\"\""
        elsif !['datasets', 'utils', 'graphics', 'grDevices', 'methods', 'stats', 'RDataTracker', 'devtools'].include?(key)
          instructions << "  sudo su - -c \"R -e \\\\\\\"require('devtools');install_version(\'#{key}\', version=\'#{value}\', repos=\'http://cran.rstudio.com/\')\\\\\\\"\""
        end
      end
      return instructions
    end
  end
end
