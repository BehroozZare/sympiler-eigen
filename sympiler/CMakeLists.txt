cmake_minimum_required(VERSION 3.0)


project(sympiler_project)
set(SYMPILER_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})

#set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lib/)
#set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lib/)
#set(SYMPILER_EXTERNAL ${CMAKE_CURRENT_LIST_DIR}/external)

### Configuration
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/find)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/recipes)

# Defining paths
set(SPARSE_LIB_INC "${CMAKE_CURRENT_SOURCE_DIR}/sparse_blas/includes")
set(SPARSE_LIB_LIB "${CMAKE_CURRENT_SOURCE_DIR}/lib")
set(SPARSE_LIB_SRC "${CMAKE_CURRENT_SOURCE_DIR}/sparse_blas")
AUX_SOURCE_DIRECTORY(${SPARSE_LIB_SRC} SPARSE_LIB_SRC_FILES)

set(SPARSE_UTIL_SRC "${CMAKE_CURRENT_SOURCE_DIR}/lbc/utils")
set(SPARSE_EXTN_SRC "${SPARSE_UTIL_SRC}/external")
#[[
set(SPARSE_UTIL_INC "${CMAKE_CURRENT_SOURCE_DIR}/utils/includes")
set(SPARSE_UTIL_SRC "${CMAKE_CURRENT_SOURCE_DIR}/utils")
#AUX_SOURCE_DIRECTORY(${SPARSE_UTIL_SRC} SPARSE_UTIL_SRC_FILES)
set(SPARSE_UTIL_SRC_FILES
        "${CMAKE_CURRENT_SOURCE_DIR}/utils/BCSCMatrix.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/utils/etree.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/utils/sparse_inspector.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/utils/sparse_io.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/utils/sparse_utilities.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/utils/test_utils.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/utils/lfactor_creation.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/utils/utils.cpp")

set(SPARSE_EXTN_INC "${SPARSE_UTIL_SRC}/external/includes")
set(SPARSE_EXTN_SRC "${SPARSE_UTIL_SRC}/external")
AUX_SOURCE_DIRECTORY(${SPARSE_EXTN_SRC} SPARSE_EXTN_SRC_FILES)
]]


set(LBC_INC "${CMAKE_CURRENT_SOURCE_DIR}/lbc/includes")
set(LBC_SRC "${CMAKE_CURRENT_SOURCE_DIR}/lbc/src/")
set(LBC_LIB "${CMAKE_CURRENT_SOURCE_DIR}/lbc/lib/")
set(LBC_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/lbc/")
#AUX_SOURCE_DIRECTORY(${LBC_SRC} LBC_SRC_FILES)


#AUX_SOURCE_DIRECTORY(${BLAS_SRC} BLAS_SRC_FILES)
#set(BLAS_SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/sparse_blas/dense_blas/BLAS.cpp" )

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lib/)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lib/)


# Find OpenMP
if (APPLE)
    #    SET(CMAKE_C_COMPILER "/usr/local/opt/llvm/bin/clang")
    #    SET(CMAKE_CXX_COMPILER "/usr/local/opt/llvm/bin/clang++")
    #    SET(OPENMP_LIBRARIES "/usr/local/opt/llvm/lib")
    #    SET(OPENMP_INCLUDES "/usr/local/opt/llvm/include")
    if (CMAKE_C_COMPILER_ID MATCHES "Clang")
        set(OpenMP_C "${CMAKE_C_COMPILER}")
        set(OpenMP_C_FLAGS "-fopenmp=libomp -Wno-unused-command-line-argument")
        set(OpenMP_C_LIB_NAMES "libomp" "libgomp" "libiomp5")
        set(OpenMP_libomp_LIBRARY ${OpenMP_C_LIB_NAMES})
        set(OpenMP_libgomp_LIBRARY ${OpenMP_C_LIB_NAMES})
        set(OpenMP_libiomp5_LIBRARY ${OpenMP_C_LIB_NAMES})
    endif ()
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        set(OpenMP_CXX "${CMAKE_CXX_COMPILER}")
        set(OpenMP_CXX_FLAGS "-fopenmp=libomp -Wno-unused-command-line-argument")
        set(OpenMP_CXX_LIB_NAMES "libomp" "libgomp" "libiomp5")
        set(OpenMP_libomp_LIBRARY ${OpenMP_CXX_LIB_NAMES})
        set(OpenMP_libgomp_LIBRARY ${OpenMP_CXX_LIB_NAMES})
        set(OpenMP_libiomp5_LIBRARY ${OpenMP_CXX_LIB_NAMES})
    endif ()
endif ()

#find_package(OPENMP)
find_package(OpenMP)

if (OPENMP_FOUND)
    #include_directories("${OPENMP_INCLUDES}")
    #include_directories("/usr/local/include" "/usr/local/opt/llvm/include")
    #link_directories("${OPENMP_LIBRARIES}")
    #link_directories("/usr/local/lib" "/usr/local/opt/llvm/lib")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
    # set (CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
    add_definitions(-DOPENMP)
endif ()

#add_definitions( -DPROFILE)
#add_definitions( -DLOAD)

find_package(METIS OPTIONAL_COMPONENTS)
if (NOT METIS_FOUND)
    set(METIS_INCLUDE_DIR ${LBC_ROOT_DIR}/external/metis/metis_shared-src/include/)
    set(METIS_INCLUDES ${LBC_ROOT_DIR}/external/metis/metis_shared-src/include/)
    set(METIS_LIBRARY ${LBC_ROOT_DIR}/lib/)
    set(METIS_LIBRARIES ${LBC_ROOT_DIR}/lib/)
    set(METIS_LIB metis)
    set(METIS_FOUND TRUE)
else ()
    set(METIS_LIB ${METIS_LIBRARIES})
endif ()

add_definitions(-DMETIS)


find_package(MKL OPTIONAL_COMPONENTS)
if (MKL_FOUND)
    add_definitions(-DMKL) # add openblas
else ()
    message(STATUS "Intel MKL not found, skipping supernodal Cholesky lib")
endif ()

include_directories(
        ${MKL_INCLUDE_DIRS}
        ${METIS_INCLUDE_DIR}
        ${METIS_INCLUDES}
        ${BLAS_INC}
        ${LBC_INC}
        includes
        includes/parsy/
)


set(ALL_LIBS
        ${MKL_LIBRARIES}
        ${PAPI_LIB_NAME}
        ${PAPI_LIB_NAME2}
        ${METIS_LIB}
        lbc

        )

set(ALL_SOURCE_FILES
        #    ${SPARSE_LIB_SRC_FILES}
        #    ${SPARSE_UTIL_SRC_FILES}
        #    ${SPARSE_EXTN_SRC_FILES}
        #    ${APPS_SRC_FILES} # TODO:some of them are mixed with blas, should be cleaned
        #    ${LBC_SRC_FILES}
        ${BLAS_SRC_FILES}
        ${METIS_SOURCE_FILES})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}   -std=c++17 -w -m64")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=x86-64   -mavx2")

Set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")


if (METIS_FOUND)
    add_definitions(-DMETIS)
    set(METIS_SOURCE_FILES "${SPARSE_UTIL_SRC}/metis_interface.cpp")
    add_subdirectory(demo)
endif ()

add_subdirectory(lbc)
add_subdirectory(sparse_blas)
# add_subdirectory(Catch_tests)
# add_subdirectory(code_gen)
add_subdirectory(utils)  ## TODO: rmeove the folder
