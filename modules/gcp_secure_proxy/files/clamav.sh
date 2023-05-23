#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install clamav
apt-get install -y clamav clamav-daemon libclamav-dev g++ make pkg-config

# from now on every error is fatal
set -e

# download the sources
wget https://www.e-cap.org/archive/ecap_clamav_adapter-2.0.0.tar.gz

# unpack
tar -xvzf ecap_clamav_adapter-2.0.0.tar.gz

cat << 'EOF' > ClamAv.cc.patch
--- ClamAv.cc	2015-11-08 13:07:35.000000000 -0500
+++ ClamAv.cc.new	2019-07-29 08:34:21.000000000 -0400
@@ -44,8 +44,13 @@
     // We assume that cl_*() functions used here are threadsafe.

     const char *virname = 0;
-    const int eScanResult = cl_scanfile(answer.fileName.c_str(), &virname, 0, engine, CL_SCAN_STDOPT);

+    static struct cl_scan_options options = {};
+    {
+        options.parse |= ~0; // enable all parsers
+    }
+    const int eScanResult = cl_scanfile(answer.fileName.c_str(), &virname, 0, engine, &options);
+
     switch (eScanResult) {
     case CL_CLEAN:
         answer.statusCode = Answer::scClean;
EOF

# patch the CL_SCAN_STDOPT error
patch ecap_clamav_adapter-2.0.0/src/ClamAv.cc < ClamAv.cc.patch

# change into working dir
pushd ecap_clamav_adapter-2.0.0

# build
./configure && make && make install

# revert back
popd