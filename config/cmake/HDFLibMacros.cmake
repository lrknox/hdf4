#-------------------------------------------------------------------------------
macro (ORIGINAL_ZLIB_LIBRARY compress_type)
  if (${compress_type} MATCHES "GIT")
    FetchContent_Declare (ZLIB
        GIT_REPOSITORY ${ZLIB_URL}
        GIT_TAG ${ZLIB_BRANCH}
    )
  elseif (${compress_type} MATCHES "TGZ")
    FetchContent_Declare (ZLIB
        URL ${ZLIB_URL}
        URL_HASH ""
    )
  endif ()
  FetchContent_GetProperties(ZLIB)
  if(NOT zlib_POPULATED)
    FetchContent_Populate(ZLIB)

    # Copy an additional/replacement files into the populated source
    file(COPY ${HDF_RESOURCES_DIR}/ZLIB/CMakeLists.txt DESTINATION ${zlib_SOURCE_DIR})

    add_subdirectory(${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})
  endif()

  set (ZLIB_STATIC_LIBRARY "zlib-static")
  set (ZLIB_LIBRARIES ${ZLIB_STATIC_LIBRARY})

  set (ZLIB_INCLUDE_DIR_GEN "${zlib_BINARY_DIR}")
  set (ZLIB_INCLUDE_DIR "${zlib_SOURCE_DIR}")
  set (ZLIB_FOUND 1)
  set (ZLIB_INCLUDE_DIRS ${ZLIB_INCLUDE_DIR_GEN} ${ZLIB_INCLUDE_DIR})
endmacro ()

#-------------------------------------------------------------------------------
macro (ORIGINAL_JPEG_LIBRARY compress_type jpeg_pic)
  # May need to build JPEG with PIC on x64 machines with gcc
  # Need to use CMAKE_ANSI_CFLAGS define so that compiler test works

  if (${compress_type} MATCHES "GIT")
    FetchContent_Declare (JPEG
        GIT_REPOSITORY ${JPEG_URL}
        GIT_TAG ${JPEG_BRANCH}
    )
  elseif (${compress_type} MATCHES "TGZ")
    FetchContent_Declare (JPEG
        URL ${JPEG_URL}
        URL_HASH ""
    )
  endif ()
  FetchContent_GetProperties(JPEG)
  if(NOT jpeg_POPULATED)
    FetchContent_Populate(JPEG)

    # Copy an additional/replacement files into the populated source
    file(COPY ${HDF_RESOURCES_DIR}/JPEG/CMakeLists.txt DESTINATION ${jpeg_SOURCE_DIR})

    add_subdirectory(${jpeg_SOURCE_DIR} ${jpeg_BINARY_DIR})
  endif()

  set (JPEG_STATIC_LIBRARY "jpeg-static")
  set (JPEG_LIBRARIES ${JPEG_STATIC_LIBRARY})

  set (JPEG_INCLUDE_DIR_GEN "${jpeg_BINARY_DIR}")
  set (JPEG_INCLUDE_DIR "${jpeg_SOURCE_DIR}")
  set (JPEG_FOUND 1)
  set (JPEG_INCLUDE_DIRS ${JPEG_INCLUDE_DIR_GEN} ${JPEG_INCLUDE_DIR})
endmacro ()

#-------------------------------------------------------------------------------
macro (ORIGINAL_SZIP_LIBRARY compress_type encoding)
  # Only libaec library is usable
  if (${compress_type} MATCHES "GIT")
    FetchContent_Declare (SZIP
        GIT_REPOSITORY ${SZIP_URL}
        GIT_TAG ${SZIP_BRANCH}
    )
  elseif (${compress_type} MATCHES "TGZ")
    FetchContent_Declare (SZIP
        URL ${SZIP_URL}
        URL_HASH ""
    )
  endif ()
  FetchContent_GetProperties(SZIP)
  if(NOT szip_POPULATED)
    FetchContent_Populate(SZIP)

    # Copy an additional/replacement files into the populated source
    file(COPY ${HDF_RESOURCES_DIR}/LIBAEC/CMakeLists.txt DESTINATION ${szip_SOURCE_DIR})

    add_subdirectory(${szip_SOURCE_DIR} ${szip_BINARY_DIR})
  endif()

  set (USE_LIBAEC ON CACHE BOOL "Use libaec szip replacement" FORCE)
  set (SZIP_STATIC_LIBRARY "szaec-static;aec-static")
  set (SZIP_LIBRARIES ${SZIP_STATIC_LIBRARY})

  set (SZIP_INCLUDE_DIR_GEN "${BINARY_DIR}")
  set (SZIP_INCLUDE_DIR "${szip_SOURCE_DIR}/include")
  set (SZIP_FOUND 1)
  set (SZIP_INCLUDE_DIRS ${SZIP_INCLUDE_DIR_GEN} ${SZIP_INCLUDE_DIR})
endmacro ()

#-------------------------------------------------------------------------------
macro (EXTERNAL_JPEG_LIBRARY compress_type jpeg_pic)
  # May need to build JPEG with PIC on x64 machines with gcc
  # Need to use CMAKE_ANSI_CFLAGS define so that compiler test works

  if (${compress_type} MATCHES "GIT")
    EXTERNALPROJECT_ADD (JPEG
        GIT_REPOSITORY ${JPEG_URL}
        GIT_TAG ${JPEG_BRANCH}
        INSTALL_COMMAND ""
        CMAKE_ARGS
            -DBUILD_SHARED_LIBS:BOOL=OFF
            -DJPEG_PACKAGE_EXT:STRING=${HDF_PACKAGE_EXT}
            -DJPEG_EXTERNALLY_CONFIGURED:BOOL=OFF
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
            -DCMAKE_DEBUG_POSTFIX:STRING=${CMAKE_DEBUG_POSTFIX}
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
            -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
            -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
            -DCMAKE_PDB_OUTPUT_DIRECTORY:PATH=${CMAKE_PDB_OUTPUT_DIRECTORY}
            -DCMAKE_ANSI_CFLAGS:STRING=${jpeg_pic}
            -DHDF_USE_GNU_DIRS:STRING=${HDF4_USE_GNU_DIRS}
            -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
            -DCMAKE_TOOLCHAIN_FILE:STRING=${CMAKE_TOOLCHAIN_FILE}
            -DPACKAGE_NAMESPACE=${HDF_PACKAGE_NAMESPACE}
    )
  elseif (${compress_type} MATCHES "TGZ")
    EXTERNALPROJECT_ADD (JPEG
        URL ${JPEG_URL}
        URL_MD5 ""
        INSTALL_COMMAND ""
        CMAKE_ARGS
            -DBUILD_SHARED_LIBS:BOOL=OFF
            -DJPEG_PACKAGE_EXT:STRING=${HDF_PACKAGE_EXT}
            -DJPEG_EXTERNALLY_CONFIGURED:BOOL=OFF
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
            -DCMAKE_DEBUG_POSTFIX:STRING=${CMAKE_DEBUG_POSTFIX}
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
            -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
            -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
            -DCMAKE_PDB_OUTPUT_DIRECTORY:PATH=${CMAKE_PDB_OUTPUT_DIRECTORY}
            -DCMAKE_ANSI_CFLAGS:STRING=${jpeg_pic}
            -DHDF_USE_GNU_DIRS:STRING=${HDF4_USE_GNU_DIRS}
            -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
            -DCMAKE_TOOLCHAIN_FILE:STRING=${CMAKE_TOOLCHAIN_FILE}
            -DPACKAGE_NAMESPACE=${HDF_PACKAGE_NAMESPACE}
    )
  endif ()
  externalproject_get_property (JPEG BINARY_DIR SOURCE_DIR)

##include (${BINARY_DIR}/${JPEG_PACKAGE_NAME}${HDF_PACKAGE_EXT}-targets.cmake)
# Create imported target jpeg-static
  add_library(${HDF_PACKAGE_NAMESPACE}jpeg-static STATIC IMPORTED)
  HDF_IMPORT_SET_LIB_OPTIONS (${HDF_PACKAGE_NAMESPACE}jpeg-static "jpeg" STATIC "")
  add_dependencies (${HDF_PACKAGE_NAMESPACE}jpeg-static JPEG)
  set (JPEG_STATIC_LIBRARY "${HDF_PACKAGE_NAMESPACE}jpeg-static")
  set (JPEG_LIBRARIES ${JPEG_STATIC_LIBRARY})

  set (JPEG_INCLUDE_DIR_GEN "${BINARY_DIR}")
  set (JPEG_INCLUDE_DIR "${SOURCE_DIR}/src")
  set (JPEG_FOUND 1)
  set (JPEG_INCLUDE_DIRS ${JPEG_INCLUDE_DIR_GEN} ${JPEG_INCLUDE_DIR})
endmacro ()

#-------------------------------------------------------------------------------
macro (PACKAGE_JPEG_LIBRARY compress_type)
  add_custom_target (JPEG-GenHeader-Copy ALL
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${JPEG_INCLUDE_DIR_GEN}/jconfig.h ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
      COMMENT "Copying ${JPEG_INCLUDE_DIR_GEN}/jconfig.h to ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/"
  )
  set (EXTERNAL_HEADER_LIST ${EXTERNAL_HEADER_LIST} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/jconfig.h)
  if (${compress_type} MATCHES "GIT" OR ${compress_type} MATCHES "TGZ")
    add_dependencies (JPEG-GenHeader-Copy JPEG)
  endif ()
endmacro ()

#-------------------------------------------------------------------------------
macro (EXTERNAL_SZIP_LIBRARY compress_type encoding)
  if (${compress_type} MATCHES "GIT")
    EXTERNALPROJECT_ADD (SZIP
        GIT_REPOSITORY ${SZIP_URL}
        GIT_TAG ${SZIP_BRANCH}
        INSTALL_COMMAND ""
        CMAKE_ARGS
            -DBUILD_SHARED_LIBS:BOOL=OFF
            -DSZIP_PACKAGE_EXT:STRING=${HDF_PACKAGE_EXT}
            -DSZIP_EXTERNALLY_CONFIGURED:BOOL=OFF
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
            -DCMAKE_DEBUG_POSTFIX:STRING=${CMAKE_DEBUG_POSTFIX}
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
            -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
            -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
            -DCMAKE_PDB_OUTPUT_DIRECTORY:PATH=${CMAKE_PDB_OUTPUT_DIRECTORY}
            -DCMAKE_ANSI_CFLAGS:STRING=${CMAKE_ANSI_CFLAGS}
            -DSZIP_ENABLE_ENCODING:BOOL=${encoding}
            -DHDF_USE_GNU_DIRS:STRING=${HDF4_USE_GNU_DIRS}
            -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
            -DCMAKE_TOOLCHAIN_FILE:STRING=${CMAKE_TOOLCHAIN_FILE}
            -DPACKAGE_NAMESPACE=${HDF_PACKAGE_NAMESPACE}
    )
  elseif (${compress_type} MATCHES "TGZ")
    EXTERNALPROJECT_ADD (SZIP
        URL ${SZIP_URL}
        URL_MD5 ""
        INSTALL_COMMAND ""
        CMAKE_ARGS
            -DBUILD_SHARED_LIBS:BOOL=OFF
            -DSZIP_PACKAGE_EXT:STRING=${HDF_PACKAGE_EXT}
            -DSZIP_EXTERNALLY_CONFIGURED:BOOL=OFF
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
            -DCMAKE_DEBUG_POSTFIX:STRING=${CMAKE_DEBUG_POSTFIX}
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
            -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
            -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
            -DCMAKE_PDB_OUTPUT_DIRECTORY:PATH=${CMAKE_PDB_OUTPUT_DIRECTORY}
            -DCMAKE_ANSI_CFLAGS:STRING=${CMAKE_ANSI_CFLAGS}
            -DSZIP_ENABLE_ENCODING:BOOL=${encoding}
            -DHDF_USE_GNU_DIRS:STRING=${HDF4_USE_GNU_DIRS}
            -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
            -DCMAKE_TOOLCHAIN_FILE:STRING=${CMAKE_TOOLCHAIN_FILE}
            -DPACKAGE_NAMESPACE=${HDF_PACKAGE_NAMESPACE}
    )
  endif ()
  externalproject_get_property (SZIP BINARY_DIR SOURCE_DIR)
#
##include (${BINARY_DIR}/${SZIP_PACKAGE_NAME}${HDF_PACKAGE_EXT}-targets.cmake)
# Create imported target szip-static
  if (USE_LIBAEC)
    add_library(${HDF_PACKAGE_NAMESPACE}sz-static STATIC IMPORTED)
    HDF_IMPORT_SET_LIB_OPTIONS (${HDF_PACKAGE_NAMESPACE}sz-static "szaec" STATIC "")
    add_dependencies (${HDF_PACKAGE_NAMESPACE}sz-static SZIP)
    add_library(${HDF_PACKAGE_NAMESPACE}aec-static STATIC IMPORTED)
    HDF_IMPORT_SET_LIB_OPTIONS (${HDF_PACKAGE_NAMESPACE}aec-static "aec" STATIC "")
    add_dependencies (${HDF_PACKAGE_NAMESPACE}aec-static SZIP)
    set (SZIP_STATIC_LIBRARY "${HDF_PACKAGE_NAMESPACE}sz-static;${HDF_PACKAGE_NAMESPACE}aec-static")
  else ()
    add_library(${HDF_PACKAGE_NAMESPACE}szip-static STATIC IMPORTED)
    HDF_IMPORT_SET_LIB_OPTIONS (${HDF_PACKAGE_NAMESPACE}szip-static "szip" STATIC "")
    add_dependencies (${HDF_PACKAGE_NAMESPACE}szip-static SZIP)
    set (SZIP_STATIC_LIBRARY "${HDF_PACKAGE_NAMESPACE}szip-static")
  endif ()
  set (SZIP_LIBRARIES ${SZIP_STATIC_LIBRARY})

  set (SZIP_INCLUDE_DIR_GEN "${BINARY_DIR}")
  if (USE_LIBAEC)
    set (SZIP_INCLUDE_DIR "${SOURCE_DIR}/include")
  else ()
    set (SZIP_INCLUDE_DIR "${SOURCE_DIR}/src")
  endif ()
  set (SZIP_FOUND 1)
  set (SZIP_INCLUDE_DIRS ${SZIP_INCLUDE_DIR_GEN} ${SZIP_INCLUDE_DIR})
endmacro ()

#-------------------------------------------------------------------------------
macro (PACKAGE_SZIP_LIBRARY compress_type)
  set (SZIP_HDR "SZconfig")
  if (USE_LIBAEC)
    set (SZIP_HDR "aec_config")
  else ()
    set (SZIP_HDR "libaec_Export")
  endif ()
  add_custom_target (SZIP-GenHeader-Copy ALL
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${SZIP_INCLUDE_DIR_GEN}/${SZIP_HDR}.h ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
      COMMENT "Copying ${SZIP_INCLUDE_DIR_GEN}/${SZIP_HDR}.h to ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/"
  )
  set (EXTERNAL_HEADER_LIST ${EXTERNAL_HEADER_LIST} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${SZIP_HDR}.h)
  if (${compress_type} MATCHES "GIT" OR ${compress_type} MATCHES "TGZ")
    add_dependencies (SZIP-GenHeader-Copy SZIP)
  endif ()
endmacro ()

#-------------------------------------------------------------------------------
macro (EXTERNAL_ZLIB_LIBRARY compress_type)
  if (${compress_type} MATCHES "GIT")
    EXTERNALPROJECT_ADD (HDF4_ZLIB
        GIT_REPOSITORY ${ZLIB_URL}
        GIT_TAG ${ZLIB_BRANCH}
        INSTALL_COMMAND ""
        CMAKE_ARGS
            -DBUILD_SHARED_LIBS:BOOL=OFF
            -DZLIB_PACKAGE_EXT:STRING=${HDF_PACKAGE_EXT}
            -DZLIB_EXTERNALLY_CONFIGURED:BOOL=OFF
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
            -DCMAKE_DEBUG_POSTFIX:STRING=${CMAKE_DEBUG_POSTFIX}
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
            -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
            -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
            -DCMAKE_PDB_OUTPUT_DIRECTORY:PATH=${CMAKE_PDB_OUTPUT_DIRECTORY}
            -DCMAKE_ANSI_CFLAGS:STRING=${CMAKE_ANSI_CFLAGS}
            -DHDF_USE_GNU_DIRS:STRING=${HDF4_USE_GNU_DIRS}
            -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
            -DCMAKE_TOOLCHAIN_FILE:STRING=${CMAKE_TOOLCHAIN_FILE}
            -DPACKAGE_NAMESPACE=${HDF_PACKAGE_NAMESPACE}
    )
  elseif (${compress_type} MATCHES "TGZ")
    EXTERNALPROJECT_ADD (HDF4_ZLIB
        URL ${ZLIB_URL}
        URL_MD5 ""
        INSTALL_COMMAND ""
        CMAKE_ARGS
            -DBUILD_SHARED_LIBS:BOOL=OFF
            -DZLIB_PACKAGE_EXT:STRING=${HDF_PACKAGE_EXT}
            -DZLIB_EXTERNALLY_CONFIGURED:BOOL=OFF
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
            -DCMAKE_DEBUG_POSTFIX:STRING=${CMAKE_DEBUG_POSTFIX}
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
            -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
            -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
            -DCMAKE_PDB_OUTPUT_DIRECTORY:PATH=${CMAKE_PDB_OUTPUT_DIRECTORY}
            -DCMAKE_ANSI_CFLAGS:STRING=${CMAKE_ANSI_CFLAGS}
            -DHDF_USE_GNU_DIRS:STRING=${HDF4_USE_GNU_DIRS}
            -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
            -DCMAKE_TOOLCHAIN_FILE:STRING=${CMAKE_TOOLCHAIN_FILE}
            -DPACKAGE_NAMESPACE=${HDF_PACKAGE_NAMESPACE}
    )
  endif ()
  externalproject_get_property (HDF4_ZLIB BINARY_DIR SOURCE_DIR)

  if (NOT ZLIB_LIB_NAME)
    set (ZLIB_LIB_NAME "z")
  endif ()
##include (${BINARY_DIR}/${ZLIB_PACKAGE_NAME}${HDF_PACKAGE_EXT}-targets.cmake)
# Create imported target zlib-static
  add_library(${HDF_PACKAGE_NAMESPACE}zlib-static STATIC IMPORTED)
  HDF_IMPORT_SET_LIB_OPTIONS (${HDF_PACKAGE_NAMESPACE}zlib-static ${ZLIB_LIB_NAME} STATIC "")
  add_dependencies (${HDF_PACKAGE_NAMESPACE}zlib-static HDF4_ZLIB)
  set (ZLIB_STATIC_LIBRARY "${HDF_PACKAGE_NAMESPACE}zlib-static")
  set (ZLIB_LIBRARIES ${ZLIB_STATIC_LIBRARY})

  set (ZLIB_INCLUDE_DIR_GEN "${BINARY_DIR}")
  set (ZLIB_INCLUDE_DIR "${SOURCE_DIR}")
  set (ZLIB_FOUND 1)
  set (ZLIB_INCLUDE_DIRS ${ZLIB_INCLUDE_DIR_GEN} ${ZLIB_INCLUDE_DIR})
endmacro ()

#-------------------------------------------------------------------------------
macro (PACKAGE_ZLIB_LIBRARY compress_type)
  add_custom_target (ZLIB-GenHeader-Copy ALL
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ZLIB_INCLUDE_DIR_GEN}/zconf.h ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
      COMMENT "Copying ${ZLIB_INCLUDE_DIR_GEN}/zconf.h to ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/"
  )
  set (EXTERNAL_HEADER_LIST ${EXTERNAL_HEADER_LIST} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/zconf.h)
  if (${compress_type} MATCHES "GIT" OR ${compress_type} MATCHES "TGZ")
    add_dependencies (ZLIB-GenHeader-Copy HDF4_ZLIB)
  endif ()
endmacro ()
