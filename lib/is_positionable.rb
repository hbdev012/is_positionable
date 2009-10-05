require 'is_positionable/base'
require 'is_positionable/interface'
require 'is_positionable/errors/no_method_error/acts_as_list'

module IsPositionable
 
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    
    # Is Positionable
    def is_positionable(options = {})
      
      # Initialize the interface builer class
      # Passes in the options hash and the controller_name and builds the methods for it
      # Interface will convert ugly multi-dot-syntax to a single object.method wrapper
      interface = IsPositionable::Interface.new(options, controller_name).build

      # ControllerAction
      
      # Requires the acts_as_list gem
      # Ignores "MissingSourceFile" error so that a "nice" error message can be
      # displayed in the browser.
      interface.require_gem('acts_as_list')

      # Initializes Acts As List on the model
      # Will set up the column, the same that is used by Is Positionable
      # The Acts As List Gem will be provided with the same scope as the Is Positionable Gem uses
      # The default_scope will be set to always sort the items by the specified column (default = :position)
      interface.model.class_eval do
        
        # Initializes the Acts As List gem
        # Sets the :column to the specified column attribute, default => :position
        # Sets the :scope attribute to the specified attribute, default => '1 = 1' (like Acts As List)
        # Will display a helpful error when the Acts As List Gem has either not been installed or loaded
        begin
          acts_as_list  :column => interface.column,
                        :scope  => interface.scope || '1 = 1'
        rescue NoMethodError
          raise IsPositionable::Errors::NoMethodError::ActsAsList.new
        end
        
        # Sets the default scope to order by the specified column
        # default_scope :order => interface.column if interface.set_default_scope?
                
      end
      
      # Defines the action which will be used to move objects around
      define_method(interface.action_name) do
        
        # Finds the object that will be re-positioned    
        object = interface.find(params[:id])
        
        # Move Object Up 1 Position
        if params[interface.param].eql?('higher')
          object.move_higher
        end
        
        # Move Object Down 1 Position
        if params[interface.param].eql?('lower')
          object.move_lower
        end
        
        # Move Object To Top Of List
        if params[interface.param].eql?('to_top')
          object.move_to_top
        end
        
        # Move Object To Bottom Of List
        if params[interface.param].eql?('to_bottom')
          object.move_to_bottom
        end
        
        # Redirects if this is a simple HTML POST request
        # Will do nothing if this is an AJAX request
        respond_to do |format|
          format.html do
            
            # If the redirect path has not been set, it will default to :back.
            # If the default is set, but there is no "Referer", it will by default redirect
            # the user to the index action of the current controller.
            # If the :redirect_to attribute was manually set, this will be used.
            # If the :redirect_to attribute was set to :back, it will not change the default attribute
            if interface.redirect.eql?(:back)
              if request.headers["Referer"]
                redirect_to(interface.redirect)
              else
                redirect_to(:action => :index) 
              end
            else
              redirect_to(interface.redirect) 
            end
          end
          
          # If the positioning action was triggered by a AJAX call
          # then do nothing. Only optionally render the RJS file if present.
          format.js do
            # => Nothing
          end
        end
      end # => define_method(interface.action_name)
      
      
      
      # HelperMethods
    
      # Include the ActionView::Helpers inside of ActionController::Base
      # This will enable html button parsing
      ActionController::Base.send(:include, ActionView::Helpers)
    
      # Injects the "UP" button for the view helpers into the controller
      # This will be available to all views within the specified controller
      define_method "up_button_for_#{interface.controller_name}" do |objects, object, *options|
      
        # Set default options and overwrite the existing ones with
        # possible user input
        options = {
          :name             => "up",
          :attribute        => :id,
          :url              => {
            :controller     => interface.controller_name,
            :action         => interface.action_name,
            :id             => object,
            interface.param => "higher" },
          :html             => {
            :id             => "up_button_for_#{interface.controller_name.singularize}_#{object.id}",
            :class          => "up_button_for_#{interface.controller_name}" }
        }.update(options.empty? ? {} : options.first)
        
        button_to(options[:name], options[:url], options[:html]) unless objects.first.eql?(object)
      end
      
      # Injects the "DOWN" button for the view helpers into the controller
      # This will be available to all views within the specified controller
      define_method "down_button_for_#{interface.controller_name}" do |objects, object, *options|
      
        # Set default options and overwrite the existing ones with
        # possible user input
        options = {
          :name             => "down",
          :attribute        => :id,
          :url              => {
            :controller     => interface.controller_name,
            :action         => interface.action_name,
            :id             => object,
            interface.param => "lower" },
          :html             => {
            :id             => "down_button_for_#{interface.controller_name.singularize}_#{object.id}",
            :class          => "down_button_for_#{interface.controller_name}" }
        }.update(options.empty? ? {} : options.first)
        
        button_to(options[:name], options[:url], options[:html]) unless objects.last.eql?(object)
      end
    
      # Injects the "TOP" button for the view helpers into the controller
      # This will be available to all views within the specified controller
      define_method "top_button_for_#{interface.controller_name}" do |objects, object, *options|
      
        # Set default options and overwrite the existing ones with
        # possible user input
        options = {
          :name             => "top",
          :attribute        => :id,
          :url              => {
            :controller     => interface.controller_name,
            :action         => interface.action_name,
            :id             => object,
            interface.param => "to_top" },
          :html             => {
            :id             => "top_button_for_#{interface.controller_name.singularize}_#{object.id}",
            :class          => "top_button_for_#{interface.controller_name}" }
        }.update(options.empty? ? {} : options.first)
      
        button_to(options[:name], options[:url], options[:html]) unless objects.first.eql?(object)
      end
           
      # Injects the "BOTTOM" button for the view helpers into the controller
      # This will be available to all views within the specified controller
      define_method "bottom_button_for_#{interface.controller_name}" do |objects, object, *options|
      
        # Set default options and overwrite the existing ones with
        # possible user input
        options = {
          :name             => "bottom",
          :attribute        => :id,
          :url              => {
            :controller     => interface.controller_name,
            :action         => interface.action_name,
            :id             => object,
            interface.param => "to_bottom" },
          :html             => {
            :id             => "bottom_button_for_#{interface.controller_name.singularize}_#{object.id}",
            :class          => "bottom_button_for_#{interface.controller_name}" }
        }.update(options.empty? ? {} : options.first)

        button_to(options[:name], options[:url], options[:html]) unless objects.last.eql?(object)
      end
      
      # Makes the buttons available to the views that belong to the
      # controller that Is Positional was invoked from
      helper_method "up_button_for_#{interface.controller_name}",
                    "down_button_for_#{interface.controller_name}",
                    "top_button_for_#{interface.controller_name}",
                    "bottom_button_for_#{interface.controller_name}"
    end
  end
end

ActionController::Base.send(:include, IsPositionable)