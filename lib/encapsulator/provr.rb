module Encapsulator
  module ProvR
    def ProvR.run script
    	require 'rinruby'
      r = RinRuby.new(echo: false)
      r.eval "install.packages('devtools')"
    	r.eval "require('devtools')"
    	r.eval "install_github('provtools/provR', ref='dev')"
    	r.eval "require('provR')"
      r.eval "prov.capture('#{script}', save=TRUE)"
    end

    def ProvR.tidy script
      require 'rinruby'
      r = RinRuby.new(echo: false)
    	r.eval "install.packages('formatR', repos = 'http://cran.rstudio.com')"
      r.eval "require('formatR')"
      r.eval "tidy_file('#{script}')"
    end

    $ran_script=false
    def ProvR.run_script script
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
