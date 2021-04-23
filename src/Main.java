import tool.CcsManager;
import tool.SolcManager;
import tool.SourceCodeManager;


public class Main {

    public static void main(String[] args) {


        //SourceCodeManager sourceCodeManager = new SourceCodeManager();
        //sourceCodeManager.sendGetRequest();

        //SolcManager solcManager = new SolcManager();
        //solcManager.listFilesForFolder();

        CcsManager ccsManager = new CcsManager();
        //ccsManager.listOpcodeFiles();
        ccsManager.readOpcodeOperation("0x00fbd1774093e9240beb559f7a1300d291d86309prova.txt");
    }
}
