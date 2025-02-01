const std = @import("std");
const testing = std.testing;

pub fn create_pin(comptime port: u8, comptime pin: u8) u8 {
    return port * 8 + pin;
}

pub const PinFlags = packed struct(u16) {
    input: bool = false, //false means output
    init: bool = false, //false -> low, true -> high
    _padding: u14 = 0,
};

pub fn configure_port_pin(port: *u8, pin_mask: u8, flags: PinFlags) void {
    if (flags.input) {
        // DIRCLR reg @ 0x02
        compute_pointer(port, 0x02).* = pin_mask;
        return;
    }
    if (flags.init) {
        // OUTSET reg @ 0x05
        compute_pointer(port, 0x05).* = pin_mask;
    } else {
        // OUTSET reg @ 0x06
        compute_pointer(port, 0x06).* = pin_mask;
    }
    // DIRSET reg @ 0x01
    compute_pointer(port, 0x01).* = pin_mask;
}

fn compute_pointer(base: *u8, offset: usize) *u8 {
    const new_address = @intFromPtr(base) + offset;
    return @ptrFromInt(new_address);
}

test "basic add functionality" {
    try testing.expect(create_pin(15, 0) == 120);
}
