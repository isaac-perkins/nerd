
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Set;
import org.apache.tika.config.TikaConfig;
import org.apache.tika.exception.TikaException;
import org.apache.tika.io.TikaInputStream;
import org.apache.tika.metadata.Metadata;
import org.apache.tika.mime.MediaType;
import org.apache.tika.parser.ParseContext;
import org.apache.tika.parser.AbstractParser;
import org.apache.tika.parser.AutoDetectParser;
import org.apache.tika.sax.BodyContentHandler;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;

public class TikaParser extends AbstractParser {

	/**
	* 
	*/
	private static final long serialVersionUID = 1;

	/*
	 * public void parse( InputStream stream, ContentHandler handler, Metadata
	 * metadata, ParseContext context) throws IOException, SAXException,
	 * TikaException {
	 * 
	 * 
	 * }
	 */
	@SuppressWarnings("deprecation")
	public static String parseUsingAutoDetect(String filename) throws Exception {

		//System.out.println("Handling using AutoDetectParser: [" + filename + "]");

		TikaConfig tikaConfig = TikaConfig.getDefaultConfig();

		// tikaConfig.
		Metadata metadata = new Metadata();
		AutoDetectParser parser = new AutoDetectParser(tikaConfig);
		ContentHandler handler = new BodyContentHandler();

		File file = new File(filename);
		
		try {
			TikaInputStream stream = TikaInputStream.get(file, metadata);
			parser.parse(stream, handler, metadata, new ParseContext());
			return handler.toString();
		} catch(Exception e) {
			System.out.println("Parse Error: " + e.getMessage());
		}
		return "";

	}

	@Override
	public void parse(InputStream arg0, ContentHandler arg1, Metadata arg2, ParseContext arg3)
			throws IOException, SAXException, TikaException {

	}

	@Override
	public Set<MediaType> getSupportedTypes(ParseContext arg0) {
		return null;
	}

}
