package com.example.basicauthfilegenerator;


import org.apache.commons.codec.digest.Md5Crypt;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.FileWriter;
import java.io.IOException;

@SpringBootApplication
public class BasicAuthFileGenerator {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Please provide a username and password as command line arguments.");
            return;
        }
        String username = args[0];
        String password = args[1];
        String encryptedPassword = Md5Crypt.apr1Crypt(password);
        String line = username + ":" + encryptedPassword;
        try {
            FileWriter writer = new FileWriter(".htpasswd");
            writer.write(line);
            writer.close();
        } catch (IOException e) {
            System.out.println("An error occurred while writing to the .htpasswd file.");
        }
    }
}
