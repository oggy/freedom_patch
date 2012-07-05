module FreedomPatch
  autoload :VERSION, 'freedom_patch/version'

  def self.apply(patch, base)
    base_methods = base.instance_methods(false)
    patch_methods = patch.instance_methods(false)
    hacked_methods = patch_methods & base_methods

    if !hacked_methods.empty?
      mixin = Module.new
      hacked_methods.each do |name|
        method = base.instance_method(name)
        base.__send__ :remove_method, name
        mixin.__send__ :define_method, name do |*args, &block|
          method.bind(self).call(*args, &block)
        end
      end
      base.__send__ :include, mixin
    end

    base.__send__ :include, patch
  end
end
