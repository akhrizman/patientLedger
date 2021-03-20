package com.khrizman.pledger.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import javax.servlet.http.HttpSession;
import java.util.logging.Logger;

@Controller
public class HomeController {
    private static final Logger log = Logger.getLogger(HomeController.class.getName());

    @GetMapping("/")
    public String homePage() {
        return "entryPage";
    }

    @GetMapping("/ledger")
    public String ledgerPage() {
        return "ledgerPage";
    }
}
