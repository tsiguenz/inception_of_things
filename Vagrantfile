Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.synced_folder "./", "/home/vagrant/iot"
  server.vm.hostname = "host-iot"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "8184"
    vb.cpus = 12
    vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get upgrade
    apt-get install -y curl git vim virtualbox vagrant
    addgroup vagrant vboxusers
  SHELL

end
