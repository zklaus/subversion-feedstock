#!/usr/bin/env bash
set -ex

if [[ -v MACOSX_DEPLOYMENT_TARGET ]] ; then
    export CFLAGS="-isysroot ${CONDA_BUILD_SYSROOT} -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET} ${CFLAGS} -U__USE_XOPEN2K -std=c99"
else
    export CFLAGS="${CFLAGS} -U__USE_XOPEN2K -std=c99"
fi

./configure \
  --prefix="${PREFIX}" \
  --enable-svnxx \
  --enable-bdb6 \
  --with-sqlite="${PREFIX}" \
  --disable-static

make -j ${CPU_COUNT}
make -j ${CPU_COUNT} check CLEANUP=true TESTS=subversion/tests/cmdline/basic_tests.py
make install

make swig-pl
make check-swig-pl
make install-swig-pl
