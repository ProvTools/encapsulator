module Encapsulator
  module Installer
    def install_fedora
      system 'wget', 'http://download.virtualbox.org/virtualbox/5.1.22/VirtualBox-5.1-5.1.22_115126_fedora25-1.x86_64.rpm', out: $stdout, err: $stdout
      system 'sudo', 'dnf', '-y', '-v', 'install', './VirtualBox-5.1-5.1.22_115126_fedora25-1.x86_64.rpm', out: $stdout, err: $stdout
      system 'sudo', 'dnf', '-y', '-v', 'install', 'vagrant', out: $stdout, err: $stdout
    end

    def install_ubuntu
    	system 'sudo', 'apt', '-y', 'install', 'virtualbox', 'virtualbox-ext-pack', out: $stdout, err: $stdout
    	system 'sudo', 'apt', '-y', 'install', 'vagrant', out: $stdout, err: $stdout
    end

    def install_mac
    	system 'brew', 'cask', 'install', 'virtualbox', out: $stdout, err: $stdout
    	system 'brew', 'cask', 'install', 'vagrant', out: $stdout, err: $stdout
    	system 'brew', 'cask', 'install', 'vagrant-manager', out: $stdout, err: $stdout
    end
  end
end