
#-----------------------------------------------------------------------
# CPM configuration
#-----------------------------------------------------------------------
set(CPM_MODULE_NAME cpm_boost)
set(CPM_LIB_TARGET_NAME ${CPM_MODULE_NAME})

if ((DEFINED CPM_DIR) AND (DEFINED CPM_UNIQUE_ID) AND (DEFINED CPM_TARGET_NAME))
  set(CPM_LIB_TARGET_NAME ${CPM_TARGET_NAME})
  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CPM_DIR})
  include(CPM)
else()
  set(CPM_DIR "${CMAKE_CURRENT_BINARY_DIR}/cpm-packages" CACHE TYPE STRING)
  find_package(Git)
  if(NOT GIT_FOUND)
    message(FATAL_ERROR "CPM requires Git.")
  endif()
  if (NOT EXISTS ${CPM_DIR}/CPM.cmake)
    execute_process(
      COMMAND "${GIT_EXECUTABLE}" clone https://github.com/iauns/cpm ${CPM_DIR}
      RESULT_VARIABLE error_code
      OUTPUT_VARIABLE head_sha)
    if(error_code)
      message(FATAL_ERROR "CPM failed to get the hash for HEAD")
    endif()
  endif()
  include(${CPM_DIR}/CPM.cmake)
endif()

# All externals *must* define this.
CPM_ForceOnlyOneModuleVersion()

CPM_InitModule(${CPM_MODULE_NAME})

#------------------------------------------------------------------------------
# Boost
#------------------------------------------------------------------------------

set(BOOST_URL "http://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.gz")
set(BOOST_TAR ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/boost.tar.gz)
set(BOOST_UNPACKED ${CMAKE_CURRENT_SOURCE_DIR}/boost_1_57_0)

set(REPO_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/boost)
if(NOT EXISTS ${BOOST_TAR} OR NOT EXISTS ${REPO_SOURCE_DIR})
    message("Downloading Boost Headers 1.57.0")
    file(DOWNLOAD ${BOOST_URL} ${BOOST_TAR} SHOW_PROGRESS
        EXPECTED_HASH SHA1=55366a96bb76440ab140047065650f1d73dbfd8c)
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar -xf ${BOOST_TAR}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        RESULT_VARIABLE error_code)
    if(error_code)
        message(FATAL_ERROR "Failed to unpack boost")
    endif()
    file(RENAME ${BOOST_UNPACKED} ${REPO_SOURCE_DIR})
endif()

CPM_ExportAdditionalIncludeDir("${REPO_SOURCE_DIR}/")
