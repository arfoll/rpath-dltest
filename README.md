# LD_LIBRARY_PATH / rpath example

copy lib5.so to a default dir like /usr/local/lib dir which is in the loader's
loadable lib path (check ld.so.conf and ld.so.conf.d/) and rerun ldconfig so
you wipe the ld.so.cache. This is to prove that we're not loading local or
system lib5.so

You will need chrpath binary to change the rpath.

## Explanation

We use $ORIGIN in rpath to state that we should not use the $ORIGIN from the
executable but rather the $ORIGIN of the library itself. $ORIGIN is a bit of a
pain to write directly because of quoting so we reserve the space with XORIGIN
and then replace it with $ORIGIN using chrpath. Technically there are probably
ways to escape it nicely. I stole the hack from this nice blog:
https://enchildfone.wordpress.com/2010/03/23/a-description-of-rpath-origin-ld_library_path-and-portable-linux-binaries/

## Testing it
```
$ LD_TRACE_LOADED_OBJECTS=1 ./executable
        linux-vdso.so.1 (0x00007ffe3448c000)
        libnum.so => libnum/libnum.so (0x00007f1514740000)
        libc.so.6 => /usr/lib/libc.so.6 (0x00007f151439a000)
        lib5.so => /home/brendan/git/dltest/libnum/lib10/lib5.so (0x00007f1514198000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f1514942000)
```
```
$ readelf -d libnum/libnum.so           

Dynamic section at offset 0xe00 contains 26 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [lib5.so]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
 0x000000000000000f (RPATH)              Library rpath: [$ORIGIN/lib10/]
 0x000000000000000c (INIT)               0x500
 0x000000000000000d (FINI)               0x63c
 0x0000000000000019 (INIT_ARRAY)         0x200df0
 0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)
 0x000000000000001a (FINI_ARRAY)         0x200df8
 0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)
 0x000000006ffffef5 (GNU_HASH)           0x1f0
 0x0000000000000005 (STRTAB)             0x350
 0x0000000000000006 (SYMTAB)             0x230
 0x000000000000000a (STRSZ)              184 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000003 (PLTGOT)             0x201000
 0x0000000000000002 (PLTRELSZ)           24 (bytes)
 0x0000000000000014 (PLTREL)             RELA
 0x0000000000000017 (JMPREL)             0x4e8
 0x0000000000000007 (RELA)               0x440
 0x0000000000000008 (RELASZ)             168 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000006ffffffe (VERNEED)            0x420
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x408
 0x000000006ffffff9 (RELACOUNT)          3
 0x0000000000000000 (NULL)               0x0
```

```
$ readelf -d executable 

Dynamic section at offset 0xdd0 contains 28 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libnum.so]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
 0x000000000000000f (RPATH)              Library rpath: [libnum/]
 0x000000000000000c (INIT)               0x650
 0x000000000000000d (FINI)               0x864
 0x0000000000000019 (INIT_ARRAY)         0x200dc0
 0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)
 0x000000000000001a (FINI_ARRAY)         0x200dc8
 0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)
 0x000000006ffffef5 (GNU_HASH)           0x298
 0x0000000000000005 (STRTAB)             0x428
 0x0000000000000006 (SYMTAB)             0x2d8
 0x000000000000000a (STRSZ)              204 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000015 (DEBUG)              0x0
 0x0000000000000003 (PLTGOT)             0x201000
 0x0000000000000002 (PLTRELSZ)           48 (bytes)
 0x0000000000000014 (PLTREL)             RELA
 0x0000000000000017 (JMPREL)             0x620
 0x0000000000000007 (RELA)               0x530
 0x0000000000000008 (RELASZ)             240 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000006ffffffb (FLAGS_1)            Flags: PIE
 0x000000006ffffffe (VERNEED)            0x510
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x4f4
 0x000000006ffffff9 (RELACOUNT)          4
 0x0000000000000000 (NULL)               0x0
```
