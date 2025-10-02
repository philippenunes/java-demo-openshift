package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class Home {
    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(Home.class);

    @GetMapping("/")
    public String home() {
        log.info("Java 17 + GitHub Actions + ArgoCD + OpenShift!");
        return "Java 17 + GitHub Actions + ArgoCD + OpenShift!";
    }
}