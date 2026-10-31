"""An OpenSCAD toolchain, so builds can use a pinned OpenSCAD instead of the host's.

The rules of scad.bzl use the toolchain of type `@rules_openscad//:toolchain_type`
when one is registered, and the `openscad` on the host's PATH otherwise.
"""

OPENSCAD_TOOLCHAIN_TYPE = "@rules_openscad//:toolchain_type"

OpenscadInfo = provider(
    doc = "An OpenSCAD binary and what it needs at run time.",
    fields = {
        "openscad": "FilesToRunProvider: the openscad executable.",
        "runfiles": "runfiles: what the executable needs to run, for tests.",
    },
)

def _openscad_toolchain_impl(ctx):
    openscad = ctx.attr.openscad[DefaultInfo]
    runfiles = ctx.runfiles(files = ctx.files.data).merge(openscad.default_runfiles)
    return [platform_common.ToolchainInfo(
        openscad = OpenscadInfo(openscad = openscad.files_to_run, runfiles = runfiles),
    )]

openscad_toolchain = rule(
    implementation = _openscad_toolchain_impl,
    attrs = {
        "openscad": attr.label(
            mandatory = True,
            executable = True,
            cfg = "exec",
            doc = "The openscad executable.",
        ),
        "data": attr.label_list(
            allow_files = True,
            cfg = "exec",
            doc = "Files openscad needs at run time: its libraries, fonts and the like.",
        ),
    },
    doc = """
An OpenSCAD toolchain. Declare one, and register it, to build with a pinned
OpenSCAD instead of the one on the host's PATH:

```
load("@rules_openscad//:toolchain.bzl", "openscad_toolchain")

openscad_toolchain(
    name = "my_openscad_impl",
    openscad = "@my_openscad//:bin/openscad",
    data = ["@my_openscad//:all_files"],
)

toolchain(
    name = "my_openscad",
    toolchain = ":my_openscad_impl",
    toolchain_type = "@rules_openscad//:toolchain_type",
)
```

and in MODULE.bazel, `register_toolchains("//:my_openscad")`.
""",
)
