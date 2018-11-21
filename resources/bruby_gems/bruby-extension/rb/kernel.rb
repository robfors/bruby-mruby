module Kernel

  def global_variable_defined?(variable_name)
    raise ArgumentError, "'variable_name' must respond to #to_s" unless variable_name.respond_to?(:to_s)
    variable_name = variable_name.to_s
    # TODO: investigate error
    # strange error: TypeError: can't convert Symbol into Proc
    # when using .map(&:to_s)
    #global_variables.map(&:to_s).include?("$#{variable_name}")
    global_variables.map{|name| name.to_s }.include?("$#{variable_name}")
  end
  
  def global_variable_get(variable_name)
    raise ArgumentError, "'variable_name' must respond to #to_s" unless variable_name.respond_to?(:to_s)
    variable_name = variable_name.to_s
    unless global_variable_defined?(variable_name)
      raise NameError, "global variable '#{variable_name}'is not defined"
    end
    eval("$#{variable_name}")
  end
  
  def global_variable_set(variable_name, new_value)
    raise ArgumentError, "'variable_name' must respond to #to_s" unless variable_name.respond_to?(:to_s)
    variable_name = variable_name.to_s
    eval("$#{variable_name} = new_value")
  end
  
end
