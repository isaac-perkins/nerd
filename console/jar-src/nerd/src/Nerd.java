import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Objects;
//import org.apache.commons.lang.StringUtils;
import org.apache.tika.exception.TikaException;

public class Nerd {

	private static String path = null;
	private static String action = null;
	private static String job = null;
	private static String jobDir = null;

	public static void main(String[] args) throws Exception {

		Nerd.appConfig(args);
		String dir = Nerd.action.toLowerCase();
		jobDir = Nerd.path + "/data/" + job;

		if (Objects.equals(Nerd.action.toLowerCase(), "-tokens")) {
			
			Nerd.parseFile(Nerd.job);
		
		} else {
			
			File file = new File(jobDir + "/" + dir.substring(1));
			
			getDirectory(file);
			
			PrintWriter writer = new PrintWriter(jobDir + "/types.xml", "UTF-8");
			writer.println(NerName.getTypes());
			writer.close();
		}
	}

	private static void getDirectory(File path) throws Exception {
		try {
			//File[] files = path.listFiles();
			File[] files = path.listFiles(new FileFilter() {
			    @Override
			    public boolean accept(File pathname) {
			        String name = pathname.getName().toLowerCase();
			        return ((name.endsWith(".xml") && pathname.isFile()) ? false: true);
			    }
			});
			for (File file : files) {
				if (file.isDirectory()) {
					getDirectory(file);
				} else {
					parseFile(file.toString());
				}
			}
		} catch (IOException e) {

		}
	}

	static void parseFile(String filepath) throws Exception {
		try {
			String content = TikaParser.parseUsingAutoDetect(filepath);
			
			String sentences[] = NerName.sentences(content, Nerd.path + "/console/");
			
			switch (Nerd.action.toLowerCase()) {
				case "-tokens":
					Nerd.saveFile(filepath, sentences);
					break;
				case "-training":
					System.out.println("training");
					//NerTrain.train(Nerd.jobDir + "/model.bin", filepath);
					break;
				case "-content":
					//System.out.println(content);
					
					String rv = NerName.find(NerName.model(Nerd.jobDir + "/model.bin"), sentences);
					System.out.println(rv);
					
					File f = new File(filepath);
					System.out.println(Nerd.jobDir + "/result/" + f.getName());
					
					PrintWriter writer = new PrintWriter(Nerd.jobDir + "/result/" + f.getName() + ".xml", "UTF-8");
					writer.println(rv);
					writer.close();
					//System.out.println(rv);
			}
		} catch (TikaException te) {
			System.out.println("tika:" + te.getMessage());
			return;
		}
	}

	private static void saveFile(String path, String[] sentences) throws UnsupportedEncodingException, IOException {
		File file = new File(path);
		String s = null;
		//s = StringUtils.join(sentences, "\n\n");
		s = String.join("\n\n", sentences);
		PrintWriter writer = new PrintWriter(file.getCanonicalPath(), "UTF-8");
		writer.print(s);
		writer.close();
	}

	private static void appConfig(String[] args) {
		Nerd.path = args[0];
		Nerd.action = args[1];
		if (args.length > 1) {
			Nerd.job = args[2];
		}
	}
}
