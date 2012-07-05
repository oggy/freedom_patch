## Freedom Patch

Monkeypatch without aliasing methods. *Ever.*

## Wait, what?

Suppose you have some 3rd party code:

    class VendorLib
      def foo
        10
      end
    end

And you want to add 1 to what `foo` returns.

It'd be great if you could just "super and add 1":

    module Hack
      def foo
        super + 1
      end
    end
    VendorLib.include(Hack)

But this won't work, because `VendorLib#foo` shadows `Hack#foo`.

Well, now you can.

    require 'freedom_patch'

    module Hack
      def foo
        super + 1
      end
    end

    VendorLib.freedom_patch(Hack)

FREEDOM!

## Install

    gem install freedom_patch

## My Namespace!

Don't want to pollute `Module` with the `freedom_patch`?

Do `require 'freedom_patch/clean'` instead of `require 'freedom_patch'`, and
patch your way to independence thusly:

    FreedomPatch.apply(Hack, VendorLib)

## Performance

It's shit.

    $ ruby [benchmark.rb][benchmark]
    ruby 1.9.3p194 (2012-04-20 revision 35410) [x86_64-darwin11.3.0]
                         user     system      total        real
    with freedom_patch   2.720000   0.020000   2.740000 (  2.741546)
    aliasing             1.010000   0.030000   1.040000 (  1.043165)

But hey, it was fun. :)

[benchmark][https://github.com/oggy/freedom_patch/blob/master/benchmark.rb]

## Note on Patches/Pull Requests

 * Bug reports: http://github.com/oggy/freedom_patch/issues
 * Source: http://github.com/oggy/freedom_patch
 * Patches: Fork on Github, send pull request.
   * Ensure patch includes tests.
   * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) George Ogata. See LICENSE for details.
