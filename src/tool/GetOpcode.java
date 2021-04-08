package tool;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class GetOpcode {
    public void prova() throws IOException {


        Process process = Runtime.getRuntime().exec("powershell /c svm install 0.6.12 | svm use 0.6.12 | solc --opcodes ..\\smart-contract\\src\\source_code\\0x0d24914029f017c8e3f5903b466c8f4fe3ff29d0.sol > op_output.txt ");

        printResults(process);
    }

    public static void printResults(Process process) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
        String line = "";
        while ((line = reader.readLine()) != null) {
            System.out.println(line);
        }
    }

}
