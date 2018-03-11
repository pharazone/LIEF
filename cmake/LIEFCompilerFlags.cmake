include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)
if(__add_lief_compiler_flags)
	return()
endif()
set(__add_lief_compiler_flags ON)

function(append value)
  foreach(variable ${ARGN})
    set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  endforeach(variable)
endfunction()

function(append_if condition value)
  if (${condition})
    foreach(variable ${ARGN})
      set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
    endforeach(variable)
  endif()
endfunction()

macro(ADD_FLAG_IF_SUPPORTED flag name)
  CHECK_C_COMPILER_FLAG("${flag}"   "C_SUPPORTS_${name}")
  CHECK_CXX_COMPILER_FLAG("${flag}" "CXX_SUPPORTS_${name}")

  if (C_SUPPORTS_${name})
    target_compile_options(LIB_LIEF_STATIC PRIVATE ${flag})
    target_compile_options(LIB_LIEF_SHARED PRIVATE ${flag})
  endif()

  if (CXX_SUPPORTS_${name})
    target_compile_options(LIB_LIEF_STATIC PRIVATE ${flag})
    target_compile_options(LIB_LIEF_SHARED PRIVATE ${flag})
  endif()
endmacro()



if (MSVC)
  add_definitions(-DNOMINMAX)
  target_compile_options(LIB_LIEF_STATIC PUBLIC /FIiso646.h)
  target_compile_options(LIB_LIEF_SHARED PUBLIC /FIiso646.h)

  if (CMAKE_BUILD_TYPE MATCHES "Debug")
    target_compile_options(LIB_LIEF_STATIC PUBLIC /MTd)
  else()
    target_compile_options(LIB_LIEF_STATIC PUBLIC /MT)
  endif()

endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  if (UNIX)
    if (LIEF_FORCE32)
      target_compile_options(LIB_LIEF_STATIC PRIVATE -m32)
      target_compile_options(LIB_LIEF_SHARED PRIVATE -m32)

      set_property(TARGET LIB_LIEF_STATIC LIB_LIEF_SHARED PROPERTY LINK_FLAGS -m32)
    endif()
  endif()

endif()

ADD_FLAG_IF_SUPPORTED("-Wall"                     WALL)
ADD_FLAG_IF_SUPPORTED("-Wextra"                   WEXTRA)
ADD_FLAG_IF_SUPPORTED("-Wpedantic"                WPEDANTIC)
ADD_FLAG_IF_SUPPORTED("-fno-stack-protector"      NO_STACK_PROTECTOR)
ADD_FLAG_IF_SUPPORTED("-fomit-frame-pointer"      OMIT_FRAME_POINTER)
ADD_FLAG_IF_SUPPORTED("-fno-strict-aliasing"      NO_STRICT_ALIASING)
ADD_FLAG_IF_SUPPORTED("-fexceptions"              EXCEPTION)
ADD_FLAG_IF_SUPPORTED("-fvisibility=hidden"       VISIBILITY)
ADD_FLAG_IF_SUPPORTED("-Wno-expansion-to-defined" NO_EXPANSION_TO_DEFINED)
#ADD_FLAG_IF_SUPPORTED("-Wduplicated-cond"         HAS_DUPLICATED_COND)
#ADD_FLAG_IF_SUPPORTED("-Wduplicated-branches"     HAS_DUPLICATED_BRANCHES)
#ADD_FLAG_IF_SUPPORTED("-Wlogical-op"              HAS_LOGICAL_OP)
#ADD_FLAG_IF_SUPPORTED("-Wshadow"                  HAS_SHADOW)

