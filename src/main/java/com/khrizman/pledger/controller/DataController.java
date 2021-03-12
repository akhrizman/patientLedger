package com.khrizman.pledger.controller;

import com.khrizman.pledger.dto.LedgerEntryDto;
import com.khrizman.pledger.service.DataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.logging.Logger;

@RestController
public class DataController {
    private static final Logger log = Logger.getLogger(DataController.class.getName());

    @Autowired
    DataService dataService;

    @GetMapping("/entrySelection")
    public List<LedgerEntryDto> getEntriesForSelection() {
        return dataService.getEntriesForSelection();
    }

    @GetMapping("/ledgerEntry/{id}")
    public LedgerEntryDto getEntry(@PathVariable int id) {
        System.out.println(dataService.getLedgerEntry(id));
        return dataService.getLedgerEntry(id);
    }
}
