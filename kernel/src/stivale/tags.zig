const zigvale = @import("zigvale").v2;

const term_tag = zigvale.Header.TerminalTag{
    .callback = 0,
    .flags = .{
        .callback = 0,
        .zeros = 0
    }
};

pub const fb_tag = zigvale.Header.FramebufferTag{
    .tag = .{ .next = &term_tag.tag, .identifier = .framebuffer },
    .width = 0,
    .height = 0,
    .bpp = 0,
};