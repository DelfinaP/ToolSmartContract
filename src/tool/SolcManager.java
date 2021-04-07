package tool;

import java.io.*;
import java.util.Scanner;

public class SolcManager {

    String sourceCodesPath = "..\\smart-contract\\src\\source_code\\";

    public SolcManager() {
    }

    public void listFilesForFolder() {
        File folder = new File(sourceCodesPath);

        for (File fileEntry : folder.listFiles()) {

            if (fileEntry.isFile()) {

                String fileName = fileEntry.getName();

               if(fileCanBeRead(fileName)){

                   System.out.println(getSolVersion(fileName));

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
            return occourrences > 1;
        }
    }

    public String getSolVersion(String fileName) {
        Scanner fScn = null;
        String version = "";

        try {

            fScn = new Scanner(new File(sourceCodesPath + fileName));

            while (fScn.hasNextLine()) {

                String data = fScn.nextLine();

                if (data.contains("pragma solidity")) {

                    if (data.charAt(data.length() - 1) == ';') {

                        String c = "";
                        int i = data.length() - 2;

                        while (!c.equals("^")) {

                            c = String.valueOf(data.charAt(i));
                            i--;

                            if (!c.equals("^"))
                                version += c;
                        }
                    }
                    return new StringBuilder(version).reverse().toString();
                }

            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void prova() {

        try {

            Process process = Runtime.getRuntime().exec("powershell /c svm install 0.6.12 | svm use 0.6.12 | solc --bin ..\\smart-contract\\src\\source_code\\0x0d24914029f017c8e3f5903b466c8f4fe3ff29d0.sol > output.txt ");
            // Process process = Runtime.getRuntime().exec("powershell /c dir | mkdir file");

            printResults(process);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void printResults(Process process) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
        String line = "";
        while ((line = reader.readLine()) != null) {
            System.out.println(line);
        }
    }
}

