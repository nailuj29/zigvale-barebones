const std = @import("std");
const pkgs = @import("deps.zig").pkgs;

pub fn build(b: *std.build.Builder) void {
    const kernel = b.addExecutable("kernel.elf", "src/main.zig");

    pkgs.addAllTo(kernel);
    kernel.addPackagePath("terminal", "lib/terminal.zig");

    kernel.setOutputDir("build");

    kernel.setBuildMode(b.standardReleaseOptions());

    const features = std.Target.x86.Feature;

    var disabled = std.Target.Cpu.Feature.Set.empty;    
    disabled.addFeature(@enumToInt(features.mmx));
    disabled.addFeature(@enumToInt(features.sse));
    disabled.addFeature(@enumToInt(features.sse2));
    disabled.addFeature(@enumToInt(features.avx));
    disabled.addFeature(@enumToInt(features.avx2));

    var enabled = std.Target.Cpu.Feature.Set.empty;  
    enabled.addFeature(@enumToInt(features.soft_float));


    kernel.setTarget(std.zig.CrossTarget {
        .cpu_arch = std.Target.Cpu.Arch.x86_64,
        .os_tag = std.Target.Os.Tag.freestanding,
        .abi = std.Target.Abi.none,
        .cpu_features_sub = disabled,
        .cpu_features_add = enabled,
    });

    kernel.setLinkerScriptPath(.{.path="./linker.ld"});

    kernel.install();

    b.default_step.dependOn(&kernel.step);
}