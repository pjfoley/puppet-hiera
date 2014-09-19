module Puppet::Parser::Functions
  newfunction(:findeyamlcmdpath, :type => :rvalue, :doc => <<-EOS
              Returns the vin directory the hiera-eyaml eyaml executabe is located in
              EOS
             ) do |arguments|
               if not Gem::Specification.find_all_by_name("hiera-eyaml").empty?
                 spec = Gem::Specification.find_by_name("hiera-eyaml")
                 spec.gem_dir + "/bin"
               else
                 nil
               end
  end
end
