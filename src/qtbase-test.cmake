# This file is part of MXE. See LICENSE.md for licensing information.

# partial module - included by src/cmake/test/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(CXX)

include_directories("${PROJECT_BINARY_DIR}")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
find_package(Qt5Widgets ${PKG_VERSION} EXACT REQUIRED)
find_package(Qt5Gui ${PKG_VERSION} EXACT REQUIRED)

# mxe specific additions for static libs and plugins
find_package(PkgConfig REQUIRED)
pkg_check_modules(QT5_PKGCONFIG Qt5Widgets)
link_directories(${QT5_PKGCONFIG_LIBRARY_DIRS})

if(BUILD_STATIC)
    add_definitions(-DNON_QMAKE_BUILD)
endif()

add_executable(${TGT} WIN32 "${CMAKE_CURRENT_LIST_DIR}/qt-test.cpp")
target_link_libraries(
    ${TGT}
    Qt5::Widgets
    Qt5::Gui
        # -lQt5PlatformSupport can't be auto-detected
        Qt5::QWindowsIntegrationPlugin -lQt5PlatformSupport
        Qt5::QICOPlugin

    # add pkg-config detected libs last
    ${QT5_PKGCONFIG_LIBRARIES})

install(TARGETS ${TGT} DESTINATION bin)
