load("@rules_openscad//:scad.bzl", "scad_object")
load("@rules_openscad//:toolchain.bzl", "openscad_toolchain")
load(":toolchain_test.bzl", "fake_openscad", "uses_host_test", "uses_toolchain_test")

fake_openscad(name = "fake_openscad")

openscad_toolchain(
    name = "fake_toolchain_impl",
    openscad = ":fake_openscad",
)

# Registered only by the test below, with --extra_toolchains.
toolchain(
    name = "fake_toolchain",
    toolchain = ":fake_toolchain_impl",
    toolchain_type = "@rules_openscad//:toolchain_type",
)

scad_object(
    name = "cube",
    srcs = ["cube.scad"],
    tags = ["manual"],
)

uses_toolchain_test(
    name = "uses_toolchain_test",
    target_under_test = ":cube",
)

uses_host_test(
    name = "uses_host_test",
    target_under_test = ":cube",
)
