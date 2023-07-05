#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "OpenCC::OpenCC" for configuration "Release"
set_property(TARGET OpenCC::OpenCC APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(OpenCC::OpenCC PROPERTIES
  IMPORTED_IMPLIB_RELEASE "${_IMPORT_PREFIX}/./lib/opencc.lib"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/opencc.dll"
  )

list(APPEND _cmake_import_check_targets OpenCC::OpenCC )
list(APPEND _cmake_import_check_files_for_OpenCC::OpenCC "${_IMPORT_PREFIX}/./lib/opencc.lib" "${_IMPORT_PREFIX}/bin/opencc.dll" )

# Import target "OpenCC::marisa" for configuration "Release"
set_property(TARGET OpenCC::marisa APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(OpenCC::marisa PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/./lib/marisa.lib"
  )

list(APPEND _cmake_import_check_targets OpenCC::marisa )
list(APPEND _cmake_import_check_files_for_OpenCC::marisa "${_IMPORT_PREFIX}/./lib/marisa.lib" )

# Import target "OpenCC::gmock" for configuration "Release"
set_property(TARGET OpenCC::gmock APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(OpenCC::gmock PROPERTIES
  IMPORTED_IMPLIB_RELEASE "${_IMPORT_PREFIX}/lib/gmock.lib"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/gmock.dll"
  )

list(APPEND _cmake_import_check_targets OpenCC::gmock )
list(APPEND _cmake_import_check_files_for_OpenCC::gmock "${_IMPORT_PREFIX}/lib/gmock.lib" "${_IMPORT_PREFIX}/bin/gmock.dll" )

# Import target "OpenCC::gmock_main" for configuration "Release"
set_property(TARGET OpenCC::gmock_main APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(OpenCC::gmock_main PROPERTIES
  IMPORTED_IMPLIB_RELEASE "${_IMPORT_PREFIX}/lib/gmock_main.lib"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/gmock_main.dll"
  )

list(APPEND _cmake_import_check_targets OpenCC::gmock_main )
list(APPEND _cmake_import_check_files_for_OpenCC::gmock_main "${_IMPORT_PREFIX}/lib/gmock_main.lib" "${_IMPORT_PREFIX}/bin/gmock_main.dll" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
