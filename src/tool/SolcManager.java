package tool;

import java.io.*;
import java.util.Scanner;

public class SolcManager {

    String sourceCodesPath = "..\\smart-contract\\src\\source_code\\";

    public SolcManager() {
    }
    private static String getFileNameWithoutExtension(File file) {
        String fileName = "";

        try {
            if (file != null && file.exists()) {
                String name = file.getName();
                fileName = name.replaceFirst("[.][^.]+$", "");
            }
        } catch (Exception e) {
            e.printStackTrace();
            fileName = "";
        }

        return fileName;

    }
    public void listFilesForFolder() {
        File folder = new File(sourceCodesPath);

        for (File fileEntry : folder.listFiles()) {

            if (fileEntry.isFile()) {

                String fileName = fileEntry.getName();


               if(fileCanBeRead(fileName)){

                  String fileNameWithoutExtension =  getFileNameWithoutExtension(fileEntry);

                   try {

                       createByteCode(getSolVersion(fileName), fileNameWithoutExtension);
                   } catch (InterruptedException e) {
                       e.printStackTrace();
                   }
               }
            }
        }
    }

    public boolean fileCanBeRead(String fileName) {
        Scanner fScn = null;
        int occourrences = 0;

        System.out.println(fileName);

        try {

            fScn = new Scanner(new File(sourceCodesPath + fileName));

            while (fScn.hasNextLine()) {

                String data = fScn.nextLine();

                if (data.contains("pragma solidity")) {

                    occourrences++;
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } finally {
            return occourrences <= 1;
        }
    }

    public String getSolVersion(String fileName) {
        Scanner fScn = null;
        String unFormattedVersion = "";
        String version = "";

        StringBuilder stringBuilder;

        try {

            fScn = new Scanner(new File(sourceCodesPath + fileName));

            while (fScn.hasNextLine()) {

                String data = fScn.nextLine();

                if (data.contains("pragma solidity")) {

                    if (data.charAt(data.length() - 1) == ';') {

                        String c = "";
                        int i = data.length() - 2;

                        boolean stopChar = true;

                        while (stopChar) {
                            c = String.valueOf(data.charAt(i));
                            i--;
                            if (c.equals("^") || c.equals("<") || c.equals(" ")) {
                            //if (c.equals("^")){
                                stopChar = false;

                            } else {
                                //if (!c.equals("^"))
                                unFormattedVersion += c;
                                //System.out.println(unFormattedVersion);
                            }
                        }
                    }
                    stringBuilder = new StringBuilder(unFormattedVersion);
                    version = stringBuilder.reverse().toString();
                    return version;
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void  createByteCode(String currentVersion, String currentContractAddress) throws InterruptedException {

        try {
            System.out.println( currentContractAddress);
           // Process process = Runtime.getRuntime().exec("powershell /c svm install 0.4.24 | svm use 0.4.24 | solc --bin ..\\smart-contract\\src\\source_code\\0x3f7904f4ac4d002277f55ba5c24fd24b1b51aa15.sol > output.txt ");
            Process process;

            process = Runtime.getRuntime().exec("powershell /c svm install " + currentVersion);
//            process = Runtime.getRuntime().exec("powershell /c svm install 0.6.12");
            process.waitFor();
            //printResults(process);
            //printErrors(process);


            process = Runtime.getRuntime().exec("powershell /c svm use " + currentVersion);
            process.waitFor();
            //printResults(process);

            process = Runtime.getRuntime().exec("powershell /c solc --bin ..\\smart-contract\\src\\source_code\\" + currentContractAddress + "  > ..\\smart-contract\\src\\bytecode\\" + currentContractAddress + ".txt");
            process.waitFor();
            //printResults(process);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void printResults(Process process) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        //System.out.println(reader);
        String line = "";
        String lines = "";
        while ((line = reader.readLine()) != null) {
            lines += line;
        }
        System.out.println(lines);
    }

    public static void printErrors(Process process) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
        //System.out.println(reader);
        String line = "";
        String lines = "";
        while ((line = reader.readLine()) != null) {
            lines += line;
        }
        System.out.println(lines);
    }
}

