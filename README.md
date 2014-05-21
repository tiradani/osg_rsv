# History
Within the Open Science Grid (OSG) there is growing interest and support for
using Puppet to configure grid nodes and software.  The OSG software group
has created a new github hosted repository [1] to house shared modules.

[1] https://github.com/opensciencegrid/puppet-contrib

# Why?

OSG provides the Resource and Service Validation (RSV) service to be run at
a site to test and validate the grid services provided by the site.  RSV can
be installed and run in parallel with a grid Compute Element (CE) or as a 
stand alone service.  This module will install RSV as a stand alone service.
The idea is that larger sites may have more than one CE to monitor.  RSV is
"required" for OSG sites.

# Notes

## Dependencies
This module depends on the puppet stdlib module.

## Certificates
There is one circular dependency in the install procedure.  If you use service
certificates to submit jobs, then the certificates must exist and be owned by
the proper user before the service configuration can occur.  This module does
not address the issue of how the certificates get placed on the node.  This 
module instead checks for the existence of the certificate files before running
the configuration scripts, enabling, and starting the service.

## YUM repositories
This module does not ensure that the appropriate YUM repositories are 
installed.  That is outside the scope of this module.

This module depends on the osg and the osg-contrib (optional) yum repositories.
The osg-contrib repository is only required if the RSV Zabbix Consumer is to be
installed.

## Web server
This module does not attempt to set any firewall rules or install/enable any web
servers.

See https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallRSV for
further details.

# License Apache Software License 2.0
