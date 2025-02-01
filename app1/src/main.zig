const hw = @import("atxmega256a3bu.zig");
const PORTD = hw.devices.ATxmega256A3BU.peripherals.PORTD;
const PORTR = hw.devices.ATxmega256A3BU.peripherals.PORTR;

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

pub fn main() void {
    // The yellow LEDs (PR0, PR1) and the red LED (PD4) can be
    // activated by driving the connected I/O line to GND.

    // activating PR0/1
    const pin01_bitmask: u8 = 0x3;
    PORTR.DIR = pin01_bitmask;
    PORTR.OUT = ~pin01_bitmask;
}
