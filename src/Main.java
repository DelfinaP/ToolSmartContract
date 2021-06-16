import tool.BytecodeManager;
import tool.CcsManager;
import tool.SolcManager;
import tool.SourceCodeManager;
import utils.FileUtils;
import utils.JsonUtils;

import java.io.IOException;


public class Main {

    public static void main(String[] args) {

        String sourceCodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "source_codes_path");
        String opCodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "opcodes_path");

        String sourceCodesVulnerablePath = JsonUtils.readValue("src/json/parameters.json", "parameters", "source_codes_vulnerable_path");
        String opCodesVulnerablePath = JsonUtils.readValue("src/json/parameters.json", "parameters", "opcodes_vulnerable_path");

        String ccsPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "ccs_path");
        String ccsVulnerablePath = JsonUtils.readValue("src/json/parameters.json", "parameters", "ccs_vulnerable_path");


        //SourceCodeManager sourceCodeManager = new SourceCodeManager();
        //sourceCodeManager.sendGetRequest();

        BytecodeManager bytecodeManager = new BytecodeManager();
        try {
            bytecodeManager.sendGetRequest();
        } catch (IOException e) {
            e.printStackTrace();
        }

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
