cmake_minimum_required(VERSION 3.24)

project(quant_databento_slice LANGUAGES CXX)

include(FetchContent)

set(DATABENTO_SOURCE_DIR "" CACHE PATH "Local databento-cpp checkout")
if(DATABENTO_SOURCE_DIR)
  add_subdirectory("${DATABENTO_SOURCE_DIR}" "${CMAKE_BINARY_DIR}/databento" EXCLUDE_FROM_ALL)
else()
  FetchContent_Declare(
    databento
    GIT_REPOSITORY https://github.com/databento/databento-cpp
    GIT_TAG v0.67.0
    GIT_SHALLOW TRUE
  )
  FetchContent_MakeAvailable(databento)
endif()

enable_testing()

add_executable(quant_databento_translation_tests databento_translation_tests.cpp)
target_compile_features(quant_databento_translation_tests PRIVATE cxx_std_20)
target_compile_options(quant_databento_translation_tests PRIVATE -Wall -Wextra -Wpedantic -Werror)
target_include_directories(quant_databento_translation_tests PRIVATE "${CMAKE_CURRENT_LIST_DIR}/../../src")
target_link_libraries(quant_databento_translation_tests PRIVATE databento::databento)
add_test(NAME quant_databento_translation_tests COMMAND quant_databento_translation_tests)

add_executable(quant_databento_smoke smoke.cpp)
target_compile_features(quant_databento_smoke PRIVATE cxx_std_20)
target_compile_options(quant_databento_smoke PRIVATE -Wall -Wextra -Wpedantic -Werror)
target_include_directories(quant_databento_smoke PRIVATE "${CMAKE_CURRENT_LIST_DIR}/../../src")
target_link_libraries(quant_databento_smoke PRIVATE databento::databento)
