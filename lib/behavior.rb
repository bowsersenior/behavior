require 'active_support'
module Behavior
  def self.included(base)
    base.class_eval do
      def config
        Behavior::Base.new
      end      
      helper_method :config if respond_to?(:helper_method)
    end
  end
  
  class << self
    def config
      Behavior::Base.new
    end
  end
  
  class Base
    # from: http://avdi.org/devblog/2009/07/14/recursively-symbolize-keys/
    # this could be added to the Hash or OrderedHash class
    # but for a plugin it's better not to modify basic classes
    def symbolize_keys_recursively(hash)
      hash.inject(hash.class.new){|result, (key, value)|
        new_key = case key
                  when String then key.to_sym
                  else key
                  end
        new_value = case value
                    when (Hash or OrderedHash) then symbolize_keys_recursively(value)
                    else value
                    end
        result[new_key] = new_value
        result
      }
    end
    
    def meta
      @meta ||= begin
        yaml_hash = YAML.load_file(Behavior::Settings.config_file)

        # check if hash order needs to be maintained
        # TODO: need something like OrderedHashWithIndifferentAccess ?
        if yaml_hash.is_a? ActiveSupport::OrderedHash
          symbolize_keys_recursively( yaml_hash )
        else
          HashWithIndifferentAccess.new( yaml_hash )
        end
      end
    end
    
    def [](key)
      key = key.intern if key.is_a?(String)
      
      out = begin
        BehaviorConfig.find_by_key(key.to_s).value
      rescue NoMethodError
        meta[key][:default]
      end
      case meta[key][:type]
      when 'integer'
        out.to_i
      when 'decimal'
        BigDecimal.new(out.to_s)
      else
        out
      end
    end
    
    def all
      meta.keys
    end
    
    def update(attrs = {})
      attrs.each do |key,value|
        result = BehaviorConfig.find_or_create_by_key(key.to_s)
        result.update_attribute(:value, value) if result
      end
    end
  end
  
  class Settings
    class << self
      def config_file
        @config_file ||= "#{Rails.root}/config/behavior.yml"
      end
      
      def config_file=(file)
        @config_file = file
      end
      
      def layout
        @layout ||= 'admin'
      end
      
      def layout=(layout_choice)
        @layout = layout_choice
      end
      
      def before_filters
        @before_filters ||= []
      end
      
      def before_filters=(filters)
        @before_filters ||= filters
      end
    end
  end
end

ActionController::Base.send(:include, Behavior)