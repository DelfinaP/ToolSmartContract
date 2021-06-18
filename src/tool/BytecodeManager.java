package tool;


import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import utils.FileUtils;
import utils.JsonUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

public class BytecodeManager {

    String bytecodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "bytecodes_path");

    private HttpURLConnection connection;
    private CsvManager csvManager = new CsvManager();

    private URL url = null;

    public BytecodeManager() {
    }

    public void sendGetRequest() throws IOException {

        //String address = "0x0a8ee230b66e886c5a25ca77ebb0ba796541ff61";

        csvManager.getContractAddresses().forEach(contractAddressElement -> {
            URL url = null;
            HttpURLConnection connection = null;
            try {
                url = new URL("https://etherscan.io/address/" + contractAddressElement + "#code");

                System.out.println(contractAddressElement);

                connection = (HttpURLConnection) url.openConnection();

                connection.setRequestMethod("GET");
                connection.setRequestProperty("User-Agent", "");

                int responseCode = connection.getResponseCode();
                //System.out.println("GET Response Code :: " + responseCode);

                if (responseCode == HttpURLConnection.HTTP_OK) { // success

                    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                    String inputLine;
                    StringBuffer response = new StringBuffer();

                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    System.out.println("response: " + response);

                    String bytecode = getBytecode(response);

                    System.out.println(bytecode);

                    String path = bytecodesPath + contractAddressElement + ".evm";

                    FileUtils.writeFiles(contractAddressElement, bytecode, path);

                    Thread.sleep(5000);

                } else {
                    System.out.println("GET request not worked");
                }

            } catch (ProtocolException e) {
                e.printStackTrace();
            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
    }

    private String getBytecode(StringBuffer allPage) {

        Document doc = Jsoup.parse(allPage.toString());

        String str = doc.getElementById("verifiedbytecode2").ownText();

        return str;
    }

}


