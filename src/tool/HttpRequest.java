package tool;

import jdk.nashorn.internal.parser.JSONParser;
import netscape.javascript.JSObject;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import library.org.json.*;

public class HttpRequest {

    private static HttpURLConnection connection;
    static StringBuffer responseContent = new StringBuffer();

    public static void sendGetRequest() {

        String apiKey = "J8UVM1FKFHJZXPXXHEKHHX65TK5EU3JXTN";
        String address = "0x7E9D8f07A64e363e97A648904a89fb4cd5fB94CD";

        Csv.getContractAddresses().forEach(contractAddressElement -> {

            BufferedReader reader;
            String line;
            URL url = null;

            try {
                url = new URL("https://api.etherscan.io/api?module=contract&action=getsourcecode&address=" + address + "&apikey=" + apiKey);

                connection = (HttpURLConnection) url.openConnection();

                //System.out.println("URL -> " + url + "\n");

                // setup richiesta
                connection.setRequestMethod("GET");
                connection.setConnectTimeout(5000);
                connection.setReadTimeout(5000);

                int status = connection.getResponseCode();
                //System.out.println(status);
                if (status > 299) {
                    reader = new BufferedReader(new InputStreamReader(connection.getErrorStream()));
                    while ((line = reader.readLine()) != null) {
                        responseContent.append(line);
                    }
                    reader.close();
                } else {
                    reader = new BufferedReader(new InputStreamReader((connection.getInputStream())));
                    while ((line = reader.readLine()) != null) {
                        responseContent.append(line);
                    }
                    reader.close();
                }

                //json
                //creto oggetto json a partire da string
                JSONObject jsonObject = new JSONObject(responseContent.toString());

                //recupero result che è un array e prendo il primo element
                JSONObject jResult = new JSONObject(jsonObject.getJSONArray("result").get(0).toString());
                //System.out.println(jResult);
                //prendo la jkey
                Object jKey = jResult.get("SourceCode");

                String path = "..\\smart-contract\\src\\source_code\\" + address + ".sol";

                File file = new File(path);
                FileWriter fw = null;

                try {
                    fw = new FileWriter(file);
                    fw.write(jKey.toString());
                    fw.flush();
                    fw.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }

            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (ProtocolException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });

    }

    /*public static void writeFileSol() {
        sendGetRequest();

        Csv.getContractAddresses().forEach(contractAddressElement -> {
            String path = "..\\smart-contract\\src\\source_code" + address + ".sol";
            File file = new File(path);
            FileWriter fw = null;
            try {
                fw = new FileWriter(file);
                fw.write(responseContent.toString());
                fw.flush();
                fw.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }*/
}

