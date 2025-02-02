const std = @import("std");
const hw = @import("atxmega256a3bu.zig");
const PORTR = hw.devices.ATxmega256A3BU.peripherals.PORTR;
// header J1
const PORTC = hw.devices.ATxmega256A3BU.peripherals.PORTC;
const USART = hw.devices.ATxmega256A3BU.peripherals.USARTC0;
const CLK = hw.devices.ATxmega256A3BU.peripherals.CLK;
const OSC = hw.devices.ATxmega256A3BU.peripherals.OSC;
const DFLL = hw.devices.ATxmega256A3BU.peripherals.DFLLRC2M;

// The yellow LEDs (PR0, PR1) and the red LED (PD4) can be
// activated by driving the connected I/O line to GND.

// Each port has:
//
//  data direction (DIR) register
//      DIRn bit set direction of pin n
//      0 -> input, 1 -> output
//
//  data output value (OUT) register
//      when DIRn = 1, OUTn bit set value of pin n
//      0 -> driven low, 1 -> driven high
//
//  data input value (IN) for reading pins
//      always readable unless digital output is disabled
//      INn bit reads pin n
//
//  pin configuration register (PINnCTRL) for each pin
//      I/O configurations options
//          totem-pole
//          wired-AND
//          wired-OR
//          inverted input/output
//
//          totem-pole pull-up/pull-down have active resistors only when the pin is set as input
//          wired-AND/OR pull-up/pull-down always have active resistors

fn mask(comptime pin: u8) u8 {
    return 1 << pin;
}

pub fn main() void {
    clock_configure(CLK, OSC, DFLL);

    // activating PR0/1
    led_on(PORTR, mask(0));

    uart_configure(PORTC, USART);

    const message = [_]u8{48}; // ascii 0
    while (true) {
        uart_write(&message);
    }
}

fn crappy_delay() void {
    for (0..std.math.maxInt(usize)) |i| {
        _ = i;
    }
}

fn led_toggle(
    port: *volatile hw.types.peripherals.PORT,
    pinmask: u8,
) void {
    port.OUTTGL = pinmask;
}

fn led_on(
    port: *volatile hw.types.peripherals.PORT,
    pinmask: u8,
) void {
    port.DIR |= pinmask;
    port.OUTCLR = pinmask;
}

fn clock_configure(
    clk: *volatile hw.types.peripherals.CLK,
    osc: *volatile hw.types.peripherals.OSC,
    dfll: *volatile hw.types.peripherals.DFLL,
) void {
    // When a reset occurs, all clock sources except the 32kHz ultra low power oscillator are disabled.
    // After reset, the device runs from the 2MHz internal oscillator.
    // Scale system clock (2MHz) by 16 to get 32Mhz for peripherals
    clk.PSCTRL.modify(.{ .PSADIV = .@"16" });
    // Enable 32KHz oscillator and use it for DFLL
    osc.CTRL.modify(.{ .RC32KEN = 1 });
    while (osc.STATUS.read().RC32KRDY != 1) {}
    dfll.CTRL.modify(.{ .ENABLE = 1 });
}

fn uart_configure(
    port: *volatile hw.types.peripherals.PORT,
    usart: *volatile hw.types.peripherals.USART,
) void {
    // USART initialization should use the following sequence:
    //  1. Set the TxD pin (PC3 on J1) value high, and optionally set the XCK pin low.
    port.OUT = mask(3);
    //  2. Set the TxD and optionally the XCK pin as output.
    port.DIR = mask(3);
    //  3. Set the baud rate and frame format
    //      From section 23.9 of XMEGA AU Manual:
    //      BSEL = 131, BSCALE = -3 -> 115.2k bits per second (CLKper@32mhz)
    const bsel: u12 = 131;
    usart.BAUDCTRLA.write(.{
        .BSEL = bsel & 0xff,
    });
    usart.BAUDCTRLB.write(.{
        .BSEL = bsel & 0xf00,
        .BSCALE = 0xd, // -3 two's complement
    });
    usart.CTRLC.write(.{
        .CHSIZE = .@"8BIT",
        .SBMODE = 0,
        .PMODE = .DISABLED,
        .CMODE = .ASYNCHRONOUS,
    });
    //  5. Enable the transmitter or the receiver, depending on the usage
    usart.CTRLB.modify(.{
        .TXEN = 1,
    });
}

fn uart_write(data: []const u8) void {
    // The transmit buffer can be written only when DREIF in the STATUS register is set.
    // Otherwise it is ignored.
    for (data) |b| {
        while (USART.STATUS.read().DREIF != 1) {}
        USART.DATA = b;
    }
    while (USART.STATUS.read().TXCIF != 1) {}
}
