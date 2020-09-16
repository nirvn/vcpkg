include(vcpkg_common_functions)

vcpkg_download_distfile(ARCHIVE
    URLS "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.12.0/QScintilla_src-2.12.0.tar.gz"
    FILENAME "QScintilla-2.12.0.tar.gz"
    SHA512 9bdaba5c33c1b11ccad83eb1fda72142758afc50c955a62d5a8ff102b41d4b67d897bf96ce0540e16bc5a7fae2ce1acbf06931d5f0ae6768759c9ff072c03daa
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    PATCHES
        fix-static.patch
)

vcpkg_find_acquire_program(PYTHON3)

# Add python3 to path
get_filename_component(PYTHON_PATH ${PYTHON3} DIRECTORY)
vcpkg_add_to_path(PREPEND ${PYTHON_PATH})
vcpkg_add_to_path(${CURRENT_INSTALLED_DIR}/bin)
vcpkg_add_to_path(${CURRENT_INSTALLED_DIR}/debug/bin)

vcpkg_configure_qmake(
    SOURCE_PATH ${SOURCE_PATH}/src
    OPTIONS
        CONFIG+=build_all
        CONFIG-=hide_symbols
        DEFINES+=SCI_NAMESPACE
)

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_install_qmake(
        RELEASE_TARGETS release
        DEBUG_TARGETS debug
    )
else()
    vcpkg_install_qmake()
endif()

file(GLOB HEADER_FILES ${SOURCE_PATH}/src/Qsci/*)
file(COPY ${HEADER_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include/Qsci)

vcpkg_copy_pdbs()

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/qscintilla)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/qscintilla/LICENSE ${CURRENT_PACKAGES_DIR}/share/qscintilla/copyright)
