cmake_minimum_required( VERSION 2.8)

project( ImplementaSimpleKernel )

set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11" )
# list(APPEND CUDA_NVCC_FLAGS "-std=c++11")

find_package( CUDA REQUIRED )
include_directories( ${CUDA_INCLUDE_DIRS} )

cuda_add_executable( helloWorld helloWorld.cu )
cuda_add_executable( checkDimension checkDimension.cu )
cuda_add_executable( arraySum arraySum.cu )
