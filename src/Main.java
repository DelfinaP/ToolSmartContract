import tool.GetOpcode;
import tool.SolcManager;
import tool.SourceCodeManager;

import java.io.IOException;

public class Main {

    public static void main(String[] args) throws IOException {

        //SourceCodeManager sourceCodeManager = new SourceCodeManager();
       // sourceCodeManager.sendGetRequest();

        SolcManager solcManager = new SolcManager();
        solcManager.listFilesForFolder();
        GetOpcode getOpcode = new GetOpcode();
        getOpcode.prova();
    }
}
