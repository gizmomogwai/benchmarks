import iopipe.zip;
import iopipe.stream;
import iopipe.bufpipe;
import std.range;
import std.datetime.stopwatch;
import std.string;
import std.stdio;

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

void main()
{
    // decompress the input into the output
    auto sw = StopWatch(AutoStart.yes);
    Output o;
    auto nbytes = openDev("../out/nist/2011.json.gz").bufd.unzip(CompressionFormat.gzip)
        .outputPipe(o).process();
    "- Dlang-iopipe(%s): Decompressing took %s ms to %s bytes".format(boundsCheck(),
            sw.peek.total!("msecs"), o.data.data.length).writeln;
}
