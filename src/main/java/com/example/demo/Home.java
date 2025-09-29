package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class Home {
    @GetMapping("/")
    public String home() {
        return "🚀 Java 17 + OpenShift CRC: FUNCIONANDO! ✨";
    }
}