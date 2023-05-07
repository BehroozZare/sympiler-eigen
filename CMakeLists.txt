cmake_minimum_required(VERSION 3.0)
if (COMMAND cmake_policy)
    cmake_policy(SET CMP0003 NEW)
endif (COMMAND cmake_policy)


# Detects whether this is a top-level project
get_directory_property(HAS_PARENT PARENT_DIRECTORY)
if (HAS_PARENT)
    set(SYMPILER_EIGEN_TOPLEVEL_PROJECT OFF)
else ()
    set(SYMPILER_EIGEN_TOPLEVEL_PROJECT ON)
endif ()


set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/find)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/recipes)


project(sympiler_eigen)


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

set(SYMPILER_INC "${CMAKE_CURRENT_SOURCE_DIR}/sympiler/includes/")
set(SYMPILER_LBC_INC "${CMAKE_CURRENT_SOURCE_DIR}/sympiler/lbc/includes/")

set(SYMPILER_LINK_DIR "${CMAKE_CURRENT_SOURCE_DIR}/sympiler/lib/")
set(LBC_LINK_DIR "${CMAKE_CURRENT_SOURCE_DIR}/sympiler/lbc/lib/")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -w -m64")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=x86-64   -mavx2")


include(eigen)

#find_package(METIS OPTIONAL_COMPONENTS)
link_directories(
        ${SYMPILER_LINK_DIR}
        ${LBC_LINK_DIR}
)


Set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")

add_subdirectory(sympiler)
add_library(sympiler_eigen sympiler_cholesky.cpp)

target_link_libraries(sympiler_eigen
        sym_sparse_blas
        lbc
        ${METIS_LIB}
        )

# target_include_directories(sympiler_eigen PUBLIC
#         ${CMAKE_CURRENT_SOURCE_DIR}/includes
#         ${SYMPILER_INC}
#         ${SYMPILER_LBC_INC}
#         ${EIGEN_INCLUDE_DIRS}
#         )

include_directories(${CMAKE_CURRENT_SOURCE_DIR}includes
        ${SYMPILER_INC}
        ${SYMPILER_LBC_INC}
        ${EIGEN_INCLUDE_DIRS}
        )


# Uncomment the following line for building examples
if (SYMPILER_EIGEN_TOPLEVEL_PROJECT)
    add_subdirectory(example)
endif()




