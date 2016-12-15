#!
#! \brief Download and compile a CMake doxygen input filter
#!
#! \param OUT (optional) Supply an absolute filename for
#!                       the generated executable.
#! \param NAMESPACE (optional) Supply a C++ namespace in
#!                             which the generated function declrarations
#!                             should be wrapped.
#!
#! \return This function sets the <code>CMakeDoxygenFilter_EXECUTABLE</code>
#!         variable to the absolute path of the generated input filter executable
#!         in the parent scope. If <out-file> is specified, they will be the same.
#!
#! This CMake function compiles the http://github.com/saschazelzer/CMakeDoxygenFilter
#! project into a doxygen input filter executable. See
#! http://github.com/saschazelzer/CMakeDoxygenFilter/blob/master/README for more details.
#!
function(FunctionCMakeDoxygenFilterCompile OUT NAMESPACE)

  #-------------------- parse function arguments -------------------

  set(DEFAULT_ARGS)
  set(prefix "FILTER")
  set(arg_names "OUT;NAMESPACE")
  set(option_names "")

  foreach(arg_name ${arg_names})
    set(${prefix}_${arg_name})
  endforeach(arg_name)

  foreach(option ${option_names})
    set(${prefix}_${option} FALSE)
  endforeach(option)

  set(current_arg_name DEFAULT_ARGS)
  set(current_arg_list)

  foreach(arg ${ARGN})
    set(larg_names ${arg_names})
    list(FIND larg_names "${arg}" is_arg_name)
    if(is_arg_name GREATER -1)
      set(${prefix}_${current_arg_name} ${current_arg_list})
      set(current_arg_name "${arg}")
      set(current_arg_list)
    else(is_arg_name GREATER -1)
      set(loption_names ${option_names})
      list(FIND loption_names "${arg}" is_option)
      if(is_option GREATER -1)
        set(${prefix}_${arg} TRUE)
      else(is_option GREATER -1)
        set(current_arg_list ${current_arg_list} "${arg}")
      endif(is_option GREATER -1)
    endif(is_arg_name GREATER -1)
  endforeach(arg ${ARGN})

  set(${prefix}_${current_arg_name} ${current_arg_list})

  #------------------- finished parsing arguments ----------------------

  if(FILTER_OUT)
    set(copy_file "${FILTER_OUT}")
  else()
    set(copy_file "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/CMakeDoxygenFilter${CMAKE_EXECUTABLE_SUFFIX}")
  endif()
  
  set(compile_defs "")
  if(FILTER_NAMESPACE)
    set(compile_defs "${compile_defs} -DUSE_NAMESPACE=${FILTER_NAMESPACE}")
  endif()

  set(cmake_doxygen_filter_url "https://github.com/saschazelzer/CMakeDoxygenFilter/raw/master/CMakeDoxygenFilter.cpp")
  set(cmake_doxygen_filter_src "${CMAKE_CURRENT_BINARY_DIR}/CMakeDoxygenFilter.cpp")

  # If downloading on Windows fails with a "unsupported protocol" error, your CMake
  # version is not build with SSL support. Either build CMake yourself with
  # CMAKE_USE_OPENSSL enabled, or copy https://github.com/saschazelzer/CMakeDoxygenFilter/raw/master/CMakeDoxygenFilter.cpp
  # into your repository and set cmake_doxygen_filter_src to your local copy
  # and remove the download code below.
  file(DOWNLOAD "${cmake_doxygen_filter_url}" "${cmake_doxygen_filter_src}" STATUS status)
  list(GET status 0 error_code)
  list(GET status 1 error_msg)
  if(error_code)
    message(FATAL_ERROR "error: Failed to download ${cmake_doxygen_filter_url} - ${error_msg}")
  endif()

  try_compile(result_var 
              "${CMAKE_CURRENT_BINARY_DIR}"
              "${cmake_doxygen_filter_src}"
              COMPILE_DEFINITIONS ${compile_defs}
              OUTPUT_VARIABLE compile_output
              COPY_FILE ${copy_file}
             )
             
  if(NOT result_var)
    message(FATAL_ERROR "error: Faild to compile ${cmake_doxygen_filter_src} (result: ${result_var})\n${compile_output}")
  endif()
  
  set(CMakeDoxygenFilter_EXECUTABLE "${copy_file}" PARENT_SCOPE)
  
endfunction()
