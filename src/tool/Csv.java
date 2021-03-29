package tool;

import org.apache.commons.io.FileUtils;
import java.io.*;
import java.util.Scanner;

public class Csv {

    static String contractAddress = "";
    static String[] contractAddresses = null;

    public static void getContractAddress() {

        String fileName = "..\\smart-contract\\src\\\\dates\\csv_disponibili.csv";
        File file = new File(fileName);

        try {
            Scanner inputStream = new Scanner(file);
            inputStream.next();

            while (inputStream.hasNext()) {
                String data = inputStream.next();
                String[] values = data.split(",");
                contractAddress = values[1];
                contractAddresses = ArrayUtils.add(contractAddresses, contractAddress);
            }
        }catch (FileNotFoundException e) {
                e.printStackTrace();
            }

        /*String path = "..\\smart-contract\\src\\dates\\csv_disponibili.csv";
        String line = "";
        int i = 0;

        try {
            BufferedReader br = new BufferedReader(new FileReader(path));

            while ((line = br.readLine()) != null){

                //System.out.println(line);
                String[] row = line.split(",");
                contractAddress = row[1];

                System.out.println(row[1]);

                *//*for (String index : row){
                    contractAddresses[i] = contractAddress;
                }

                System.out.println(contractAddresses[i]);*//*

            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }*/



        //public static void createDir(){

        //for (int i = 1; i < getContractAddress(); i++){
            //System.out.println(getContractAddress());
       // }
    }
}
