package tool;

import utils.FileUtils;
import utils.JsonUtils;

import java.io.*;
import java.util.ArrayList;
import java.util.Scanner;

public class SolcManager {

    String sourceCodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "source_codes_path");
    String bytecodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "bytecodes_path");
    String opCodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "opcodes_path");

    public SolcManager() {
    }


    public void listFilesForFolder() {
        File folder = new File(sourceCodesPath);

        for (File fileEntry : folder.listFiles()) {

            if (fileEntry.isFile()) {

                String fileName = fileEntry.getName();

//              System.out.println(fileName);
                //if(fileCanBeRead(fileName)){

                String fileNameWithoutExtension = FileUtils.getFileNameWithoutExtension(fileEntry);

                try {

                    createByteCodeAndOpCode(getSolVersion(getAllSolVersion(fileName)), fileNameWithoutExtension);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                //}
            }
        }
    }

    public boolean fileCanBeRead(String fileName) {
        Scanner fScn = null;
        int occourrences = 0;

        //System.out.println(fileName);

        try {

            fScn = new Scanner(new File(sourceCodesPath + fileName));

            while (fScn.hasNextLine()) {

                String data = fScn.nextLine();
                //System.out.println("questo: "+ data);
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

    public String getSolVersion(ArrayList<String> allVersion) {
        ArrayList<ArrayList> numberOfEachSingleVersion = new ArrayList<>();
        String[] singleVersion;
        int positionOfMaxVersion;

        MaxVersionUtilClass maxFirst, maxSecond, maxThird;

        ArrayList<Integer> first = new ArrayList<>();
        ArrayList<Integer> second = new ArrayList<>();
        ArrayList<Integer> third = new ArrayList<>();

        for (int i = 0; i < allVersion.size(); i++) {
            singleVersion = allVersion.get(i).split("\\.");
            System.out.println(singleVersion[0] + "." +singleVersion[1] + "." +singleVersion[2] );


            first.add(Integer.valueOf(singleVersion[0]));
            second.add(Integer.valueOf(singleVersion[1]));
            third.add(Integer.valueOf(singleVersion[2]));

        }


        maxFirst = getGreater(first);

        if(maxFirst.getThereIsMax()){
            positionOfMaxVersion = maxFirst.getPosition();
        } else {

            maxSecond = getGreater(second);
            if(maxSecond.getThereIsMax()){
                positionOfMaxVersion = maxSecond.getPosition();
            } else {

                maxThird = getGreater(third);
                positionOfMaxVersion = maxThird.getPosition();
            }
        }

        System.out.println("Max version is => " + allVersion.get(positionOfMaxVersion));

        return allVersion.get(positionOfMaxVersion);
    }

    private MaxVersionUtilClass getGreater(ArrayList<Integer> array) {
        MaxVersionUtilClass result = new MaxVersionUtilClass();

        int occourences = 0;
        int max = array.get(0);
        int maxPosition = 0;

        for (int i = 0; i < array.size()-1; i++) {
            if (array.get(i) > max){
                max = array.get(i);
                maxPosition = i;
            }
            else if (array.get(i) == max)
                occourences++;
        }

        if(occourences == array.size()-1){
            result.setThereIsMax(false);
            return result;
        }

        result.setThereIsMax(true);
        result.setPosition(maxPosition);
        return result;
    }

    public ArrayList<String> getAllSolVersion(String fileName) {
        Scanner fScn = null;
        String unFormattedVersion = "";
        String version = "";

        ArrayList<String> pragmaVersionArray = new ArrayList<>();

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
                            if (c.equals("^") || c.equals("<") || c.equals(" ") || c.equals("=")) {
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
                    unFormattedVersion = "";
                    version = stringBuilder.reverse().toString();
                    pragmaVersionArray.add(version);
                }
            }

            return pragmaVersionArray;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void createByteCodeAndOpCode(String currentVersion, String currentContractAddress) throws InterruptedException {

        try {
            System.out.println(currentContractAddress);
            // Process process = Runtime.getRuntime().exec("powershell /c svm install 0.4.24 | svm use 0.4.24 | solc --bin ..\\smart-contract\\src\\source_code\\0x3f7904f4ac4d002277f55ba5c24fd24b1b51aa15.sol > output.txt ");
            Process process;

            process = Runtime.getRuntime().exec("powershell /c svm install " + currentVersion);
//            process = Runtime.getRuntime().exec("powershell /c svm install 0.6.12");
            process.waitFor();
            printResults(process);
            printErrors(process);


            process = Runtime.getRuntime().exec("powershell /c svm use " + currentVersion);
            process.waitFor();
            printResults(process);
            printErrors(process);

            //for bytecode
            //process = Runtime.getRuntime().exec("powershell /c solc --bin ..\\smart-contract\\src\\source_code\\" + currentContractAddress + ".sol  > ..\\smart-contract\\src\\bytecode\\" + currentContractAddress + ".txt");
//            process = Runtime.getRuntime().exec("powershell /c solc --bin " + sourceCodesPath + currentContractAddress + ".sol  > " + bytecodesPath + currentContractAddress + ".txt");
//
//            process.waitFor();
//            printResults(process);
//            printErrors(process);

            //process = Runtime.getRuntime().exec("powershell /c solc --opcodes " + sourceCodesPath + currentContractAddress + ".sol  > ..\\smart-contract\\src\\opcode\\" + currentContractAddress + ".txt");
            process = Runtime.getRuntime().exec("powershell /c solc --opcodes " + sourceCodesPath + currentContractAddress + ".sol  > " + opCodesPath + currentContractAddress + ".txt");

            process.waitFor();
            printResults(process);
            printErrors(process);

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

