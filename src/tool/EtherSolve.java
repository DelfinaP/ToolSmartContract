package tool;

import utils.FileUtils;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Paths;

public class EtherSolve {

    public EtherSolve(){

    }
    public void listFilesForFolder(String readPath, String writePath) {
        File folder = new File(readPath);

        for (File fileEntry : folder.listFiles()) {

            if (fileEntry.isFile()) {

                String fileName = fileEntry.getName();

              System.out.println("filename : " + fileName);
                //if(fileCanBeRead(fileName)){

                String fileNameWithoutExtension = FileUtils.getFileNameWithoutExtension(fileEntry);

                try {
                    createFileJson(fileNameWithoutExtension, readPath, writePath);

                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    //for file vulnerability
    public void listFiles(String readPath, String writePath){
        File directory = new File(readPath);
        File[] vulnerabilityFolders = directory.listFiles();

        String specificWritePath = writePath;

        for (File vulnFolder : vulnerabilityFolders){
            for (File vulnFile : vulnFolder.listFiles()){
                specificWritePath += vulnFolder.getName() + "\\" ;
                try {
                    if(!Files.exists(Paths.get(specificWritePath)))
                        Files.createDirectory(Paths.get(specificWritePath));

                    createFileJson(FileUtils.getFileNameWithoutExtension(vulnFile), vulnFolder.getPath()+"\\", specificWritePath);

                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                specificWritePath = writePath;
            }
        }
    }


    public void createFileJson(String currentContractAddress, String readPath, String writePath) throws InterruptedException {

        try {

            Process process;

            //process = Runtime.getRuntime().exec("powershell /c java -jar EtherSolve.jar -r -j -o ..\\smart-contract\\src\\etherSolve_json\\prova.json ..\\smart-contract\\src\\bytecode\\0x0d24914029f017c8e3f5903b466c8f4fe3ff29d0.evm");
            process = Runtime.getRuntime().exec("powershell /c java -jar EtherSolve.jar -r -j -o " + writePath + currentContractAddress + ".json " + readPath + currentContractAddress + ".evm");
            //process.waitFor();
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
        System.out.println("" + lines);
    }
}
