MEMORY
{
        APP_FLASH (rx) : ORIGIN = 0, LENGTH = 0x40000
        DATA_SRAM (rw) : ORIGIN = 0x2000, LENGTH = 0x4000
}

SECTIONS {
        .text :
        {
                *(.text*)
        } > APP_FLASH

        .data :
        {
                __data_start = .;
                *(.rodata*)
                *(.data*)
                __data_end = .;
        } > DATA_SRAM AT> APP_FLASH

        .bss (NOLOAD) :
        {
                __bss_start = .;
                *(.bss*)
                __bss_end = .;
        } > DATA_SRAM

        __data_load_start = LOADADDR(.data);
}
