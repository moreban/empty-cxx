
option(BUILD_DOCUMENTATION "Create and install the HTML based API documentation (requires Doxygen)" OFF)

if(BUILD_DOCUMENTATION)
	find_package(Doxygen)

	if(DEBUG OR NOT DOXYGEN_FOUND)
		set(BUILD_DOCUMENTATION OFF)
	endif()
endif()

if(BUILD_DOCUMENTATION)
	if(NOT DOXYGEN_FOUND)
		message(FATAL_ERROR "Doxygen is needed to build the documentation.")
	else()
		message("preparing for doxygen build...")
	endif()

set(DOCS_SRC_DIR "${CMAKE_CURRENT_LIST_DIR}"   CACHE INTERNAL "DOCS_SRC_DIR")
set(DOCS_BIN_DIR "${CMAKE_CURRENT_BINARY_DIR}" CACHE INTERNAL "DOCS_BIN_DIR")
message("    [doxygen] DOCS_SRC_DIR = ${DOCS_SRC_DIR}...")
message("    [doxygen] DOCS_BIN_DIR = ${DOCS_BIN_DIR}...")

macro(docs_from_lib source_lib_target)
	# Find all the public headers
	get_target_property(MY_PUBLIC_HEADER_DIR ${source_lib_target} INTERFACE_INCLUDE_DIRECTORIES)

	docs_from_dir(${MY_PUBLIC_HEADER_DIR})
endmacro(docs_from_lib)

macro(docs_from_dir source_dir)
	set(MY_PUBLIC_HEADER_DIR "${source_dir}")

	file(GLOB_RECURSE MY_PUBLIC_HEADERS ${MY_PUBLIC_HEADER_DIR}/*.hh)
	# debug_print_list_value(MY_PUBLIC_HEADER_DIR)
	# debug_print_value(PROJECT_SOURCE_DIR)

	# set(DOXYGEN_INPUT_DIR ${PROJECT_SOURCE_DIR} )
	set(DOXYGEN_INPUT_DIR ${PROJECT_SOURCE_DIR}/libs/${PRJ_CXX_NAME})

	# set(DOXYGEN_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/docs/doxygen)
	set(DOXYGEN_OUTPUT_DIR ${DOCS_SRC_DIR}/../bin/doxygen)
	set(DOXYGEN_INDEX_FILE ${DOXYGEN_OUTPUT_DIR}/html/index.html)
	set(DOXYFILE_IN ${DOCS_SRC_DIR}/${PRJ_CXX_NAME}.in.doxygen)
	set(DOXYFILE_OUT ${DOCS_BIN_DIR}/Doxyfile)
	message("    [doxygen] DOCS_SRC_DIR = ${DOCS_SRC_DIR}...")

	# Replace variables inside @@ with the current values
	configure_file(${DOXYFILE_IN} ${DOXYFILE_OUT} @ONLY)

	file(MAKE_DIRECTORY ${DOXYGEN_OUTPUT_DIR}) # Doxygen won't create this for us
	add_custom_command(OUTPUT ${DOXYGEN_INDEX_FILE}
		DEPENDS ${MY_PUBLIC_HEADERS}
		COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE_OUT}

		# COMMAND
		# $<$<CONFIG:Release>:${DOXYGEN_EXECUTABLE} ${DOXYFILE_OUT}>
		# $<$<NOT:$<CONFIG:Release>>:${CMAKE_COMMAND} -E "echo 'Only done in Release builds'">
		MAIN_DEPENDENCY ${DOXYFILE_OUT} ${DOXYFILE_IN}
		COMMENT "Generating docs"
		VERBATIM)

	add_custom_target(Doxygen ALL DEPENDS ${DOXYGEN_INDEX_FILE})

	install(DIRECTORY ${DOXYGEN_OUTPUT_DIR}/html DESTINATION share/doc)
endmacro(docs_from_dir)

endif()

macro(attach_doxygen_to target)
	if(BUILD_DOCUMENTATION AND CMAKE_BUILD_TYPE MATCHES "^[Rr]elease")
		add_dependencies(${target} Doxygen)
	endif()
endmacro()

docs_from_dir(${CMAKE_SOURCE_DIR}/include/${PRJ_CXX_NAME})
# docs_from_lib(${PRJ_OSN})
attach_doxygen_to(${PRJ_OSN})
