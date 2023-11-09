Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "./", "/home/vagrant/iot"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    # Customize the amount of memory on the VM:
    vb.memory = "8184"
    # Enable nested virtualization
    vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
  end

  config.vm.provision :shell, :inline => "sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime", run: "always"
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get upgrade
    apt-get install -y  zsh curl git vagrant vim 
    chsh -s /bin/zsh vagrant
    su vagrant -c 'sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
  SHELL

#     qemu libvirt-daemon-system \
#                        libvirt-clients libxslt-dev libxml2-dev libvirt-dev \
#                        zlib1g-dev ruby-dev ruby-libvirt ebtables dnsmasq-base
#     vagrant plugin install vagrant-libvirt
#     vagrant plugin install vagrant-mutate
#     usermod --append --groups libvirt vagrant

end
