module Encapsulator
  module CLI
    def CLI.usage
      puts "USAGE\n\n"
      puts '--info <path to R script> display information about the provenance graph'
      puts '--jpg <path to R script> output graph as jpg'
      puts '--png <path to R script> output graph as png'
      puts '--svg <path to R script> output graph as svg'
      puts '--code <path to R script> <output> [output] ... [output] create the source necessary to generate the specified output'
      puts '--run <path to R script> run the provided r script'
    	puts '--encapsulate <user>/<project> <script> <output> [output] ... [output] create the specified capsule'
    	puts '--decapsulate <user>/<project> download the coresponding capsule'
    end

    def CLI.vagrant vm_name, install_instructions
      provision = Array.new
      provision << '# -*- mode: ruby -*-'
      provision << '# vi: set ft=ruby :'
      provision << 'Vagrant.configure(2) do |config|'
      provision << "  "+'config.vm.box = "jhcook/fedora25"'
      provision << "  "+'config.vm.provider "virtualbox" do |vb|'
      provision << "  "+'vb.gui = true'
      provision << "  "+'vb.memory = 2048'
      provision << "  "+'vb.customize ["modifyvm", :id, "--cpuexecutioncap", "70"]'
      provision << "  "+'vb.cpus = 2'
      provision << "  "+"vb.name = \"#{vm_name.gsub '/', '_'}\""
      provision << 'end'
      provision << 'config.vm.provision "shell", inline: <<-SHELL'
    	provision << "  "+'cp -a /vagrant/workspace/. /home/vagrant/Documents'
      provision << "  "+'sudo dnf -y -v install openssl-devel libxml2-devel'
      provision << "  "+'sudo dnf -y -v install libcurl libcurl-devel'
      provision << "  "+'sudo dnf -y -v install perl-CPAN'
      provision << "  "+'sudo dnf -y -v install ruby'
      provision << "  "+'wget https://atom.io/download/rpm'
      provision << "  "+'mv ./rpm ./atom.rpm'
      provision << "  "+'sudo dnf -y -v install ./atom.rpm'
      provision << "  "+'rm -rf ./atom.rpm'
      provision << install_instructions
    	provision << " "+'wget https://download1.rstudio.org/rstudio-1.0.143-x86_64.rpm'
    	provision << "  "+'sudo dnf -y -v install ./rstudio-1.0.143-x86_64.rpm'
    	provision << "  "+'rm -rf ./rstudio-1.0.143-x86_64.rpm'
      provision << 'SHELL'
      provision << 'end'
    end

    def CLI.encapsulate capsule_name, script
    	ProvR.run_script script do
    		v = Encapsulator::RJSONParser.new('../'+script).read_json_file('ddg.json')
    		system 'mkdir', '-p', '../.'+capsule_name
    		Dir.chdir '../.'+capsule_name do
    			puts "In directory #{Dir.pwd}..."
    			File.open("Vagrantfile", "w+") do |f|
    				puts 'Encapsulator will attempt to install the following packages:'
    				v.packages_show
    				script = CLI.vagrant capsule_name, v.install
    	  		f.puts(script)
    			end
    			puts 'Provision script is ready...'
    			puts 'getting your capsule ready, be patient...'
    			system("vagrant", "up", out: $stdout, err: $stdout)
    			system("vagrant", "halt", out: $stdout, err: $stdout)
    		end
    		puts 'Your capsule should be visible in the virtualbox interface.'
    	end
    end

    def CLI.decapsulate capsule_name
    	puts "looking for the capsule #{vm}..."
    	system("vagrant", "init", capsule_name, out: $stdout, err: $stdout)
    	puts 'getting your capsule ready, be patient...'
    	system("vagrant", "up", out: $stdout, err: $stdout)
    	system("vagrant", "halt", out: $stdout, err: $stdout)
    	puts 'you should find your capsule in the virtualbox GUI.'
    end

    def CLI.source_code script, target_output, destination
    	ProvR.run_script script do
    		script = Encapsulator::RJSONParser.new('../'+script).read_json_file('ddg.json').script target_output
    	end
    	if script.nil?
    		abort "#{target_output} is not a valid output file."
    	else
    		File.open(destination, "w+") do |f|
    			f.puts(script)
    		end
        ProvR.tidy destination
    		puts "Script written to #{destination}"
    	end
    end

    def CLI.get_jpg script, all=false
      ProvR.run_script script do
    		Encapsulator::RJSONParser.new('../'+script, all).read_json_file('ddg.json').jpg
    	end
    end

    def CLI.get_png script, all=false
      ProvR.run_script script do
    		Encapsulator::RJSONParser.new('../'+script, all).read_json_file('ddg.json').png
    	end
    end

    def CLI.get_svg script, all=false
      ProvR.run_script script do
    		Encapsulator::RJSONParser.new('../'+script, all).read_json_file('ddg.json').svg
    	end
    end

    def CLI.info script
      ProvR.run_script script do
      	Encapsulator::RJSONParser.new('../'+script).read_json_file('ddg.json').show
    	end
    end

    def CLI.script_inputs script, target_output, destination
    	inputs = nil
    	destination = '../'+destination
    	ProvR.run_script script do
    		inputs = Encapsulator::RJSONParser.new('../'+script).read_json_file('ddg.json').script_inputs target_output
    		inputs.each do |path, file|
    			next unless !file.include? destination
    			dest_path = path.gsub '..', destination
    			dest = file.gsub '..', destination
    			system 'mkdir', '-p', dest_path
    			system 'cp', '-f', file, dest
    			puts "Saved input #{dest} for script #{target_output}.R"
    		end
    	end
    end
  end
end
