$:.unshift File.expand_path('lib', File.dirname(__FILE__))

require 'benchmark'
require 'freedom_patch'

class WithFreedomPatch
  def add(a,b,&c)
    a + b + yield(c)
  end

  module Hack
    def add(a,b,&c)
      super + 1
    end
  end

  freedom_patch Hack
end

class Aliasing
  def add(a,b,&c)
    a + b + yield(c)
  end

  module Hack
    def add_with_hack(a,b,&c)
      add_without_hack(a,b,&c) + 1
    end
  end

  include Hack
  alias add_without_hack add
  alias add add_with_hack
end

with_freedom_patch = WithFreedomPatch.new
aliasing = Aliasing.new

N = ENV['N'] || 1_000_000

Benchmark.bm(18) do |bm|
  bm.report 'with freedom_patch' do
    N.times { with_freedom_patch.add(1,2){3} }
  end

  bm.report 'aliasing' do
    N.times { aliasing.add(1,2){3} }
  end
end
