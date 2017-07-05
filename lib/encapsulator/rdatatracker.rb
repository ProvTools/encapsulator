module Encapsulator
  module RDataTracker
    def RDataTracker.run script
    	require 'rinruby'
      r = RinRuby.new(echo: false)
    	r.eval "require('devtools')"
    	r.eval "install_github('End-to-end-provenance/RDataTracker', ref='graphics')"
    	r.eval "library('RDataTracker')"
      r.eval "ddg.run('#{script}')"
    end

    $ran_script=false
    def RDataTracker.run_script script
    	if !$ran_script
    		run script
    		$ran_script = true
    	end
    	prov_folder = script.gsub('.R', '_ddg')
    	Dir.chdir prov_folder do
    		yield
    	end
    end
  end
end
