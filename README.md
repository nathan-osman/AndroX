## AndroX

AndroX provides a set of Makefiles for cross-compiling popular open-source
applications and libraries for the Android platform.

### Features

 - Downloads are verified using MD5 and stored in a local cache.
 - Compilation can be interrupted at nearly any point and resumed later.
 - Dependencies are handled correctly, ensuring that packages that depend on
   another package are built after the dependencies.

### Supported Applications / Libraries

The list of applications and libraries currently supported includes:

 - [OpenSSL](http://www.openssl.org/) - toolkit for SSL / TLS
 - [cURL](http://curl.haxx.se/) - multiprotocol file transfer utility
 - [libiconv](http://www.gnu.org/software/libiconv/) - character encoding
   conversion library
 - [Git](http://git-scm.com/) - distributed version control system

### Usage

You will first need to grab a copy of the
[Android NDK](http://developer.android.com/tools/sdk/ndk/index.html). Follow the
instructions in the `docs/STANDALONE-TOOLCHAIN.HTML` file to create a standalone
toolchain. Next, add the `bin/` directory of the standalone toolchain you
created to `$PATH`. Now you are all set!

If you are ambitious and wish to build all of the supported packages for
Android, then simply run:

    make

Be warned that the command above could take a very long time to complete since
all packages will be downloaded, extracted, configured, built, and installed. If
you are only interested in building a certain package, you can do so by running:

    make [package_name]

This will only build the specified package and its dependencies.

### Other Targets

The makefile also has a few other targets provided for convenience:

 - <strong>`make clean`</strong> and
   <strong>`make clean-[package_name]`</strong> - cleans any object and binary
   files built by all packages or the specified package respectively
 - <strong>`make purge-[package_name]`</strong> - purges the build directory for
   the specified package and removes any downloaded files
 - <strong>`make purge`</strong> - purges **all** downloads and object files
   from **all** packages **and** removes the installation directory - *use with
   care*