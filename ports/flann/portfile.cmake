# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
    REPO mariusmuja/flann
	REF  1.9.1
    SHA512 0da78bb14111013318160dd3dee1f93eb6ed077b18439fd6496017b62a8a6070cc859cfb3e08dad4c614e48d9dc1da5f7c4a21726ee45896d360506da074a6f7	
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/fix-install-flann.patch"           
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
     #PREFER_NINJA # Disable this option if project cannot be built with Ninja
     OPTIONS 	 
	-DBUILD_EXAMPLES=OFF
	-DBUILD_PYTHON_BINDINGS=OFF
	-DBUILD_MATLAB_BINDINGS=OFF
	-DBUILD_DOC=OFF
	
	 OPTIONS_RELEASE
    -DFLANN_LIB_INSTALL_DIR=${CURRENT_PACKAGES_DIR}/lib 	 
	
	 OPTIONS_DEBUG	 
	-DFLANN_LIB_INSTALL_DIR=${CURRENT_PACKAGES_DIR}/debug/lib	
	
)

vcpkg_install_cmake()

#clean
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
 
# Handle copyright
file(COPY ${SOURCE_PATH}/README.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/flann)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/flann/README.md ${CURRENT_PACKAGES_DIR}/share/flann/copyright)