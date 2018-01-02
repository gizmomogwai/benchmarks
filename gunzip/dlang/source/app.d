
int main(string[] args)
{
    import std.datetime.stopwatch;
    import std.stdio;
    import std.string;
    import std.file;
    import std.zlib;
    import std.array;

    auto sw = StopWatch(AutoStart.yes);
    auto bytes = cast(ubyte[])read("../out/nist/2011.json.gz");
    auto uncompress = new UnCompress;
    auto res = appender!(string);
    res.put(cast(string)uncompress.uncompress(bytes));
    res.put(cast(string)uncompress.flush);
    "- Dlang: Decompressing took %s ms to %s bytes".format(sw.peek.total!("msecs"), res.data.length).writeln;
    return 0;
}
