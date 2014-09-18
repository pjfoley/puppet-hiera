module Puppet::Parser::Functions
  newfunction(:findeyamlcmdpath, :type => :rvalue, :doc => <<-EOS
              Returns the vin directory the hiera-eyaml eyaml executabe is located in
              EOS
             ) do |arguments|
               spec = Gem::Specification.find_by_name("hiera-eyaml")
               spec.gem_dir + "/bin"
  end
end


