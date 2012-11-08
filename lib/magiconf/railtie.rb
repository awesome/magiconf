module Magiconf
  class Railtie < ::Rails::Railtie
    initializer 'magiconf.initialize', before: 'load_environment_config' do |app|
      namespace = app.class.parent_name.constantize
      Magiconf.setup! unless namespace.const_defined?('Config')
    end
  end
end
