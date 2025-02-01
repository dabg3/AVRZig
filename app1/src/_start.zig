const asf = @import("root.zig");

// A common task performed by start is to configure
// the program segments (stack, global data, heap) and call the main function
pub export fn _start() noreturn {
    // 1. set SP
    // Stack pointer is already set!
    // From section 3.8 of XMEGA AU Manual:
    //  The SP is automatically loaded after reset,
    //  the initial value is the highest address of the internal SRAM

    // TODO initialize properly
    // copy_program_data_to_ram();

    // clear_bss();

    // TODO WRITE A BETTER API
    const led012Flags = asf.ioport.PinFlags{ .init = false };
    // base + (portID * port_offset)
    // portR == 15 (portID)
    const portR: *u8 = @ptrFromInt(0x600 + (15 * 0x20));
    // 1 means pin 0 -> 00000001
    asf.ioport.configure_port_pin(portR, 1, led012Flags);

    // call main
    while (true) {}
}

fn copy_program_data_to_ram() void {
    // load Z with the address of data in flash memory to be copied
    // load X with the first address in RAM where data should be written
    // load somewhere the last available RAM address

    // copy from Z to X till last RAM address
}

fn clear_bss() void {
    // write zeros
}
