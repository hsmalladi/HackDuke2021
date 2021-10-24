import com.google.cloud.functions.HttpFunction;
import com.google.cloud.functions.HttpRequest;
import com.google.cloud.functions.HttpResponse;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import java.util.logging.Logger;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class websiteHTTP implements HttpFunction {
   private static final Logger logger = Logger.getLogger(websiteHTTP.class.getName());

   private static final Gson gson = new Gson();

   @Override
   public void service(HttpRequest request, HttpResponse response)
      throws IOException {
    // Check URL parameters for "name" field
    // "simp" is the default value
      String name = request.getFirstQueryParameter("word").orElse("simp");

    // Parse JSON request and check for "word" field
      try {
         JsonElement requestParsed = gson.fromJson(request.getReader(), JsonElement.class);
         JsonObject requestJson = null;

         if (requestParsed != null && requestParsed.isJsonObject()) {
            requestJson = requestParsed.getAsJsonObject();
         }

         if (requestJson != null && requestJson.has("word")) {
            word = requestJson.get("word").getAsString();
         }
      } catch (JsonParseException e) {
         logger.severe("Error parsing JSON: " + e.getMessage());
      }

      PrintWriter out = response.getWriter();
      response.setContentType("application/json");
      response.setCharacterEncoding("UTF-8");
      String ret = getDefinition(word);
      JSONObject json = new JSONObject();
      if (ret == null) {
         json.put("word", "");
         json.put("definition", "");
      }  else {
         json.put("word", word);
         json.put("definition", ret);
      }
      out.print(json.toString());
      out.flush();

   }


   public static String getDefinition(String word){
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
            if (i >= str.length())
               break;
            if (str.charAt(i) == '<')
               i--;
            sb.append(str.charAt(i));
         }
         return sb.toString();
      }catch (Exception e){
         return null;
      }
   }
}
