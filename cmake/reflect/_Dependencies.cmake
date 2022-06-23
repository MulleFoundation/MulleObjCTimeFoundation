# This file will be regenerated by `mulle-sourcetree-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Files.cmake
#
# Disable generation of this file with:
#
# mulle-sde environment set MULLE_SOURCETREE_TO_CMAKE_DEPENDENCIES_FILE DISABLE
#
if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# Generated from sourcetree: C5AE24A2-1D06-4144-A6D5-0059AC2A65DC;MulleObjC;no-singlephase;
# Disable with : `mulle-sourcetree mark MulleObjC no-link`
# Disable for this platform: `mulle-sourcetree mark MulleObjC no-cmake-platform-${MULLE_UNAME}`
#
if( NOT MULLE_OBJC_LIBRARY)
   find_library( MULLE_OBJC_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}MulleObjC${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX} ${CMAKE_STATIC_LIBRARY_PREFIX}MulleObjC${CMAKE_STATIC_LIBRARY_SUFFIX} MulleObjC NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_OBJC_LIBRARY is ${MULLE_OBJC_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_OBJC_LIBRARY)
      #
      # Add MULLE_OBJC_LIBRARY to ALL_LOAD_DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark MulleObjC no-cmake-add`
      #
      set( ALL_LOAD_DEPENDENCY_LIBRARIES
         ${ALL_LOAD_DEPENDENCY_LIBRARIES}
         ${MULLE_OBJC_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit information from dependency.
      # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
      # Disable with: `mulle-sourcetree mark MulleObjC no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_OBJC_ROOT "${MULLE_OBJC_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_OBJC_ROOT "${_TMP_MULLE_OBJC_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark MulleObjC no-cmake-dependency`
      #
      foreach( _TMP_MULLE_OBJC_NAME "MulleObjC")
         set( _TMP_MULLE_OBJC_DIR "${_TMP_MULLE_OBJC_ROOT}/include/${_TMP_MULLE_OBJC_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_OBJC_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_OBJC_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_OBJC_DIR}")
            #
            include( "${_TMP_MULLE_OBJC_DIR}/DependenciesAndLibraries.cmake")
            #
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_OBJC_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_OBJC_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_OBJC_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
      #
      # Search for "MulleObjCLoader+<name>.h" in include directory.
      # Disable with: `mulle-sourcetree mark MulleObjC no-cmake-loader`
      #
      if( NOT NO_INHERIT_OBJC_LOADERS)
         foreach( _TMP_MULLE_OBJC_NAME "MulleObjC")
            set( _TMP_MULLE_OBJC_FILE "${_TMP_MULLE_OBJC_ROOT}/include/${_TMP_MULLE_OBJC_NAME}/MulleObjCLoader+${_TMP_MULLE_OBJC_NAME}.h")
            if( EXISTS "${_TMP_MULLE_OBJC_FILE}")
               set( INHERITED_OBJC_LOADERS
                  ${INHERITED_OBJC_LOADERS}
                  ${_TMP_MULLE_OBJC_FILE}
                  CACHE INTERNAL "need to cache this"
               )
               break()
            endif()
         endforeach()
      endif()
   else()
      # Disable with: `mulle-sourcetree mark MulleObjC no-require-link`
      message( FATAL_ERROR "MULLE_OBJC_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: C5642466-3526-461D-A4BD-492BCA6FF633;mulle-time;no-all-load,no-cmake-loader,no-cmake-searchpath,no-import;
# Disable with : `mulle-sourcetree mark mulle-time no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-time no-cmake-platform-${MULLE_UNAME}`
#
if( NOT MULLE_TIME_LIBRARY)
   find_library( MULLE_TIME_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-time${CMAKE_DEBUG_POSTFIX}${CMAKE_STATIC_LIBRARY_SUFFIX} ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-time${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-time NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_TIME_LIBRARY is ${MULLE_TIME_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_TIME_LIBRARY)
      #
      # Add MULLE_TIME_LIBRARY to DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-time no-cmake-add`
      #
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_TIME_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit information from dependency.
      # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
      # Disable with: `mulle-sourcetree mark mulle-time no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_TIME_ROOT "${MULLE_TIME_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_TIME_ROOT "${_TMP_MULLE_TIME_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark mulle-time no-cmake-dependency`
      #
      foreach( _TMP_MULLE_TIME_NAME "mulle-time")
         set( _TMP_MULLE_TIME_DIR "${_TMP_MULLE_TIME_ROOT}/include/${_TMP_MULLE_TIME_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_TIME_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_TIME_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_TIME_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_TIME_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_TIME_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_TIME_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_TIME_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      # Disable with: `mulle-sourcetree mark mulle-time no-require-link`
      message( FATAL_ERROR "MULLE_TIME_LIBRARY was not found")
   endif()
endif()
