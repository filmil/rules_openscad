load("@rules_python//python:defs.bzl", "py_binary", "py_library")

py_library(
    name = "scad_utils",
    srcs = ["scad_utils.py"],
)

py_binary(
    name = "scad_unittest",
    srcs = ["scad_unittest.py"],
    python_version = "PY3",
    visibility = ["//visibility:public"],
    deps = [
        ":scad_utils",
    ],
)

py_binary(
    name = "scad_render",
    srcs = ["scad_render.py"],
    python_version = "PY3",
    visibility = ["//visibility:public"],
    deps = [
        ":scad_utils",
    ],
)

exports_files([
    "scad.bzl",
    "toolchain.bzl",
])

# The type of the optional OpenSCAD toolchain (toolchain.bzl).
toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)
