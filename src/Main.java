import tool.*;
import utils.FileUtils;
import utils.JsonUtils;

import java.io.IOException;


public class Main {


    public static void main(String[] args) {

        String sourceCodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "source_codes_path");
        String bytecodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "bytecodes_path");
        String opCodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "opcodes_path");
        String etherSolveJsonPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "etherSolve_json_path");
        String ccsPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "ccs_path");

        String sourceCodesVulnerablePath = JsonUtils.readValue("src/json/parameters.json", "parameters", "source_codes_vulnerable_path");
        String bytecodesVulnerablePath = JsonUtils.readValue("src/json/parameters.json", "parameters", "bytecodes_vulnerable_path");
        String opCodesVulnerablePath = JsonUtils.readValue("src/json/parameters.json", "parameters", "opcodes_vulnerable_path");
        String etherSolveJsonVulnerablePath = JsonUtils.readValue("src/json/parameters.json", "parameters", "etherSolve_json_vulnerable_path");
        String ccsVulnerablePath = JsonUtils.readValue("src/json/parameters.json", "parameters", "ccs_vulnerable_path");


//        SourceCodeManager sourceCodeManager = new SourceCodeManager();
//        sourceCodeManager.sendGetRequest();

//        BytecodeManager bytecodeManager = new BytecodeManager();
//        try {
//            bytecodeManager.sendGetRequest();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }

        EtherSolve etherSolve = new EtherSolve();
        etherSolve.listFilesForFolder(bytecodesPath, etherSolveJsonPath);
        etherSolve.listFiles(bytecodesVulnerablePath, etherSolveJsonVulnerablePath);


        //vecchie chiamate
        //        SolcManager solcManager = new SolcManager();
//        solcManager.listFilesForFolder(sourceCodesPath, opCodesPath);
//        solcManager.listFiles(sourceCodesVulnerablePath, opCodesVulnerablePath);
//
//        CcsManager ccsManager = new CcsManager();
//        ccsManager.listOpcodeFiles(opCodesPath, ccsPath);
//        ccsManager.listOpcodeFiles(opCodesVulnerablePath, ccsVulnerablePath);

        //ccsManager.readOpcodeOperation("0x102a796eb323c90ea233cf0cf454afa7d0441252.txt");
    }
}
