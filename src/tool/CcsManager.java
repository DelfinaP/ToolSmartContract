package tool;


import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import utils.FileUtils;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

import static java.lang.System.out;

public class CcsManager {

    public CcsManager() {
    }

    public void listOpcodeFiles(String readPath, String writePath) {
        File folder = new File(readPath);

        for (File fileEntry : folder.listFiles()) {

            if (fileEntry.isFile()) {

                String fileName = fileEntry.getName();
                String fileNameWithoutExtension = FileUtils.getFileNameWithoutExtension(fileEntry);

                getNode(readPath + fileName, writePath + fileNameWithoutExtension + ".ccs");
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
                String fileName = vulnFile.getName();
                String fileNameWithoutExtension = FileUtils.getFileNameWithoutExtension(vulnFile);
                specificWritePath += "\\" + vulnFolder.getName() + "\\" ;
                //out.println(specificWritePath);
                try {
                    if(!Files.exists(Paths.get(specificWritePath)))
                        Files.createDirectory(Paths.get(specificWritePath));
                    getNode(vulnFolder.getPath()+"\\" + fileName, specificWritePath + fileNameWithoutExtension + ".ccs");

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

    private ArrayList<String> fromStringToArray(String stringParsedOpcode) {
        //String stringParsedOpcode = "0: PUSH1 0x80\n2: PUSH1 0x40\n4: MSTORE\n5: CALLVALUE\n6: DUP1\n7: ISZERO\n8: PUSH3 0x000011\n12: JUMPI";
        ArrayList<String> arrayOperation = new ArrayList();

        String[] splitString = stringParsedOpcode.split("\n");

        for (String s : splitString) {
            String c = s.substring(s.indexOf(":") + 2, s.length());
            if (s.contains("0x")) {
                c = s.substring(s.indexOf(":") + 1, s.indexOf("0x") - 1);
            }
            arrayOperation.add(c.trim());
            //  out.println(arrayOperation);
        }
        return arrayOperation;
    }

    public void getNode(String readPath, String writePath) {

        JSONParser parser = new JSONParser();
        //String readPath = "..\\smart-contract\\src\\etherSolve_json\\0xff9315c2c4c0208edb5152f4c4ebec75e74010c5.json";

        Object obj = null;
        try {
            obj = parser.parse(new FileReader(readPath));
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }

        JSONObject jsonObject = (JSONObject) obj;
        //System.out.println(jsonObject);
        JSONObject subjects = (JSONObject) jsonObject.get("runtimeCfg");
        JSONArray successors = (JSONArray) subjects.get("successors");
        //out.println(successors);

        JSONArray nodes = (JSONArray) subjects.get("nodes");
        //out.println(nodes);

        ListIterator<JSONObject> iteratorNodes = (ListIterator<JSONObject>) nodes.listIterator();
        ListIterator<JSONObject> iteratorNodesAux = (ListIterator<JSONObject>) nodes.listIterator();
        ListIterator<JSONObject> iteratorNodesAux1 = (ListIterator<JSONObject>) nodes.listIterator();
        ListIterator<JSONObject> iteratorFrom = (ListIterator<JSONObject>) successors.listIterator();

        ArrayList<ArrayList> allOpcodes = new ArrayList<>();
        ArrayList<String> allOpcodesTogheter = new ArrayList<>();

        int processNumber = 0;

        for (int i = 0; i < nodes.size(); i++) {

            JSONObject currentNode = (JSONObject) nodes.get(i);
            ArrayList<String> opcodes = fromStringToArray(currentNode.get("parsedOpcodes").toString());

            for (int j = 0; j < opcodes.size(); j++) {

                if (opcodes.get(j).contains("EXIT BLOCK")) {
                    opcodes.set(j, opcodes.get(j).replace(" ", ""));
                    //out.println(opcodes.get(j));
                }

                opcodes.set(j, opcodes.get(j) + "-p" + ((processNumber++) + 1));
                //out.println(opcodes.get(j));
                allOpcodesTogheter.add(opcodes.get(j));
            }

            allOpcodes.add(opcodes);
        }

        //out.println(allOpcodes);
        // out.println(allOpcodes.get(0));

        String allp = "";
        String add = "";
        int pNumbAux = 0;
        for (int i = 0; i < nodes.size(); i++) {

            JSONObject currentNode = (JSONObject) nodes.get(i);
            JSONObject currentSuccessor = (JSONObject) successors.get(i);

            //cercare offset
            if (currentNode.get("offset").equals(currentSuccessor.get("from"))) {

                JSONObject nodoCheSalta = currentNode;
                int index = i;

                //prendere salti
                JSONArray jumps = (JSONArray) currentSuccessor.get("to");

                //cerac dove saltare
                ArrayList<String> jumpAt = new ArrayList<>();

                String cmd = "";
                for (int o = 0; o < allOpcodes.get(i).size(); o++) {
                    String[] pn = allOpcodes.get(i).get(o).toString().split("-p");
                    pNumbAux++;

                    if (o < allOpcodes.get(i).size() - 1) {

                        allp += "proc p" + pNumbAux + "=" + pn[0] + ".p" + (pNumbAux + 1) + "\n";
                    } else {
                        allp += "proc p" + pNumbAux + "=" + pn[0];
                    }
                    cmd = pn[0];

                }

                for (int j = 0; j < jumps.size(); j++) {
                    for (int k = 0; k < nodes.size(); k++) {

                        JSONObject currentNodeAux = (JSONObject) nodes.get(k);

                        if (currentNodeAux.get("offset").equals(jumps.get(j))) {

                            //  out.println(allOpcodes.get(k).get(0));
                            //  out.println("salta");
                            String[] pnumbc = allOpcodes.get(k).get(0).toString().split("-p");
                            jumpAt.add(pnumbc[1]);

                            if (jumps.size() == 1) {
                                add += ".p" + pnumbc[1] + "\n";
                            } else {
                                if (j < jumps.size() - 1) {
                                    add += ".p" + pnumbc[1];
                                } else {
                                    add += " + " + cmd + ".p" + pnumbc[1] + "\n";
                                }
                            }
                            allp += add;
                            add = "";
                        }
                    }
                }
            }
            // out.println(add);
        }
        allp += ".nil";

        //out.println(allp);

        FileUtils.writeFile(allp, writePath);
    }
}





