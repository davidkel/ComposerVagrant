# Fabric Composer Vagrant Boxes
Vagrant, VirtualBox are required
also you need to install vagrant-triggers plugin

These are work in progress, so for example you cannot have 2 up at the
same time as there could be port clashes or clashes with shared folders.

Descriptions of the directories

## FabricDevServer
Adds a fabric 1.1 development server packaged as a vagrant setup. Mainly useful for windows but could be used on Mac as well (if you don't want to install the smoke and mirrors docker environment) and no benefit for linux of course.

## Dev
A development environment using trusty64. This shares a subdirectory called 'src' on
the host with the vm and exposes a set of ports
- Mac & Linux hosts require nfs server (already available on Mac)
- Windows not supporte yet

## DevXenial
A development environment using xenial64. This shares a subdirectory called 'src' on
the host with the vm and exposes a set of ports
- Mac & Linux hosts require the plugin vagrant-nfs_guest
- Windows exposes a share on \\192.168.40.2\src (userid=ubuntu, password=ubuntu)

## Test
A test environment where no directory is shared with the host, more suitable for system testing. This one is based on trusty

## TestXenial
A test environment where no directory is shared with the host, more suitable for system testing. This one is based on xenial
