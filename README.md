# Bazel C++ shared library rule

add to the workspace file:

```python
http_archive(
    name = "bazel_shared_library",
    strip_prefix = "Bazel-Shared-Library-master",
    urls = ["https://github.com/Nov0cx/Bazel-Shared-Library/archive/master.zip"],
)
```

add to the BUILD file:

```python
load("@bazel_shared_library//:dynamic_lib.bzl", "dynamic_library")

dynamic_library(
    name = "my_lib",
    srcs = ["my_lib.cpp"],
    hdrs = ["my_lib.h"],
    visibility = ["//visibility:public"],
    strip_inclue_prefix = "/path/to/my_lib",
)
```

to the destination file:

```python
cc_binary(
    name = "my_bin",
    srcs = ["my_bin.cpp"],
    deps = ["//path/to/my_lib:my_lib"],
)
```

## License

[The Unlicense](https://unlicense.org/)