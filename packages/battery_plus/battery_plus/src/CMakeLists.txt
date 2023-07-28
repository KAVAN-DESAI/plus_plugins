# jni_native_build (Build with jni:setup. Do not delete this line.)

# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(battery_plus_plugin_bindings VERSION 0.0.1 LANGUAGES C)

add_library(battery_plus_plugin_bindings SHARED
  "./battery_plus_plugin_bindings.c"
)

set_target_properties(battery_plus_plugin_bindings PROPERTIES
  OUTPUT_NAME "battery_plus_plugin_bindings"
)

target_compile_definitions(battery_plus_plugin_bindings PUBLIC DART_SHARED_LIB)

if(WIN32)
	set_target_properties(${TARGET_NAME} PROPERTIES
		LINK_FLAGS "/DELAYLOAD:jvm.dll")
endif()

if (ANDROID)
	target_link_libraries(battery_plus_plugin_bindings log)
else()
	find_package(Java REQUIRED)
	find_package(JNI REQUIRED)
	include_directories(${JNI_INCLUDE_DIRS})
	target_link_libraries(battery_plus_plugin_bindings ${JNI_LIBRARIES})
endif()
