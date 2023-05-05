# Try to find MKL headers and libraries.
#
# Usage of this module as follows:
#
#     find_package(MKL)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#
# Variables defined by this module:
#
#  MKL_FOUND              System has MKL libraries and headers
#  MKL_LIBRARIES          The MKL library
#  MKL_INCLUDE_DIRS       The location of MKL headers

find_path(MKL_PERFIX
        NAMES include/mkl.h
        PATHS $ENV{MKLROOT}
        HINTS /home/behrooz/intel/oneapi/mkl/latest /media/behrooz/Field/intel/mkl
        )

#compiler/2021.1.1/linux/compiler/lib/intel64_lin
find_library(MKL_GNU_THREAD NAMES mkl_intel_lp64 HINTS ${MKL_PERFIX}/lib/intel64 ${HILTIDEPS}/lib)
if (MKL_GNU_THREAD)
    message(STATUS "Found mkl_intel_lp64: ${MKL_GNU_THREAD}")
else ()
    message(FATAL_ERROR "mkl_intel_lp64 library not found")
endif ()

find_library(PTHREAD NAMES pthread HINTS ${MKL_PERFIX}/lib/intel64 ${HILTIDEPS}/lib)
if (PTHREAD)
    message(STATUS "Found pthread: ${PTHREAD}")
else ()
    message(FATAL_ERROR "pthread library not found")
endif ()

find_library(MKL_INTEL_THREAD NAMES mkl_intel_thread HINTS ${MKL_PERFIX}/lib/intel64 ${HILTIDEPS}/lib)
if (MKL_INTEL_THREAD)
    message(STATUS "Found mkl_intel_thread: ${MKL_INTEL_THREAD}")
else ()
    message(FATAL_ERROR "mkl_intel_thread library not found")
endif ()

find_library(MKL_SEQUENTIAL NAMES mkl_sequential HINTS ${MKL_PERFIX}/lib/intel64 ${HILTIDEPS}/lib)
if (MKL_SEQUENTIAL)
    message(STATUS "Found mkl_sequential: ${MKL_SEQUENTIAL}")
else ()
    message(FATAL_ERROR "mkl_sequential library not found")
endif ()

find_library(MKL_CORE NAMES mkl_core HINTS ${MKL_PERFIX}/lib/intel64 ${HILTIDEPS}/lib)
if (MKL_CORE)
    message(STATUS "Found mkl_core: ${MKL_CORE}")
else ()
    message(FATAL_ERROR "mkl_core library not found")
endif ()

find_library(M NAMES m HINTS ${MKL_PERFIX}/lib/intel64 ${HILTIDEPS}/lib)
if (M)
    message(STATUS "Found m: ${M}")
else ()
    message(FATAL_ERROR "m library not found")
endif ()

find_library(DL NAMES dl HINTS ${MKL_PERFIX}/lib/intel64 ${HILTIDEPS}/lib)
if (DL)
    message(STATUS "Found dl: ${DL}")
else ()
    message(FATAL_ERROR "dl library not found")
endif ()

find_library(MKL_BLACS_OPENMPI_LP64 NAMES mkl_blacs_openmpi_lp64 HINTS ${MKL_PERFIX}/lib/intel64 ${HILTIDEPS}/lib)
if (MKL_BLACS_OPENMPI_LP64)
    message(STATUS "Found mkl_blacs_openmpi_lp64: ${MKL_BLACS_OPENMPI_LP64}")
else ()
    message(FATAL_ERROR "mkl_blacs_openmpi_lp64 library not found")
endif ()


find_library(IOMP5 NAMES iomp5 HINTS
        ${MKL_PERFIX}/../../compiler/latest/linux/compiler/lib/intel64
        ${MKL_PERFIX}/../compilers_and_libraries/linux/lib/intel64
        ${MKL_PERFIX}/../../../compilers_and_libraries/linux/lib/intel64
        ${HILTIDEPS}/lib)
if (IOMP5)
    message(STATUS "Found iomp5: ${IOMP5}")
else ()
    message(FATAL_ERROR "iomp5 library not found")
endif ()

find_path(MKL_INCLUDE_DIRS
        NAMES mkl.h
        HINTS ${MKL_PERFIX}/include ${HILTIDEPS}/include
        )
if (MKL_INCLUDE_DIRS)
    message(STATUS "Found mkl header at: ${MKL_INCLUDE_DIRS}")
else ()
    message(FATAL_ERROR "mkl header is not found")
endif ()

set(MKL_LIBRARIES ${MKL_GNU_THREAD};${PTHREAD};${MKL_INTEL_THREAD};
        ${MKL_INTEL_THREAD};${IOMP5};${MKL_SEQUENTIAL};${MKL_CORE};${M};${DL};${MKL_BLACS_OPENMPI_LP64})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MKL DEFAULT_MSG
        MKL_GNU_THREAD
        PTHREAD
        MKL_INTEL_THREAD
        IOMP5
        MKL_SEQUENTIAL
        MKL_CORE
        M
        DL
        MKL_BLACS_OPENMPI_LP64
        MKL_INCLUDE_DIRS
        )

mark_as_advanced(
        MKL_PREFIX_DIRS
        MKL_GNU_THREAD
        PTHREAD
        MKL_INTEL_THREAD
        IOMP5
        MKL_SEQUENTIAL
        MKL_CORE
        M
        DL
        MKL_BLACS_OPENMPI_LP64
        MKL_INCLUDE_DIRS
)


IF (MKL_LIBRARIES AND MKL_INCLUDE_DIR)
  SET(MKL_FOUND TRUE)
ELSE (MKL_LIBRARIES AND MKL_INCLUDE_DIR)
  if (MKL_LIBRARIES AND NOT MKL_INCLUDE_DIR)
    MESSAGE(WARNING "MKL libraries files are found, but MKL header files are \
      not. You can get them by `conda install mkl-include` if using conda (if \
      it is missing, run `conda upgrade -n root conda` first), and \
      `pip install mkl-devel` if using pip. If build fails with header files \
      available in the system, please make sure that CMake will search the \
      directory containing them, e.g., by setting CMAKE_INCLUDE_PATH.")
  endif()
  SET(MKL_FOUND FALSE)
  SET(MKL_VERSION)  # clear MKL_VERSION
ENDIF (MKL_LIBRARIES AND MKL_INCLUDE_DIR)

# Standard termination
IF(NOT MKL_FOUND AND MKL_FIND_REQUIRED)
  MESSAGE(FATAL_ERROR "MKL library not found. Please specify library location \
    by appending the root directory of the MKL installation to the environment variable CMAKE_PREFIX_PATH.")
ENDIF(NOT MKL_FOUND AND MKL_FIND_REQUIRED)
IF(NOT MKL_FIND_QUIETLY)
  IF(MKL_FOUND)
    MESSAGE(STATUS "MKL library found")
  ELSE(MKL_FOUND)
    MESSAGE(STATUS "MKL library not found")
  ENDIF(MKL_FOUND)
ENDIF(NOT MKL_FIND_QUIETLY)

# Do nothing if MKL_FOUND was set before!
ENDIF (NOT MKL_FOUND)
