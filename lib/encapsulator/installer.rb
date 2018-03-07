module Encapsulator
  class Installer
    def self.install_fedora
      system 'wget', 'http://download.virtualbox.org/virtualbox/5.1.22/VirtualBox-5.1-5.1.22_115126_fedora25-1.x86_64.rpm', out: $stdout, err: $stdout
      system 'sudo', 'dnf', '-y', '-v', 'install', './VirtualBox-5.1-5.1.22_115126_fedora25-1.x86_64.rpm', out: $stdout, err: $stdout
      system 'sudo', 'dnf', '-y', '-v', 'install', 'vagrant', out: $stdout, err: $stdout
      system 'sudo', 'dnf', '-y', '-v', 'install', 'openssl-devel', out: $stdout, err: $stdout
      system 'sudo', 'dnf', '-y', '-v', 'install', 'libcurl-devel', out: $stdout, err: $stdout
      system 'sudo', 'dnf', '-y', '-v', 'install', 'libxml-devel', out: $stdout, err: $stdout
      system 'sudo', 'dnf', '-y', '-v', 'install', 'libxml2-devel', out: $stdout, err: $stdout
      system 'sudo', 'dnf', '-y', '-v', 'install', 'R', out: $stdout, err: $stdout
    end

    def self.install_ubuntu
    	system 'sudo', 'apt', '-y', 'install', 'virtualbox', 'virtualbox-ext-pack', out: $stdout, err: $stdout
    	system 'sudo', 'apt', '-y', 'install', 'vagrant', out: $stdout, err: $stdout
    end

    def self.install_mac
    	system 'brew', 'cask', 'install', 'virtualbox', out: $stdout, err: $stdout
    	system 'brew', 'cask', 'install', 'vagrant', out: $stdout, err: $stdout
    	system 'brew', 'cask', 'install', 'vagrant-manager', out: $stdout, err: $stdout
    end
  end
end
