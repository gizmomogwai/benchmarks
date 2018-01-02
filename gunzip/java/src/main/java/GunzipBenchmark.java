import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.zip.GZIPInputStream;

public class GunzipBenchmark {
    public static void main(String[] args) throws Exception {
        long startTime = System.currentTimeMillis();
        InputStream in = new GZIPInputStream(new FileInputStream("../out/nist/2011.json.gz"));
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        copy(in, out);
        long endTime = System.currentTimeMillis();
        System.out.println(String.format("- Java: Decompressing took %s ms to %s bytes", (endTime - startTime), out.toByteArray().length));
    }

    private static void copy(InputStream in, ByteArrayOutputStream out) throws Exception {
        byte[] buffer = new byte[4096];
        int read = in.read(buffer);
        while (read != -1) {
            out.write(buffer, 0, read);
            read = in.read(buffer);
        }
    }
}
