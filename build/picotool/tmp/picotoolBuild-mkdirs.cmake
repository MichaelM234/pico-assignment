# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/workspaces/pico-assignment/build/_deps/picotool-src"
  "/workspaces/pico-assignment/build/_deps/picotool-build"
  "/workspaces/pico-assignment/build/_deps"
  "/workspaces/pico-assignment/build/picotool/tmp"
  "/workspaces/pico-assignment/build/picotool/src/picotoolBuild-stamp"
  "/workspaces/pico-assignment/build/picotool/src"
  "/workspaces/pico-assignment/build/picotool/src/picotoolBuild-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/workspaces/pico-assignment/build/picotool/src/picotoolBuild-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/workspaces/pico-assignment/build/picotool/src/picotoolBuild-stamp${cfgdir}") # cfgdir has leading slash
endif()
