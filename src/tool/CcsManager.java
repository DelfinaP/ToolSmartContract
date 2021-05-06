package tool;

import utils.FileUtils;
import utils.JsonUtils;

import javax.sound.midi.SysexMessage;
import java.io.*;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class CcsManager {

    String opCodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "opcodes_path");
    String ccsPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "ccs_path");

    //String fileName = "0x102a796eb323c90ea233cf0cf454afa7d0441252.txt";

    public CcsManager() {
    }

    public void listOpcodeFiles() {
        File folder = new File(opCodesPath);

        for (File fileEntry : folder.listFiles()) {

            if (fileEntry.isFile()) {

                String fileName = fileEntry.getName();
                readOpcodeOperation(fileName);
            }
        }
    }

    public void readOpcodeOperation(String fileName) {
        String st = "";
        Boolean lineContainsOperations = false;
        ArrayList<ArrayList> allOperationsSections = new ArrayList<ArrayList>();
        ArrayList<String> allOperations = new ArrayList<String>();

        try {
            File file = new File(opCodesPath + fileName);
            Scanner sc = new Scanner(file);

            //BufferedReader br=new BufferedReader(new FileReader(file));
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-16"));

            while ((st = br.readLine()) != null) {

                if (lineContainsOperations == true && st.length() != 0) {
                    String[] operationsSplit = st.split(" ");

                    for (String operation : operationsSplit) {
                        if (!operation.contains("0x")) {
                            allOperations.add(operation);
                        }
                    }
                    allOperationsSections.add(new ArrayList<>(allOperations));
                    allOperations.clear();
                }

                if (st.contains("Opcodes:")) {
                    lineContainsOperations = true;
                } else {
                    lineContainsOperations = false;
                }
            }

//                System.out.println(allOperations);
            for (int i = 0; i < allOperationsSections.size(); i++) {
                //System.out.println(allOperationsSections.get(i));
            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();

        } catch (IOException e) {
            e.printStackTrace();
        }

        try {
            createFileCcs(allOperationsSections, fileName);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void createFileCcs(ArrayList<ArrayList> arrayList, String fileName) throws IOException {
        String path = ccsPath + fileName.replaceFirst("[.][^.]+$", "") + ".ccs";

        String process = "";
        String processProcAll = "";

        int b = 1;

        ArrayList<Integer> firstSectionProcess = new ArrayList<Integer>();

        String procAll = "proc ALL = p1 + ";

        for (int i = 0; i < arrayList.size(); i++) {
            for (int j = 0; j < arrayList.get(i).size(); j++) {

                if (j == arrayList.get(i).size() - 1) {
                    //System.out.println("p" + j + "=" + arrayList.get(i).get(j) + ".nil");
                    process += "proc p" + b + "=" + arrayList.get(i).get(j) + ".nil" + "\n" + "\n";
                    System.out.println(b);
                    firstSectionProcess.add(b);
                    System.out.println(firstSectionProcess);
                    b++;
                } else {
                    int z = b + 1;
                    process += "proc p" + b + "=" + arrayList.get(i).get(j) + ".p" + z + "\n";
                    b++;
                }
            }
        }

        for (int z = 0; z < firstSectionProcess.size()-1; z++) {
            firstSectionProcess.set(z, firstSectionProcess.get(z) +1);
            //System.out.println(firstSectionProcess.get(z));

            if (z == firstSectionProcess.size()-2){
                processProcAll += "p" + firstSectionProcess.get(z);
            } else {
                processProcAll += "p" + firstSectionProcess.get(z) + " + ";
            }
        }

        procAll += processProcAll;
        //System.out.println(procAll);

        FileUtils.writeFile(process, procAll, path);
    }
}

