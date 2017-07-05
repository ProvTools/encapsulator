module Encapsulator
  module RDataTracker
    def RDataTracker.run script
    	require 'rinruby'
      r = RinRuby.new(echo: false)
      r.eval "install.packages('devtools')"
    	r.eval "require('devtools')"
    	r.eval "install_github('End-to-end-provenance/RDataTracker', ref='graphics')"
    	r.eval "require('RDataTracker')"
      r.eval "ddg.run('#{script}')"
    end

    def RDataTracker.tidy script
      require 'rinruby'
      r = RinRuby.new(echo: false)
    	r.eval "install.packages('formatR', repos = 'http://cran.rstudio.com')"
      r.eval "require('formatR')"
      r.eval "tidy_file('#{script}')"
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
