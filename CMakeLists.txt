cmake_minimum_required(VERSION 3.25)

set(CMAKE_CXX_STANDARD 20)



set(PRJ_NAME      empty_cc)    # C/C++ identifier here.
set(PRJ_OSN       empty-cc)    # used in OS context, such as deploy name.
set(PRJ_CXX_NAME  empty-cxx)
set(PRJ_CXX_MNAME EMPTY_CXX)



project(${PRJ_NAME})
include(CTest)

option(BUILD_DOCUMENTATION "configure it for buildng documentation" OFF)


# -- empty-cc executable --

add_executable(${PRJ_OSN}
   main.cc
 )
set_target_properties(${PRJ_OSN}
    PROPERTIES
    CXX_STANDARD 20
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS OFF          # use -std=c++11 rather than -std=gnu++11
)



if(BUILD_DOCUMENTATION)
  add_subdirectory(docs/)
  attach_doxygen_to(${PRJ_OSN})
endif()



# -- INSTALL --

set(INST_TGT_1 ${PRJ_OSN})

include(GNUInstallDirs)

include(CMakePackageConfigHelpers)

# write_basic_package_version_file(
#     "${INST_TGT_1}-config-version.cmake"
#     # Package compatibility strategy. SameMajorVersion is essentially 'semantic versioning'.
#     COMPATIBILITY SameMajorVersion
# )
# install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${INST_TGT_1}-config-version.cmake"
#         DESTINATION "${${INST_TGT_1}_INSTALL_CMAKEDIR}")

install(TARGETS ${INST_TGT_1})
install(FILES "${CMAKE_CURRENT_LIST_DIR}/LICENSE"
    DESTINATION "${CMAKE_INSTALL_BINDIR}"
)
install(FILES "${CMAKE_CURRENT_LIST_DIR}/main.py"
    DESTINATION "${CMAKE_INSTALL_BINDIR}"
    RENAME "empty-cc.py"
    PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
)

# https://cmake.org/cmake/help/latest/command/install.html#installing-directories
#
# install(DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/scripts"
#     DESTINATION "${CMAKE_INSTALL_BINDIR}"
#     # PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
#     FILES_MATCHING PATTERN "*.sh"
# )
# install(FILES "${CMAKE_CURRENT_LIST_DIR}/CHANGELOG"
#     DESTINATION "${CMAKE_INSTALL_BINDIR}"
#     CONFIGURATIONS Debug
#     OPTIONAL
# )

install(TARGETS ${INST_TGT_1}
    RUNTIME DESTINATION sbin
)

install(DIRECTORY include/${PRJ_CXX_NAME}
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

# install(DIRECTORY dir1 dir2 dir3 TYPE LOCALSTATE)
# install(DIRECTORY dir1 DESTINATION ${CMAKE_INSTALL_LOCALSTATEDIR} FILES_MATCHING PATTERN "*.x")
# install(DIRECTORY dir2 DESTINATION ${CMAKE_INSTALL_LOCALSTATEDIR} FILES_MATCHING PATTERN "*.hpp"
#         EXCLUDE PATTERN "*")
# install(DIRECTORY dir3 DESTINATION ${CMAKE_INSTALL_LOCALSTATEDIR} PATTERN "bin" EXCLUDE)



# -- CPack --

set(CPACK_PACKAGE_VENDOR "Fintip Authors")
set(CPACK_GENERATOR "DEB;RPM;TXZ")
set(CPACK_THREADS 0)
# set(CPACK_PACKAGE_NAME "my_project")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Fintip Authors")
# set(CPACK_PACKAGE_RELEASE 1)
# set(CPACK_PACKAGING_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
# set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_PACKAGE_RELEASE}.${CMAKE_SYSTEM_PROCESSOR}")

# configure_file("${CMAKE_CURRENT_SOURCE_DIR}/my_project.spec.in" "${CMAKE_CURRENT_BINARY_DIR}/my_project.spec" @ONLY IMMEDIATE)
# set(CPACK_RPM_USER_BINARY_SPECFILE "${CMAKE_CURRENT_BINARY_DIR}/my_project.spec")

include(CPack)
