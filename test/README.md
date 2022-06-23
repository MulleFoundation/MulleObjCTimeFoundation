# Run tests

Use `mulle-sde test` or `mulle-test test` to run the tests. Each test is
specified by a file with file extensions `.m` or `.aam`. This file
is compiled and linked with **MulleObjCTimeFoundation**.

Extension    | Description
-------------|-------------------------
`.m`, `.aam` | Test source
`.stdin`     | Command standard input
`.stdout`    | Expected command standard output


There are quite a few more options to tweak each test. 
See [mulle-test](//github.com/mulle-sde/mulle-test) for more info.


<!--
extension : mulle-sde/objc-test-library-demo
directory : demo/all
template  : .../README.md
Suppress this comment with `export MULLE_SDE_GENERATE_FILE_COMMENTS=NO`
-->
