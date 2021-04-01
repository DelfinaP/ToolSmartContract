package tool;

import java.io.*;
import java.util.ArrayList;
import java.util.Scanner;

public class Csv {

    static String contractAddress = "";
    static ArrayList<String> contractAddresses = new ArrayList<String>();

    //legge il csv e ci restituisce un arrayList di contratti
    public static ArrayList<String> getContractAddresses() {

        String fileName = "..\\smart-contract\\src\\dates\\csv_disponibili.csv";
        File file = new File(fileName);

        try {
            Scanner inputStream = new Scanner(file);
            inputStream.next();

            while (inputStream.hasNext()) {
                String data = inputStream.next();
                String[] values = data.split(",");
                contractAddress = values[1];
                //System.out.println(contractAddress);
                contractAddresses.add(contractAddress);
            }
        }catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        return contractAddresses;
    }

    //per ogni contratto crea una cartella
    public static  void createDir(){
       String basePath = "..\\smart-contract\\src\\source_code";

        getContractAddresses();

        contractAddresses.forEach(contractAddressElement -> {
            new File(basePath, contractAddressElement).mkdir();
        });
    }
}
