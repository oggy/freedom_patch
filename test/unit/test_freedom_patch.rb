require_relative '../test_helper'

describe FreedomPatch do
  describe ".apply" do
    let(:patch) { Module.new { def f; super + 1; end } }

    describe "when applying a module to a class" do
      it "wires up the module's 'super' calls to invoke the corresponding instance methods in the class" do
        klass = Class.new { def f; 10; end }
        FreedomPatch.apply(patch, klass)
        klass.new.f.must_equal 11
      end

      it "works for methods that aren't defined by the class, but are defined in a superclass" do
        superclass = Class.new { def f; 10; end }
        klass = Class.new(superclass)
        FreedomPatch.apply(patch, klass)
        klass.new.f.must_equal 11
      end

      it "raises NoMethodError if 'super' is used when there is no supermethod" do
        klass = Class.new
        FreedomPatch.apply(patch, klass)
        ->{ klass.new.f }.must_raise(NoMethodError)
      end

      it "makes methods raise NoMethodError if they were undefined in the included class" do
        superclass = Class.new { def f; end }
        klass = Class.new(superclass) { undef_method :f }
        FreedomPatch.apply(patch, klass)
        ->{ klass.new.f }.must_raise(NoMethodError)
      end
    end

    describe "when applying a FreedomPatch to another module" do
      it "wires up the module's 'super' calls to invoke the corresponding instance methods in the included module" do
        mod = Module.new { def f; 10; end }
        FreedomPatch.apply(patch, mod)
        klass = Class.new { include mod }
        klass.new.f.must_equal 11
      end

      it "works for methods that aren't defined by the class, but are defined in a supermodule" do
        supermodule = Module.new { def f; 10; end }
        mod = Module.new { include supermodule }
        FreedomPatch.apply(patch, mod)
        klass = Class.new { include mod }
        klass.new.f.must_equal 11
      end

      it "raises NoMethodError if 'super' is used when there is no supermethod" do
        mod = Module.new
        FreedomPatch.apply(patch, mod)
        klass = Class.new { include mod }
        ->{ klass.new.f }.must_raise(NoMethodError)
      end

      it "works for undefined methods" do
        mod = Module.new { def f; end; undef_method :f }
        FreedomPatch.apply(patch, mod)
        klass = Class.new { include mod }
        ->{ klass.new.f }.must_raise(NoMethodError)
      end
    end

    describe "when applying a module to a singleton class" do
      it "wires up the module's 'super' calls to invoke the corresponding instance methods in the class" do
        object = Object.new
        def object.f; 10; end
        FreedomPatch.apply(patch, object.singleton_class)
        object.f.must_equal 11
      end

      it "works for methods that aren't defined in the singleton class, but are defined in the object's class" do
        klass = Class.new { def f; 10; end }
        object = klass.new
        FreedomPatch.apply(patch, object.singleton_class)
        object.f.must_equal 11
      end

      it "raises NoMethodError if 'super' is used when there is no supermethod" do
        object = Object.new
        FreedomPatch.apply(patch, object.singleton_class)
        ->{ object.f }.must_raise(NoMethodError)
      end

      it "makes methods raise NoMethodError if they were undefined in the singleton class" do
        object = Object.new
        def object.f; end
        object.singleton_class.send :undef_method, :f
        FreedomPatch.apply(patch, object.singleton_class)
        ->{ object.f }.must_raise(NoMethodError)
      end
    end
  end
end
