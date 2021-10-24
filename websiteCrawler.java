import java.io.*;
import java.util.HashSet;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

public class websiteCrawler {
    public static void main(String a[]){
        getDefinition(a[1]);
    }

    static String getDefinition(String word){
        try {
            word = word.replace(" ", "-");
            String BASE_URL = "https://www.dictionary.com/e/slang/WORD/";
            //Change this to the directory where companies.txt will be saved

            URL obj = new URL(BASE_URL.replace("WORD", word));
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();
            con.setRequestMethod("GET");
            String str="";
            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            StringBuilder response = new StringBuilder();
            while((str = in.readLine())!=null){
                response.append(str);
            }
            //System.out.println(response.toString());
            str = response.toString();
            int index = str.indexOf("mean?");
            str = str.substring(str.indexOf("<p>", index), str.indexOf("</p>", index)).replace("\n"," ");
            str = str.replaceAll("&#8220;", "\"");
            str = str.replaceAll("&#8221;", "\"");
            str = str.replaceAll("&#8217;", "\'");
            str = str.replaceAll("&#8216;", "\'");
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < str.length(); i++) {
              if (str.charAt(i) == '<') {
                while (str.charAt(i) != '>')
                  i++;
                i++;
              }
              if (i >= str.length()) break;
              if (str.charAt(i) == '<')
                i--;
              sb.append(str.charAt(i));
            }
            System.out.println(sb.toString().replaceAll(">",""));
            return str;
        }catch (Exception e){
            System.out.println("Not slang");
        }
        return null;
    }

}
