"""Analysis tests of the optional OpenSCAD toolchain."""

load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")

def _fake_openscad_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(out, "#!/bin/sh\nexit 1\n", is_executable = True)
    return [DefaultInfo(executable = out)]

# An executable that stands in for openscad; the tests only analyze.
fake_openscad = rule(implementation = _fake_openscad_impl, executable = True)

def _with_toolchain_impl(ctx):
    env = analysistest.begin(ctx)
    actions = [a for a in analysistest.target_actions(env) if a.mnemonic == "OpenScad"]
    asserts.equals(env, 1, len(actions), "one OpenScad action")
    if actions:
        asserts.true(env, actions[0].argv[0].endswith("toolchain/fake_openscad"),
                     "the action runs the toolchain's openscad, not %s" % actions[0].argv[0])
        asserts.equals(env, ["--export-format=stl", "-o"], actions[0].argv[1:3])
    return analysistest.end(env)

uses_toolchain_test = analysistest.make(
    _with_toolchain_impl,
    config_settings = {
        "//command_line_option:extra_toolchains": [str(Label("//toolchain:fake_toolchain"))],
    },
)

def _without_toolchain_impl(ctx):
    env = analysistest.begin(ctx)
    mnemonics = [a.mnemonic for a in analysistest.target_actions(env)]
    asserts.false(env, "OpenScad" in mnemonics, "no toolchain: the host's openscad, as before")
    return analysistest.end(env)

uses_host_test = analysistest.make(_without_toolchain_impl)
