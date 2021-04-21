package tool;

import utils.JsonUtils;

import java.io.*;

import java.util.ArrayList;
import java.util.Scanner;

public class CcsManager {

    String opCodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "opcodes_path");

    String fileName = "0x1B4a86c26b2997629e934d8Ca3941bcB9F39c838.txt";

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

    public ArrayList<ArrayList> readOpcodeOperation(String fileName) {
        String st = "";
        Boolean lineContainsOperations = false;
        ArrayList<ArrayList> allOperationsSections = new ArrayList<>();
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
                System.out.println(allOperationsSections.get(i));
            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();

        } catch (IOException e) {
            e.printStackTrace();
        }

        return allOperationsSections;
    }

    private void createFileCcs(){

    }
}
