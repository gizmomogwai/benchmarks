import std.stdio;
import etc.c.zlib;
import std.range;
import std.array;
import std.string;
import std.datetime.stopwatch;

string boundsCheck()
{
    version (D_NoBoundsChecks)
    {
        return "noboundscheck";
    }
    else
    {
        return "boundscheck";
    }
}

string versions()
{
    version (FastAppender)
        return "fastappender";
    version (Normal)
        return "appender";
    version (NoCopy)
        return "nocopy";
}

class FastAppender(T)
{
    T[] data;
    size_t offset;
    this()
    {
        data = new T[4096];
        offset = 0;
    }

    T[] reserve(size_t space)
    {
        while (data.length - offset < space)
        {
            data.length *= 2;
        }
        return data[offset .. $];
    }

    void consume(size_t space)
    {
        offset += space;
    }

    T[] total()
    {
        return data[0 .. offset];
    }
}

void main()
{
    auto sw = StopWatch(AutoStart.yes);

    auto gzip = gzopen("../out/nist/2011.json.gz", "rb");
    scope (exit)
        gzclose(gzip);

    version (FastAppender)
    {
        auto appender = new FastAppender!ubyte;

        do
        {
            auto buffer = appender.reserve(4096);
            auto res = gzread(gzip, buffer.ptr, cast(uint) buffer.length);
            appender.consume(res);
            if (res == 0)
                break;
        }
        while (true);
        "- Dlang-lowlevel(%s, %s): Decompression took %s ms to %s bytes".format(versions(),
                boundsCheck(), sw.peek.total!("msecs"), appender.total.length).writeln;
    }
    version (Normal)
    {
        ubyte[4096] buffer;
        auto res = gzread(gzip, buffer.ptr, buffer.length);
        auto uncompressed = appender!(ubyte[]);
        while (res > 0)
        {
            uncompressed.put(buffer[0 .. res]);
            res = gzread(gzip, buffer.ptr, buffer.length);
        }
        "- Dlang-lowlevel(%s, %s): Decompression took %s ms to %s bytes".format(versions(),
                boundsCheck(), sw.peek.total!("msecs"), uncompressed.data.length).writeln;
    }

    version (NoCopy)
    {
        int total = 0;
        ubyte[4096] buffer;
        do
        {
            auto res = gzread(gzip, buffer.ptr, buffer.length);
            total += res;
            if (res == 0)
                break;
        }
        while (true);
        "- Dlang-lowlevel(%s, %s): Decompression took %s ms to %s bytes".format(versions(),
                boundsCheck(), sw.peek.total!("msecs"), total).writeln;

    }
}
