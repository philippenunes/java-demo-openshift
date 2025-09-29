package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class Home {
    @GetMapping("/")
    public String home() {
        return "🚀 GitHub Actions + GitOps: PIPELINE TESTANDO! ✨";
    }
}