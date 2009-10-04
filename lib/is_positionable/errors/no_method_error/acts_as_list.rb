module IsPositionable
  module Errors
    module NoMethodError
      class ActsAsList
        def initialize
          raise <<-MSG
The Acts As List Gem / Plugin has not been installed!

To install the gem:
sudo gem install acts_as_list

To install the plugin:
./script/plugin install git://github.com/rails/acts_as_list.git


Although this is not "required", I do recommend you (if using the GEM version)
to add the following line inside of your config/environment.rb file:
config.gem "acts_as_list"
          MSG
        end
      end
    end
  end
end