# AVR

Tinkering...

## Flash

`sudo avrdude -c flip2 -p x256a3bu -U application:w:zig-out/bin/app:e`

## ZIG notes


> Just to be clear, you can in fact use most of the standard library. 
> But the cross platform OS abstractions lack Arduino support, 
> so it would be a compile error currently to, for example, open a file.
>
> -- <cite>[Arduino (AVR) support? - Github](https://github.com/ziglang/zig/issues/3637)</cite>

## Resources

http://cs107e.github.io/guides/gcc/
