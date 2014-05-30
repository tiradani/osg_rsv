# rsv
#
# Install and configure the Open Science Grid (OSG)  Resource and Service
# Validation (RSV) service as a stand alone service.  It optionally will
# install and configure the Zabbix consumer
#
#  RSV uses a web server to show the local status of the RSV probes.  The
#  proper firewall setting need to be implemented.  The web server of choice
#  needs to be installed and configured.  This module includes a manifest for
#  configuring httpd and the firewall.  It uses the puppetlabs-apache and the
#  puppetlabs-firewall modules.
#
# == Prerequisites
#
#  The rsv package will create an rsv user and a cndrcron user if not already
#  defined.  If you want common uids and gids then define these prior to
#  installing RSV.
#
#  If a service certificate will be used to submit the RSV probe jobs to a CE,
#  then the certificate and key files must be already present and owned by the
#  rsv user before osg-configure can be run.
#
# == Parameters
#
#  rsv_enabled            The enable option indicates whether RSV should be
#                         enabled or disabled.  It should be set to True,
#                         False, or Ignore.
#
#                         If you are using rsv-control to enable or disable
#                         specific metrics, you should set this to Ignore so
#                         that your configuration does not get overwritten
#                         each time that configure-osg is run.
#
#  enable_gratia          This option will enable RSV record uploading to the
#                         central RSV collector at the GOC.  This is required
#                         for WLCG availability reporting.
#
#  gratia_collector       This option will set the gratia_collector you will
#                         report to.  Leave this option commented out to use
#                         the default Gratia collector.  If you want to report
#                         to a different collector instead of the default OSG
#                         collector then supply the hostname:port here.
#
#                         Note: this must be of the form hostname:port
#
#  service_cert           This should point to the public key file (pem) for
#                         your service certificate.
#
#  service_key            This should point to the private key file (pem) for
#                         your service certificate.
#
#  service_proxy          This should point to the location of the RSV proxy
#                         file.
#
#  legacy_proxy           If you want to create a legacy Globus proxy using
#                         'grid-proxy-init -old' then set this to True
#
#  user_proxy             If you don't use a service certificate for RSV, you
#                         will need to specify a proxy file that RSV should
#                         use in the user_proxy setting.  If you use this
#                         option you need to renew this proxy file periodically
#
#  ce_hosts               The ce_hosts options lists the FQDN of the CEs that
#                         the RSV CE metrics should run against.  This is a
#                         list of FQDNs separated by a comma
#                         for example:
#                         ce_hosts = 'ce.example.com, ce2.example.com'
#
#  gridftp_hosts          The gridftp_hosts options lists the FQDN of the
#                         gridftp servers that the RSV GridFTP metrics should
#                         monitor.  This is be a list of FQDNs separated by a
#                         comma
#                         for example:
#                         gridftp_hosts = 'gridftp.example.com, gridftp2.example.com'
#
#  gridftp_dir            The gridftp_dir option gives the directory on the
#                         gridftp servers that the RSV GridFTP probes should
#                         try to write and read from.
#
#  gratia_probes          This setting specifies which type of Gratia probes
#                         RSV should monitor.  Set this to DEFAULT to disable
#                         Gratia monitoring.  Otherwise, list the Gratia
#                         types you wish to monitor separated by commas.  Valid
#                         metrics are:
#                           metric, condor, pbs, lsf, sge, hadoop-transfer,
#                           gridftp-transfer
#
#                         If you are monitoring multiple CEs with different
#                         Gratia metrics you can put them into lists using
#                         parentheses.  Each parenthesized entry corresponds to
#                         the same entry in the ce_hosts option.  For example,
#                         here is the syntax for monitoring 3 CEs:
#                           gratia_probes = '(condor, metric), (pbs, condor), (condor)'
#
#                         Note: if you have multiple CEs but only one entry
#                         then that entry will be used for each CE.  Otherwise,
#                         the number of CE hosts must match the number of
#                         Gratia entries.
#
#                         If you are monitoring a CE, you want to add the batch
#                         system used by that CE.
#                         If you are monitoring a CE using RSV, add the
#                         'metric' type
#                         If you are monitoring a CE using managed-fork, add
#                         'condor'
#
#                         For example, on a CE using PBS and Managed-Fork, you
#                         will probably use:
#                           gratia_probes = 'metric, pbs, condor'
#
#  gums_hosts             The gums_hosts options lists the FQDN of the GUMS
#                         server that the RSV GUMS metrics should monitor.
#                         This should be a list of FQDNs separated by a comma:
#                           gums_hosts = 'gums.example.com, gums2.example.com'
#
#  srm_hosts              The srm_hosts options lists the FQDN of the SRM
#                         servers that the RSV SRM metrics should monitor. This
#                         should be a list of FQDNs separated by a comma.
#                         You can specify the port on a host using host:port.
#                         For example:
#                           srm_hosts = 'srm.example.com:8443, srm2.example.com:8443'
#
#  srm_dir                The srm_dir options gives the directory on the srm
#                         servers that the RSV SRM probes should try to write
#                         and read from.  This should be a comma separated list
#                         containing the same number of entries as srm_hosts
#                         (the first entry in srm_hosts corresponds to the first
#                         entry in srm_dir, etc)
#
#  srm_webservice_path    This option gives the webservice path that SRM metrics
#                         need along with the host: port. For dcache
#                         installations this should be set to srm/managerv2
#                         However Bestman-Xrootd SEs normally use srm/v2/server
#                         as the web service path, and so Bestman-Xrootd admins
#                         will have to pass this option with the appropriate
#                         value (for example: "srm/v2/server") for the SRM
#                         metrics to work on their SE.
#
#                         This is optional.  If it is set it should be a comma
#                         separated list containing the same number of entries
#                         as srm_hosts (the first entry in srm_hosts
#                         corresponds to the first entry in
#                         srm_webservice_path, etc)
#
#  enable_local_probes    enable_local_probes will enable metrics to run
#                         against the local host that RSV is running on.
#                         Currently there are local probes to monitor the
#                         validity of the hostcert and httpcert.
#
#  condor_location        RSV relies on Condor to run, and it assumes that it
#                         can find the condor binaries in the default PATH.  If
#                         you installed Condor into a non-standard location
#                         (such as installing the tarball into /opt/condor)
#                         then specify the location here.
#
#                         Note: if you did not manually install Condor - or if
#                         you installed the Condor RPM that puts Condor into
#                         FHS locations then you do not need to set this value.
#
#  enable_nagios          The enable_nagios option indicates whether RSV will
#                         report information to a local nagios instance.
#
#  nagios_send_nsca       The nagios_send_nsca option chooses which script to
#                         use to send nagios records.  If this is true then
#                         rsv2nsca.py will be used.  If this is false then
#                         rsv2nagios.py will be used.  The default is
#                         rsv2nagios.py.  This value is optional.
#
#  enable_zabbix_plugin   The enable_zabbix_plugin option indicates whether RSV
#                         will report information to a local Zabbix instance.
#
#  zabbix_short_hostname  The short hostname of the Zabbix server
#
#  zabbix_long_hostname   The fully qualified domain name of the Zabbix server
#
#  zabbix_trapper_port    The port used by the Zabbix trapper to communicate
#                         with the server
#
#  zabbix_extra_args      Any extra arguments to pass to the Zabbix plugin.
#                         For example:
#                           Add `--zabbix-sender` to use zabbix_sender for
#                           sending metrics
#
# == Usage
#
#  If using Hiera to provide values, it is enought to:
#    include rsv
#
#  Otherwise:
#    class { 'rsv':
#      service_cert => '/etc/grid-security/rsv/rsvcert.pem',
#      service_key  => '/etc/grid-security/rsv/rsvkey.pem',
#    }
#
# == Notes
#
#  The rsv-consumers-zabbix package is in the osg-contrib yum repository.
#
class osg_rsv (
  # Main RSV configuration
  $rsv_enabled            = 'True',
  $enable_gratia          = 'True',
  $gratia_collector       = undef,
  $service_cert           = 'DEFAULT',
  $service_key            = 'DEFAULT',
  $service_proxy          = 'DEFAULT',
  $legacy_proxy           = 'False',
  $user_proxy             = 'DEFAULT',
  $ce_hosts               = 'UNAVAILABLE',
  $gridftp_hosts          = 'UNAVAILABLE',
  $gridftp_dir            = 'DEFAULT',
  $gratia_probes          = 'DEFAULT',
  $gums_hosts             = 'UNAVAILABLE',
  $srm_hosts              = 'UNAVAILABLE',
  $srm_dir                = 'DEFAULT',
  $srm_webservice_path    = 'DEFAULT',
  $enable_local_probes    = 'True',
  $condor_location        = 'UNAVAILABLE',

  # Nagios plugin configuration
  # This plugin is fully integrated with RSV
  $enable_nagios          = 'False',
  $nagios_send_nsca       = 'False',

  # Zabbix plugin configuration
  # This plugin is not integrated with RSV, so it must explicitly be enabled
  # and configured separately
  $enable_zabbix_plugin   = false,
  $zabbix_short_hostname  = undef,
  $zabbix_long_hostname   = undef,
  $zabbix_trapper_port    = undef,
  $zabbix_extra_args      = '',
) {
  package { 'rsv':
    ensure => present,
  }

  file { '/etc/osg/config.d/30-rsv.ini':
    content => template('osg_rsv/30-rsv.ini.erb'),
  }

  if str2bool($enable_zabbix_plugin) {
    package { 'rsv-consumers-zabbix':
      ensure  => present,
      require => Package['rsv'],
    }

    file { '/etc/rsv/rsv-zabbix.conf':
      content => template('osg_rsv/rsv-zabbix.conf.erb'),
      require => Package['rsv-consumers-zabbix'],
    }

    file { '/etc/rsv/consumers/zabbix-consumer.conf':
      content => template('osg_rsv/zabbix-consumer.conf.erb'),
      require => Package['rsv-consumers-zabbix'],
    }

    # enable the zabbix consumer and notify the rsv service so that it will
    # restart and actually start the consumer as well
    exec { 'enable_zabbix_consumer':
      command     => 'rsv-control --enable zabbix-consumer',
      require     => Package['rsv-consumers-zabbix'],
      subscribe   => [ File['/etc/rsv/rsv-zabbix.conf'],
                       File['/etc/rsv/consumers/zabbix-consumer.conf'],
                     ],
      refreshonly => true,
      notify      => Service['rsv'],
    }
  }

  # Reconfigure RSV whenever the ini file changes, also, notify the service
  # to be restarted
  exec { 'configure_rsv':
    command     => '/usr/sbin/osg-configure -c',
    subscribe   => File['/etc/osg/config.d/30-rsv.ini'],
    refreshonly => true,
    notify      => Service['rsv'],
    onlyif      => ["/usr/bin/test -f ${service_cert}", "/usr/bin/test -f ${service_key}"],
  }

  service { 'condor-cron':
    ensure => running,
    enable => true,
  }

  service { 'rsv':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    status    => 'test -f /var/lock/subsys/rsv',
  }
}
