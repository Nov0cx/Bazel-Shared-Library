load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_import", "cc_library")

names = ["%.dll", "lib%.so", "lib%.dylib"]

def is_windows(ctx):
    windows_constraint = ctx.attr._windows_constraint[platform_common.ConstraintValueInfo]
    if ctx.target_platform_has_constraint(windows_constraint):
        return True
    return False

def is_linux(ctx):
    linux_constraint = ctx.attr._linux_constraint[platform_common.ConstraintValueInfo]
    if ctx.target_platform_has_constraint(linux_constraint):
        return True
    return False

def is_macos(ctx):
    macos_constraint = ctx.attr._macos_constraint[platform_common.ConstraintValueInfo]
    if ctx.target_platform_has_constraint(macos_constraint):
        return True
    return False

def dynamic_library(
        name,
        srcs = [],
        deps = [],
        hdrs = [],
        visibility = None,
        strip_include_prefix = "",
        **kwargs):
    """A simple windows_dll_library rule for builing a DLL Windows."""
    dll_name_ = ""
    if (is_windows):
        dll_name_ = names[0].replace("%", name)
    elif (is_linux):
        dll_name_ = names[1].replace("%", name)
    elif (is_macos):
        dll_name_ = names[2].replace("%", name)
    else:
        fail("Unsupported platform")
    dll_name = str(dll_name_)
    import_lib_name = name + "_import_lib"
    import_target_name = name + "_dll_import"

    # Build the shared library
    cc_binary(
        name = dll_name,
        srcs = srcs + hdrs,
        deps = deps,
        linkshared = 1,
        **kwargs
    )

    # Get the import library for the dll
    native.filegroup(
        name = import_lib_name,
        srcs = [":" + dll_name],
        output_group = "interface_library",
    )

    # Because we cannot directly depend on cc_binary from other cc rules in deps attribute,
    # we use cc_import as a bridge to depend on the dll.
    cc_import(
        name = import_target_name,
        interface_library = ":" + import_lib_name,
        shared_library = ":" + dll_name,
        hdrs = hdrs,
    )

    # Create a new cc_library to also include the headers needed for the shared library
    cc_library(
        name = name,
        hdrs = hdrs,
        visibility = visibility,
        deps = deps + [
            ":" + import_target_name,
        ],
        strip_include_prefix = strip_include_prefix,
    )