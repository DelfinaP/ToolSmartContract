import tool.CcsManager;
import tool.SolcManager;
import tool.SourceCodeManager;


public class Main {

    public static void main(String[] args) {


        SourceCodeManager sourceCodeManager = new SourceCodeManager();
        sourceCodeManager.sendGetRequest();

        //SolcManager solcManager = new SolcManager();
        //solcManager.listFilesForFolder();

        CcsManager ccsManager = new CcsManager();
        ccsManager.listOpcodeFiles();
        //ccsManager.readOpcodeOperation("0x1B4a86c26b2997629e934d8Ca3941bcB9F39c838.txt");
    }
}
