import tool.SolcManager;
import tool.SourceCodeManager;
import utils.JsonUtils;


public class Main {

    public static void main(String[] args) {

        String sourceCodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "source_codes_path");
        String opCodesPath = JsonUtils.readValue("src/json/parameters.json", "parameters", "opcodes_path");

        String sourceCodesVulnerablePath = JsonUtils.readValue("src/json/parameters.json", "parameters", "source_codes_vulnerable_path");
        String opCodesVulnerablePath= JsonUtils.readValue("src/json/parameters.json", "parameters", "opcode_vulnerable_path");

        //SourceCodeManager sourceCodeManager = new SourceCodeManager();
        // sourceCodeManager.sendGetRequest();

        SolcManager solcManager = new SolcManager();
        solcManager.listFilesForFolder(sourceCodesPath, opCodesPath);

        //CcsManager ccsManager = new CcsManager();
        //ccsManager.listOpcodeFiles();
        // ccsManager.readOpcodeOperation("0x102a796eb323c90ea233cf0cf454afa7d0441252.txt");
    }
}
