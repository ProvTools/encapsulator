module CodecleanR
  class VertexCounter < ProvJSONParser
    attr_reader :map
    attr_reader :files

    def initialize
      @map = Hash.new(0)
      @files = Array.new
    end

    def add key
      @map[key]=@map[key]+1
    end

    def entity k, v
      self.add v['rdt:type']
      if v['rdt:type'] == 'File'
        @files << v['rdt:name']
      end
    end

    def activity k, v
      self.add v['rdt:type']
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
      @files.each do |value|
        puts "#{value}"
      end
    end
  end
end
