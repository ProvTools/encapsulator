require 'json'

module Encapsulator
  class ProvJSONParser
		attr_reader :filename

    def read_json_file filename
      if filename != nil
				@filename=filename
        parse_json File.read(filename) unless !File.file?(filename)
        print "File does not exist\n" unless File.file?(filename)
      end
      self
    end

    def read_log_file filename
      if filename != nil
        open(filename) do |file|
          file.each_line do |line|
            parse_json line
          end
        end unless !File.file?(filename)
        print "File does not exist\n" unless File.file?(filename)
      end
      self
    end

    def used k, v
    end

    def wasGeneratedBy k, v
    end

    def wasDerivedFrom k, v
    end

    def wasInformedBy k, v
    end

    def wasAssociatedWith k, v
    end

    def prefix k, v
    end

    def entity k, v
    end

    def activity k, v
    end

    def agent k, v
    end

    def parse_json string
      begin
        json = JSON.parse(string)
      rescue JSON::ParserError
        puts 'Failed parsing.'
        abort
      end

      json['prefix'].each do |k, v|
        self.prefix k, v
      end unless !json.key? 'prefix'

      json['entity'].each do |k, v|
        self.entity k, v
      end unless !json.key? 'entity'

      json['activity'].each do |k, v|
        self.activity k, v
      end unless !json.key? 'activity'

      json['agent'].each do |k, v|
        self.activity k, v
      end unless !json.key? 'agent'

      json['used'].each do |k, v|
        self.used k, v
      end unless !json.key? 'used'

      json['wasGeneratedBy'].each do |k, v|
        self.wasGeneratedBy k, v
      end unless !json.key? 'wasGeneratedBy'

      json['wasDerivedFrom'].each do |k, v|
        self.wasDerivedFrom k, v
      end unless !json.key? 'wasDerivedFrom'

      json['wasInformedBy'].each do |k, v|
        self.wasInformedBy k, v
      end unless !json.key? 'wasInformedBy'

      json['wasAssociatedWith'].each do |k, v|
        self.wasAssociatedWith k, v
      end unless !json.key? 'wasAssociatedWith'
    end
  end
end
