require_relative '../test_helper'

describe Module do
  describe ".freedom_patch" do
    it "freedom patches the module with the given patch module" do
      klass = Class.new { def f; 10; end }
      patch = Module.new { def f; super + 1; end }
      klass.freedom_patch(patch)
      klass.new.f.must_equal 11
    end
  end
end
