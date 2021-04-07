import tool.SolcManager;
import tool.SourceCodeManager;

public class Main {

    public static void main(String[] args) {

        //SourceCodeManager sourceCodeManager = new SourceCodeManager();
       // sourceCodeManager.sendGetRequest();

        SolcManager solcManager = new SolcManager();
        solcManager.listFilesForFolder();
    }
}
