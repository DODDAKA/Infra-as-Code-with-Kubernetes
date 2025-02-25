package com.abhishek;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.beans.factory.annotation.Value;

@SpringBootApplication
@Controller
public class StartApplication {

    @Value("${CREATOR_1:Default Creator 1}")
    private String creator1;

    @Value("${CREATOR_2:Default Creator 2}")
    private String creator2;

    @GetMapping("/")
    public String index(final Model model) {
        model.addAttribute("title", "I have successfully built a Spring Boot application using Maven");
        String message = "This application is deployed on to Kubernetes using Argo CD and created by " + 
                        creator1 + " and " + creator2;
        model.addAttribute("msg", message);
        return "index";
    }

    public static void main(String[] args) {
        SpringApplication.run(StartApplication.class, args);
    }
}
