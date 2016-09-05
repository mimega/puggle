# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "zimpler/ruby-2.3.1-dev"

  config.vm.hostname = "puggle"

  config.vm.provision "shell", inline: "cd /vagrant && bundle install"

end
