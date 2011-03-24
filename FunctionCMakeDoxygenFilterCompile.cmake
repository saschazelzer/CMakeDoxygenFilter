#!
#! \brief Download and compile a CMake doxygen input filter
#!
#! \param argv1 (optional) Supply an absolute filename for the generated executable
#! \return This function sets the <code>CMakeDoxygenFilter_EXECUTABLE</code>
#!         variable to the absolute path of the generated input filter executable
#!         in the parent scope.
#!
#! This CMake function compiles the http://github.com/saschazelzer/CMakeDoxygenFilter
#! project into a doxygen input filter executable. See
#! http://github.com/saschazelzer/CMakeDoxygenFilter/blob/master/README for more details.
#!
function(FunctionCMakeDoxygenFilterCompile)

   if (ARGV1)
    set(copy_file "${ARGV1}")
  else()
    set(copy_file "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/CMakeDoxygenFilter${CMAKE_EXECUTABLE_SUFFIX}")
  endif()

  set(cmake_doxygen_filter_url "file:///home/zelzer/src/CMakeDoxygenFilter/CMakeDoxygenFilter.cpp")
  set(cmake_doxygen_filter_src "${CMAKE_CURRENT_BINARY_DIR}/CMakeDoxygenFilter.cpp")

  file(DOWNLOAD "${cmake_doxygen_filter_url}" "${cmake_doxygen_filter_src}" STATUS status)
  list(GET status 0 error_code)
  list(GET status 1 error_msg)
  if(error_code)
    message(FATAL_ERROR "error: Failed to download ${cmake_doxygen_filter_url} - ${error_msg}")
  endif()

  try_compile(result_var 
              "${CMAKE_CURRENT_BINARY_DIR}"
              "${cmake_doxygen_filter_src}"
              OUTPUT_VARIABLE compile_output
              COPY_FILE ${copy_file}
             )
             
  if(NOT result_var)
    message(FATAL_ERROR "error: Faild to compile ${cmake_doxygen_filter_src} (result: ${result_var})\n${compile_output}")
  endif()
  
  set(CMakeDoxygenFilter_EXECUTABLE "${copy_file}" PARENT_SCOPE)
  
endfunction()
