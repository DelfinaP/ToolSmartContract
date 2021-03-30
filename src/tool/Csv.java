package tool;

//import org.apache.commons.io.FileUtils;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Scanner;

public class Csv {

    static String contractAddress = "";
    static ArrayList<String> contractAddresses = new ArrayList<String>();

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

    public static  void createDir(){
       String basePath = "..\\smart-contract\\src\\source_code";

        getContractAddresses();

        contractAddresses.forEach(contractAddressElement -> {
            new File(basePath, contractAddressElement).mkdir();
        });


    }
}
