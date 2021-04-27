import tool.CcsManager;
import tool.SolcManager;
import tool.SourceCodeManager;


public class Main {

    public static void main(String[] args) {


       // SourceCodeManager sourceCodeManager = new SourceCodeManager();
       // sourceCodeManager.sendGetRequest();

        SolcManager solcManager = new SolcManager();
        solcManager.listFilesForFolder();

        //CcsManager ccsManager = new CcsManager();
        //ccsManager.listOpcodeFiles();
      //  ccsManager.readOpcodeOperation("0x102a796eb323c90ea233cf0cf454afa7d0441252.txt");
    }
}
