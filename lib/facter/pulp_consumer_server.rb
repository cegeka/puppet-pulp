# These facter facts return the value of the Puppet vardir and environment path
# settings for the node running puppet or puppet agent.  The intent is to
# enable Puppet modules to automatically have insight into a place where they
# can place variable data, or for modules running on the puppet server to know
# where environments are stored.
#
# The values should be directly usable in a File resource path attribute.
#
begin
  require 'facter/util/pulp'
rescue LoadError => e
  # puppet apply does not add module lib directories to the $LOAD_PATH (See
  # #4248). It should (in the future) but for the time being we need to be
  # defensive which is what this rescue block is doing.
  rb_file = File.join(File.dirname(__FILE__), 'util', 'pulp.rb')
  load rb_file if File.exist?(rb_file) || raise(e)
end

Facter.add(:pulp_consumer_server) do
  confine :kernel => 'Linux'
  setcode do
    Facter::Util::Pulp.pulp_consumer_server
  end
end
