package tool;

import utils.FileUtils;
import utils.JsonUtils;

import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class SolcManager {



    public SolcManager() {
    }


    public void listFilesForFolder(String path, String path1) {
        File folder = new File(path);

        for (File fileEntry : folder.listFiles()) {

            if (fileEntry.isFile()) {

                String fileName = fileEntry.getName();

//              System.out.println(fileName);
                //if(fileCanBeRead(fileName)){

                String fileNameWithoutExtension = FileUtils.getFileNameWithoutExtension(fileEntry);

                try {

                    createByteCodeAndOpCode(getSolVersion(getAllSolVersion(fileName, path)), fileNameWithoutExtension, path, path1);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    //for file vulnerability
    public List<File> listFiles(String directoryName) {
        File directory = new File(directoryName);

        List<File> resultList = new ArrayList<File>();

        // get all the files from a directory
        File[] fList = directory.listFiles();

        resultList.addAll(Arrays.asList(fList));

        for (File file : fList) {
            if (file.isFile()) {
                System.out.println(file.getAbsolutePath());

                System.err.println(file.getParentFile().getName());
            } else if (file.isDirectory()) {

                resultList.addAll(listFiles(file.getAbsolutePath()));
            }
        }
        System.out.println(resultList);
        return resultList;
    }

    public boolean fileCanBeRead(String fileName, String path) {
        Scanner fScn = null;
        int occourrences = 0;

        //System.out.println(fileName);

        try {

            fScn = new Scanner(new File(path + fileName));

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
            System.out.println(singleVersion[0] + "." + singleVersion[1] + "." + singleVersion[2]);

            first.add(Integer.valueOf(singleVersion[0]));
            second.add(Integer.valueOf(singleVersion[1]));
            third.add(Integer.valueOf(singleVersion[2]));
        }

        maxFirst = getGreater(first);

        if (maxFirst.getThereIsMax()) {
            positionOfMaxVersion = maxFirst.getPosition();
        } else {

            maxSecond = getGreater(second);
            if (maxSecond.getThereIsMax()) {
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

        for (int i = 0; i < array.size() - 1; i++) {
            if (array.get(i) > max) {
                max = array.get(i);
                maxPosition = i;
            } else if (array.get(i) == max)
                occourences++;
        }

        if (occourences == array.size() - 1) {
            result.setThereIsMax(false);
            return result;
        }

        result.setThereIsMax(true);
        result.setPosition(maxPosition);
        return result;
    }

    public ArrayList<String> getAllSolVersion(String fileName, String path) {
        Scanner fScn = null;
        String unFormattedVersion = "";
        String version = "";

        ArrayList<String> pragmaVersionArray = new ArrayList<>();

        StringBuilder stringBuilder;

        try {

            fScn = new Scanner(new File(path + fileName));

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

    public void createByteCodeAndOpCode(String currentVersion, String currentContractAddress, String path, String path1) throws InterruptedException {

        try {
            System.out.println(currentContractAddress);

            Process process;

            process = Runtime.getRuntime().exec("powershell /c svm install " + currentVersion);
            process.waitFor();
            printResults(process);
            printErrors(process);

            process = Runtime.getRuntime().exec("powershell /c svm use " + currentVersion);
            process.waitFor();
            printResults(process);
            printErrors(process);

            //for bytecode
//            process = Runtime.getRuntime().exec("powershell /c solc --bin " + path + currentContractAddress + ".sol  > " + path1 + currentContractAddress + ".txt");
//            process.waitFor();
//            printResults(process);
//            printErrors(process);

            process = Runtime.getRuntime().exec("powershell /c solc --opcodes " + path + currentContractAddress + ".sol  > " + path1 + currentContractAddress + ".txt");

            process.waitFor();
            printResults(process);
            printErrors(process);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void printResults(Process process) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

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

