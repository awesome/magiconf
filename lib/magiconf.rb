module Magiconf
  extend self

  def setup!
    # Get the namespace and create the module
    namespace = Rails.application.class.parent_name.constantize
    nodule = namespace.const_set('Config', Module.new)

    # Open up the config file
    config = YAML::load( ERB.new( File.read('config/application.yml') ).result )
    config.merge!( config.fetch(Rails.env, {}) )
    config.symbolize_keys!

    config.keys.each do |key|
      nodule.define_singleton_method key do
        return config[key]
      end
    end
  end
end

require 'magiconf/railtie' if defined?(Rails)
