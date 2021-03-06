require 'puppet/property/boolean'

Puppet::Type.newtype(:pulp_puppetrepo) do
  @doc = <<-EOT
    doc 
  EOT

  autorequire(:file) do
    [
      self[:conf_file],
      self[:feed_ca_cert],
      self[:feed_key],
      self[:feed_cert],
    ]
  end

  ensurable do
    desc <<-EOS
      Create/Remove pulp rpm repo.
    EOS

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc "repo-id: uniquely identifies the rpm repo"
  end

  newparam(:conf_file, :parent => Puppet::Parameter::Path) do
    desc "path to pulp-admin's config file. Defaults to /etc/pulp/admin/admin.conf"
    defaultto('/etc/pulp/admin/admin.conf')
  end

  newproperty(:display_name) do
    desc "user-readable display name (may contain i18n characters)"
    defaultto do
      @resource[:name]
    end
  end

  newproperty(:description) do
    desc "user-readable description (may contain i18n characters)"
  end

  newproperty(:note) do
    desc "adds/updates/deletes notes to programmatically identify the resource"
    validate do |value|
      raise ArgumentError, "Note property should be a hash" unless value.kind_of?(Hash)
    end
  end

  newproperty(:feed) do
    desc "URL of the external source repository to sync"
  end

  newproperty(:validate, :boolean => true, :parent => Puppet::Property::Boolean) do
    desc 'Whether the size and checksum of each synchronized file will
    be verified against the repo metadata'
    defaultto :false
  end

  newproperty(:feed_ca_cert) do
    desc "Full path to the CA certificate that should be used to
    verify the external repo server's SSL certificate"
  end

  newproperty(:verify_feed_ssl, :boolean => true, :parent => Puppet::Property::Boolean) do
    desc 'Whether the feed\'s SSL certificate will be verified against the feed_ca_cert'
    defaultto :false
  end

  newproperty(:feed_cert) do
    desc "full path to the certificate to use for authorization when
    accessing the external feed"
  end

  newproperty(:feed_key) do
    desc "full path to the private key for feed_cert"
  end

  newproperty(:proxy_host) do
    desc "proxy server url to use"
  end

  newproperty(:proxy_port) do
    desc "port on the proxy server to make requests"
    newvalues(/^\d+$/)
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:proxy_user) do
    desc "username used to authenticate with the proxy server"
  end

  newproperty(:proxy_pass) do
    desc "password used to authenticate with the proxy server"
  end

  newproperty(:max_downloads) do
    desc "maximum number of downloads that will run concurrently"
    newvalues(/^\d+$/)
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:max_speed) do
    desc "maximum bandwidth used per download thread, in bytes/sec,
    when synchronizing the repo"
    newvalues(/^\d+$/)
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:serve_http, :boolean => true, :parent => Puppet::Property::Boolean) do
    desc 'if "true", the repository will be served over HTTP'
    defaultto :false
  end

  newproperty(:serve_https, :boolean => true, :parent => Puppet::Property::Boolean) do
    desc 'if "true", the repository will be served over HTTPS'
    defaultto :true
  end

  # extra properties for puppet repos
  newproperty(:queries, :array_matching => :all) do
    desc "comma-separated list of queries to issue against the feed's
    modules.json file to scope which modules are imported.
    ignored when feed is static files."
  end

end
