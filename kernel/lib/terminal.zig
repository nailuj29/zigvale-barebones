var term_write: ?fn([*]const u8, usize) callconv(.C) void = null;

/// Initializes the terminal writing. 
///
/// After this function is called, the `print` function may be called
pub fn init(fun: fn([*]const u8, usize) callconv(.C) void) void {
    term_write = fun;
}

/// Prints to the terminal.
///
/// If `init` has not been called yet, hangs indefinitely
pub fn print(string: []const u8) void {
    if (term_write == null) {
        while (true) {
            asm volatile ("hlt");
        }
    }

    term_write.?(string.ptr, string.len);
}

/// Prints to the terminal, then prints a new line
///
/// If `init` has not been called yet, hangs indefinitely
pub fn println(string: []const u8) void {
    print(string);
    print("\n");
}