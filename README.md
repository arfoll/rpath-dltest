# LD_LIBRARY_PATH / rpath example

copy lib5.so to a default dir like /usr/local/lib dir which is in the loader's
loadable lib path (check ld.so.conf and ld.so.conf.d/) and rerun ldconfig so
you wipe the ld.so.cache. This is to prove that we're not loading local or
system lib5.so

You will need chrpath binary to change the rpath.

