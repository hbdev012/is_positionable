module IsPositionable
  class Interface < IsPositionable::Base
    
    def initialize(options, controller_name)
      super({
        :column             => :position,
        :controller         => options[:controller] || controller_name,
        :model              => options[:controller] || controller_name,
        :action             => :positionable,
        :scope              => nil,
        :redirect_to        => :back,
        :param              => :move,
        :set_default_scope  => true
      }.update(options))
    end
    
    def build
      self
    end
    
    # Finds a single record by id
    # It will determine whether to use a plain find
    # or whether to use a find through an association
    def find(id)
      if scope.nil?
        model.find(id)
      else
        scope.send(model_association_name).find(id)
      end
    end
    
    # Finds the last id of a list of records
    # It will determine whether to use a plain find
    # or whether to use a find through an association
    def find_last_id
      if scope.nil?
        model.all.last.id 
      else
        scope.send(model_association_name).last.id
      end
    end
    
    # Returns the value of the :redirect_to attribute
    def redirect
      options[:redirect_to]
    end
    
    # Returns the value of the :scope attribute
    def scope
      options[:scope]
    end
    
    # Returns the model Class which can be invoked using class methods    
    def model
      Kernel.const_get(options[:model].singularize.camelize)
    end
    
    # Returns the controller Class which can be invoked using class methods
    def controller
      Kernel.const_get("#{controller_name.camelize.pluralize}Controller")
    end
    
    # Returns the action name of the :action attribute
    def action_name
      options[:action]
    end
    
    # Returns the model name of the :model attribute
    # The value will be singularize'd and camelize'd to
    # return the exact name as it is written inside a Ruby file
    def model_name
      options[:model].singularize.camelize
    end
    
    # Returns the model name in the form of an association
    # This is the model name, pluralize'd and underscore'd
    def model_association_name
      options[:model].pluralize.underscore
    end
    
    # Returns the controller name of the :controller attribute
    def controller_name
      options[:controller]
    end
    
    # Returns the param of the :param attribute
    def param
      options[:param]
    end
    
    # Returns the column of the :column attribute
    def column
      options[:column]
    end
    
    # Returns a boolean
    # Determines whether the :set_default_scope attribute was set
    def set_default_scope?
      true if options[:set_default_scope].eql?(true)
    end
    
    # Require additional gems
    # When the "ignore_error" argument is set to "true" (default)
    # an error will not be raised if the gem cannot be found
    def require_gem(gem, ignore_error = true)
      if ignore_error.eql?(true)
        begin
          require "#{gem}"
        rescue MissingSourceFile
        end
      else
        require "#{gem}"
      end
    end

  end
end