

import java.io.File;
import java.io.FileInputStream;
//import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.LinkedHashSet;
import java.util.Set;

import opennlp.tools.namefind.NameFinderME;
import opennlp.tools.namefind.TokenNameFinder;
import opennlp.tools.namefind.TokenNameFinderModel;
import opennlp.tools.sentdetect.SentenceDetectorME;
import opennlp.tools.sentdetect.SentenceModel;
import opennlp.tools.tokenize.Tokenizer;
import opennlp.tools.tokenize.WhitespaceTokenizer;
import opennlp.tools.util.InvalidFormatException;
import opennlp.tools.util.Span;

public class NerName {

	
	private static Set<String> types = new LinkedHashSet<>();
	
	public static String getTypes() {
		String rv = "<types>";
		for (String node :  NerName.types) {       
		    rv += "<type>" + node + "</type>";
		}
		rv += "</types>";
		return rv;	
	}
	
	public static String[] sentences(String content, String consolePath)  throws IOException  {

		InputStream is = new FileInputStream(consolePath + "/lib/en-sent.bin");

		SentenceModel model = new SentenceModel(is);

		SentenceDetectorME sdetector = new SentenceDetectorME(model);

		String sentences[] = sdetector.sentDetect(content);

		return sentences;

	}

	public static String find(TokenNameFinder nameFinderModel, String[] sentences) {
		
		System.out.println("Find..");
		
		
		Integer n = 0;
		String docs = "<document>";   
		
		for (String sentence : sentences) {
			String[] tokens = tokens(sentence);
			n++;
			Span[] names = nameFinderModel.find(tokens);
			for (Span name : names) {
				String sTokens ="";
				for (int i = name.getStart(); i < name.getEnd(); i++) {
					sTokens += tokens[i] + " "; 
				}
				docs += "<entity type=" + "\"" + name.getType() + "\"" + "><![CDATA[" + sTokens + "]]></entity>";
				NerName.types.add(name.getType());
			}
		}
		return docs + "</document>";
	}

	public static String[] tokens(String sentence) {
		Tokenizer tokenizer = WhitespaceTokenizer.INSTANCE;
		String tokens[] = tokenizer.tokenize(sentence);
		return tokens;
	}

	public static TokenNameFinder model(String path) throws InvalidFormatException, IOException {
		File f = new File(path);
		if (f.exists() == true) {
			InputStream modelIn = new FileInputStream(path);	
			TokenNameFinderModel model = new TokenNameFinderModel(modelIn);
			TokenNameFinder nameFinder = new NameFinderME(model);
			return nameFinder;
		} else {
			System.out.println("Model does not exist: " + path);
			return null;
		}
    }
	

   public static void main(String onlpModelPath, String trainingDataFilePath, String[] args) throws IOException {
                   Charset charset = Charset.forName("UTF-8");
                   ObjectStream<String> lineStream = new PlainTextByLineStream(
                                                   new FileInputStream(trainingDataFilePath), charset);
                   ObjectStream<NameSample> sampleStream = new NameSampleDataStream(
                                                   lineStream);
                   TokenNameFinderModel model = null;
                   HashMap<String, Object> mp = new HashMap<String, Object>();
                   try {
                          //         model = NameFinderME.train("en","drugs", sampleStream, Collections.<String,Object>emptyMap(),100,4) ;
                                   model=  NameFinderME.train("en", "drugs", sampleStream, Collections. emptyMap());
                   } finally {
                                   sampleStream.close();
                   }
                   BufferedOutputStream modelOut = null;
                   try {
                                   modelOut = new BufferedOutputStream(new FileOutputStream(onlpModelPath));
                                   model.serialize(modelOut);
                   } finally {
                                   if (modelOut != null)
                                                   modelOut.close();
                   }
   }
	}

}
