module Transit
  ##
  # ActiveSupport.on_load implementation.
  # Allows for attaching callbacks to models when events occur such as 
  # a definition assignment or plugin usage. Usage is exactly like the 
  # ActiveSupport implementation where each block is executed within a particular scope.
  # In this case that scope is within the model adding/implementing the functionality.
  #
  # @example Adding functionality when a definition is applied to a model
  # 
  #   Transit.on_definition(:post) do
  #     # your functionality here
  #   end 
  #  
  #

  @definition_hooks = Hash.new {|h,k| h[k] = [] }
  @defined = {}

  def self.on_definition(name, options = {}, &block)
    if base = @defined[name]
      execute_hook(base, options, block)
    else
      @definition_hooks[name] << [block, options]
    end
  end
  
  def self.execute_hook(base, options, block)
    if options[:yield]
      block.call(base)
    else
      base.instance_eval(&block)
    end
  end

  def self.run_definition_hooks(name, base = Object)
    @defined[name] = base
    @definition_hooks[name].each do |hook, options|
      execute_hook(base, options, hook)
    end
  end

end