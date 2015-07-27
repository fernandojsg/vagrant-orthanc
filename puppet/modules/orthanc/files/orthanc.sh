# Create the various directories as in the official Debian package
#mkdir /etc/orthanc
mkdir -p /var/lib/orthanc/db
mkdir -p /usr/share/orthanc/plugins

[ -d /root/orthanc/Build ] && rm /root/orthanc/Build -rf

mkdir /root/orthanc/Build
cd /root/orthanc/Build

# Install the Orthanc core and run the unit tests
cmake "-DDCMTK_LIBRARIES:PATH=boost_locale;CharLS;dcmjpls;wrap;oflog" \
    -DALLOW_DOWNLOADS:BOOL=ON \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DUSE_GTEST_DEBIAN_SOURCE_PACKAGE:BOOL=ON \
    -DUSE_SYSTEM_GOOGLE_LOG:BOOL=OFF \
    -DUSE_SYSTEM_JSONCPP:BOOL=OFF \
    -DUSE_SYSTEM_MONGOOSE:BOOL=OFF \
    -DUSE_SYSTEM_PUGIXML:BOOL=OFF \
    ..
make
make install