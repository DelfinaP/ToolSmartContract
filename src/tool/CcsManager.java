package tool;

import utils.FileUtils;
import utils.JsonUtils;

import javax.sound.midi.SysexMessage;
import java.io.*;

import java.util.ArrayList;
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

        createFileCcs(allOperationsSections, fileName);
    }

    private void createFileCcs(ArrayList<ArrayList> arrayList, String fileName) {

        String path = ccsPath + fileName.replaceFirst("[.][^.]+$", "") + ".ccs";

        String process = "";

        int b = 1;

        ArrayList<String> procAllArray = new ArrayList<String>();

        String procAll = "proc ALL = ";

        for (int i = 0; i < arrayList.size(); i++) {
            for (int j = 0; j < arrayList.get(i).size(); j++) {

                if (j == arrayList.get(i).size() - 1) {
                    //System.out.println("p" + j + "=" + arrayList.get(i).get(j) + ".nil");
                    process += "proc p" + b + "=" + arrayList.get(i).get(j) + ".nil" + "\n" + "\n";
                    b++;
                } else {
                    int z = b + 1;
                    process += "proc p" + b + "=" + arrayList.get(i).get(j) + ".p" + z + "\n";
                    b++;
                }
            }
            procAllArray.add((String) arrayList.get(i).get(0));
        }

        System.out.println(procAllArray);

        for (int z = 0; z < procAllArray.size(); z++) {

            if (z == procAllArray.size() - 1) {
                procAll += procAllArray.get(z);
            } else {
                procAll += procAllArray.get(z) + " + ";
            }
        }
        FileUtils.writeFile(process, procAll, path);
    }
}

