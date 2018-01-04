import iopipe.zip;
import iopipe.stream;
import iopipe.bufpipe;
import std.range;
import std.datetime.stopwatch;
import std.string;
import std.stdio;
import std.experimental.allocator.mallocator;

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
    version (Appender)
    {
        return "appender";
    }
    else
    {
        return "direct";
    }
}

struct Output
{
    auto data = appender!(ubyte[]);
    size_t write(const(ubyte)[] newData)
    {
        data.put(newData);
        return newData.length;
    }

    size_t written()
    {
        return data.data.length;
    }
}

string compiler()
{
    version (DigitalMars)
    {
        return "dmd";
    }
    version (LDC)
    {
        return "ldc";
    }
}

void main()
{
    // decompress the input into the output
    auto sw = StopWatch(AutoStart.yes);
    auto pipe = openDev("../out/nist/2011.json.gz").bufd.unzip!Mallocator(CompressionFormat.gzip);
    version (Appender)
    {
        Output o;
        pipe.outputPipe(o).process();
        "- Dlang-iopipe(%s, %s, %s): Decompressing took %s ms to %s bytes".format(versions(),
                boundsCheck(), compiler(), sw.peek.total!("msecs"), o.data.data.length).writeln;
    }
    else
    {
        pipe.ensureElems();
        "- Dlang-iopipe(%s, %s, %s): Decompressing took %s ms to %s bytes".format(versions(),
                boundsCheck(), compiler(), sw.peek.total!("msecs"), pipe.window.length).writeln;
    }
}
