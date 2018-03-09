require 'fileutils'

module Encapsulator
  module ProvR
    def ProvR.run script
      FileUtils.mkdir_p './prov'
      require 'rinruby'
      r = RinRuby.new(echo: false)
      r.eval "chooseCRANmirror(ind=81)"
      r.eval "install.packages('devtools')"
      r.eval "require('devtools')"
      r.eval "install_github('provtools/provR', ref='dev')"
      r.eval "require('provR')"
      r.eval "prov.capture('#{script}')"
      r.eval "f <- file('./prov/ddg.json')"
      r.eval "writeLines(prov.json(), f)"
      r.eval "close(f)"
    end

    def ProvR.tidy script
      require 'rinruby'
      r = RinRuby.new(echo: false)
      r.eval "chooseCRANmirror(ind=81)"
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
    	prov_folder = './prov'
    	Dir.chdir prov_folder do
    		yield
    	end
    end
  end
end
