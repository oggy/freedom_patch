Module.class_eval do
  def freedom_patch(mod)
    FreedomPatch.apply(mod, self)
  end
end
