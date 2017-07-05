module Encapsulator
  class EdgeCounter < ProvJSONParser
    attr_reader :map

    def initialize
      @map = Hash.new(0)
    end

    def add key
      @map[key]=@map[key]+1
    end

    def used k, v
      self.add v['rdt:type']
    end

    def wasGeneratedBy k, v
      self.add v['rdt:type']
    end

    def wasDerivedFrom k, v
      self.add v['rdt:type']
    end

    def wasInformedBy k, v
      self.add v['rdt:type']
    end

    def wasAssociatedWith k, v
      self.add v['rdt:type']
    end

    def show
      puts "\n\n-------------\nEdge types\n-------------\n"
      @map = @map.sort_by { |key, value| value }.reverse
      @map.each do |key, value|
        puts "#{key}:#{value}"
      end
    end
  end
end
