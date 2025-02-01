const asf = @import("root.zig");

pub fn main() void {
    // The yellow LEDs (PR0, PR1) and the red LED can be
    // activated by driving the connected I/O line to GND.
    //
    // configure PIN 0 on PORT R:
    //  DIR0 = 1
    //  PIN0CTRL wired-OR with internal pull-down.
    //  OUT0 = 0
    //
    // TODO WRITE A BETTER API
    const led012Flags = asf.ioport.PinFlags{ .init = false };
    // base + (portID * port_offset)
    // portR == 15 (portID)
    const portR: *u8 = @ptrFromInt(0x600 + (15 * 0x20));
    // 1 means pin 0 -> 00000001
    asf.ioport.configure_port_pin(portR, 1, led012Flags);
}
