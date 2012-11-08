module Magiconf
  class Railtie < ::Rails::Railtie
    initializer 'magiconf.initialize', before: 'load_environment_config' do |app|
      Magiconf.setup! unless Magiconf.setup?
    end
  end
end
