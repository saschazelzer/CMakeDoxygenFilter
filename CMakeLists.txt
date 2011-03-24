cmake_minimum_required(VERSION 2.8)

#-----------------------------------------------------------------------------
# See http://cmake.org/cmake/help/cmake-2-8-docs.html#section_Policies for details
#

set(project_policies
  CMP0001 # NEW: CMAKE_BACKWARDS_COMPATIBILITY should no longer be used.
  CMP0002 # NEW: Logical target names must be globally unique.
  CMP0003 # NEW: Libraries linked via full path no longer produce linker search paths.
  CMP0004 # NEW: Libraries linked may NOT have leading or trailing whitespace.
  CMP0005 # NEW: Preprocessor definition values are now escaped automatically.
  CMP0006 # NEW: Installing MACOSX_BUNDLE targets requires a BUNDLE DESTINATION.
  CMP0007 # NEW: List command no longer ignores empty elements.
  CMP0008 # NEW: Libraries linked by full-path must have a valid library file name.
  CMP0009 # NEW: FILE GLOB_RECURSE calls should not follow symlinks by default.
  CMP0010 # NEW: Bad variable reference syntax is an error.
  CMP0011 # NEW: Included scripts do automatic cmake_policy PUSH and POP.
  CMP0012 # NEW: if() recognizes numbers and boolean constants.
  CMP0013 # NEW: Duplicate binary directories are not allowed.
  CMP0014 # NEW: Input directories must have CMakeLists.txt
  )
foreach(policy ${project_policies})
  if(POLICY ${policy})
    cmake_policy(SET ${policy} NEW)
  endif()
endforeach()

#-----------------------------------------------------------------------------
# Build the executable
#-----------------------------------------------------------------------------
project(CMakeDoxygenFilter)

if (NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin)
endif()

set(MY_CXX_FLAGS "${CMAKE_CXX_FLAGS_INIT}")
if(CMAKE_COMPILER_IS_GNUCXX)
  set(MY_CXX_FLAGS "${MY_CXX_FLAGS} -Wall -Wextra -Wpointer-arith -Winvalid-pch -Wcast-align -Wwrite-strings -D_FORTIFY_SOURCE=2")
  set(MY_CXX_FLAGS "${MY_CXX_FLAGS} -Woverloaded-virtual -Wold-style-cast -Wstrict-null-sentinel -Wsign-promo")
endif()

set(CMAKE_CXX_FLAGS ${MY_CXX_FLAGS})

add_executable(${PROJECT_NAME} CMakeDoxygenFilter.cpp)

#-----------------------------------------------------------------------------
# Configure CMakeDoxygenFilterConfig.cmake
#-----------------------------------------------------------------------------

set(CMakeDoxygeFilter_EXECUTABLE "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${PROJECT_NAME}${CMAKE_EXECUTABLE_SUFFIX}")

configure_file("${CMAKE_CURRENT_SOURCE_DIR}/CMakeDoxygenFilterConfig.cmake.in"
               "${CMAKE_CURRENT_BINARY_DIR}/CMakeDoxygenFilterConfig.cmake"
               @ONLY)

#-----------------------------------------------------------------------------
# Installation support
#-----------------------------------------------------------------------------

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)

