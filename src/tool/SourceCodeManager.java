package tool;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import library.org.json.*;

public class SourceCodeManager {

    private HttpURLConnection connection;
    private CsvManager csvManager = new CsvManager();

    private URL url = null;

    public SourceCodeManager(){

    }

    public void sendGetRequest() {

        String apiKey = utils.JsonUtils.getApiKey();

        //address di prova
        //String address = "0x7E9D8f07A64e363e97A648904a89fb4cd5fB94CD";

        csvManager.getContractAddresses().forEach(contractAddressElement -> {

            try {
                url = new URL("https://api.etherscan.io/api?module=contract&action=getsourcecode&address=" + contractAddressElement + "&apikey=" + apiKey);

                connection = (HttpURLConnection) url.openConnection();

                // setup richiesta
                connection.setRequestMethod("GET");
                connection.setConnectTimeout(5000);
                connection.setReadTimeout(5000);

                if (connection.getResponseCode() == 200){
                    JSONTokener tokener = new JSONTokener(url.openStream());
                    JSONObject response = new JSONObject(tokener);

                    String jKey = getSourceCode(response);

                    writeFileSol(contractAddressElement, jKey);

                } else {
                    System.out.println("Errore");
                    //todo
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

    private void writeFileSol(String contractAddress, String jKey) {

            String path = "..\\smart-contract\\src\\source_code\\" + contractAddress + ".sol";
            File file = new File(path);
            FileWriter fw = null;
            try {
                fw = new FileWriter(file);
                fw.write(jKey);
                fw.flush();
                fw.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
    }

    private String getSourceCode(JSONObject jsonObject){

        //recupero result che è un array e prendo il primo element
        JSONObject jResult = new JSONObject(jsonObject.getJSONArray("result").get(0).toString());
        //System.out.println(jResult);
        //prendo la jkey
        String jKey = String.valueOf(jResult.get("SourceCode"));

        return jKey;
    }
}

