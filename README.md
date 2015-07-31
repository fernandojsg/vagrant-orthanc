Vagrant Orthanc
---
**[Vagrant](https://www.vagrantup.com/)** box setup for **[Orthanc](http://www.orthanc-server.com/)** DICOM server including its official plugins and using [puppet](https://puppetlabs.com/) provisioning.

This repository is based on the scripts from [OrthancDocker](https://github.com/jodogne/OrthancDocker) repository by [Sébastien Jodogne](https://github.com/jodogne) and [orthanc-vagrant](https://github.com/chafey/orthanc-vagrant) by [Chris Hafey](https://github.com/chafey).

## Features

- **Ubuntu 14.04** (Trusty) Server
- Builds [Orthanc](http://www.orthanc-server.com/) **Lastest** (dynamically linked)
- Builds [Orthanc DICOMWeb](https://bitbucket.org/sjodogne/orthanc-dicomweb/overview) **Lastest** plugin and loads it (dynamically linked)
- Builds [Orthanc WebViewer](https://code.google.com/p/orthanc-webviewer/) **Lastest** plugin and loads it (dynamically linked)
- Builds [Orthanc Postgresql](https://bitbucket.org/sjodogne/orthanc-postgresql) **Lastest** plugin and loads it (dynamically linked)
- Install **PostgreSQL** and creates **orthanc** database.
- Install **nginx** and use it as a reverse proxy to allow (HTTP Proxy with [CORS](http://http://enable-cors.org/) requests.
- Sets a fixed host-only IP at **192.168.33.10**
- Forwards Orthanc ports **4242** (DICOM), **8042** (HTTP) and **8043** (HTTP Proxy with [CORS](http://http://enable-cors.org/) enabled)
- Sets up disk compression
- Sets up Orthanc as a service with upstart

## Installation

* Download and install **[VirtualBox](https://www.virtualbox.org/wiki/Downloads)**
* Download and install **[Vagrant](http://www.vagrantup.com/downloads.html)**
* Clone the project into your preferred directory (Please note the `--recursive` to clone the puppet submodules): `git clone --recursive git@github.com:fernandojsg/vagrant-orthanc.git` 
* Setup the vagrant box: `vagrant up`
* Once the VM has been created you will be able to use the Orthanc services. 
* Additionally you can connect to the server using ssh: `vagrant ssh`

## Orthanc services

Orthanc app explorer:

- [http://localhost:8042](http://localhost:8042)

DICOMWeb RESTful interfaces:

- [http://localhost:8042/dicom-web](http://localhost:8042/dicom-web)

Examples:

- [http://localhost:8042/dicom-web/studies/[STUDYUID]/metadata](http://localhost:8042/dicom-web/studies/[STUDYUID]/metadata)

## Adding images to Orthanc
You can upload DICOM P10 to Orthanc using the following web interface:

[http://localhost:8042/app/explorer.html#upload](http://localhost:8042/app/explorer.html#upload)

Or you can push DICOM to it:

- IP Address: `192.168.33.10`
- Port: `4242`
- Called AE Title: `ORTHANC`

## Accessing the server

You can access the server with two methods:

* From the vagrant box directory by using: `vagrant ssh` 
* Using ssh with the private IP: `ssh vagrant@192.168.33.10` (Password: `vagrant`)

Orthanc service operations:

`service orthanc (start|stop|restart|status)`

Monitor Orthanc log files:

`tail -f /var/log/upstart/orthanc.log`

PostgreSQL configuration:

* port: `5432`
* allow remote connections: `yes (password)`
* database: `orthanc`
* user: `pgorthancuser`
* password: `pgorthancpass`
* admin password: `pgpassword`

## License

MIT License
