const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const xmega = std.Target.Query{
        .cpu_arch = .avr,
        .cpu_model = .{ .explicit = &std.Target.avr.cpu.atxmega256a3bu },
        .os_tag = .freestanding,
        .abi = .none,
        .ofmt = .elf,
    };
    //const target = b.standardTargetOptions(.{});
    //const optimize = b.standardOptimizeOption(.{});

    //const lib = b.addStaticLibrary(.{
    //    .name = "zig-asf",
    //    .root_source_file = b.path("src/root.zig"),
    //    .target = b.resolveTargetQuery(xmega),
    //    .optimize = optimize,
    //});
    //b.installArtifact(lib);

    //const lib_unit_tests = b.addTest(.{
    //    .root_source_file = b.path("src/root.zig"),
    //    .target = b.standardTargetOptions(.{}),
    //    .optimize = .Debug,
    //});
    //const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    //const test_step = b.step("test", "Run unit tests");
    //test_step.dependOn(&run_lib_unit_tests.step);

    const app = b.addExecutable(.{
        .name = "app",
        .root_source_file = b.path("src/_start.zig"),
        .target = b.resolveTargetQuery(xmega),
        .optimize = .ReleaseSmall,
    });

    app.setLinkerScriptPath(b.path("linker.ld"));

    b.installArtifact(app);
}
