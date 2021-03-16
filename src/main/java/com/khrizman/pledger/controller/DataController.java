package com.khrizman.pledger.controller;

import com.khrizman.pledger.dto.LedgerEntryDetailsDto;
import com.khrizman.pledger.dto.BillingDto;
import com.khrizman.pledger.dto.NewLedgerEntryDto;
import com.khrizman.pledger.model.Billing;
import com.khrizman.pledger.model.LedgerEntry;
import com.khrizman.pledger.service.DataService;
import com.khrizman.pledger.util.Utilities;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

@RestController
public class DataController {
    private static final Logger log = Logger.getLogger(DataController.class.getName());

    @Autowired
    DataService dataService;

    @GetMapping("/entrySelection")
    public List<LedgerEntryDetailsDto> getEntriesForSelection() {
        return dataService.getEntriesForSelection();
    }

    @GetMapping("/ledgerEntry/{id}")
    public LedgerEntryDetailsDto getEntry(@PathVariable long id) { return dataService.getLedgerEntry(id); }

    @GetMapping("/billings/{entryId}")
    public LedgerEntryDetailsDto getBillings(@PathVariable long entryId) {
        return dataService.getBillings(entryId);
    }

    @GetMapping("/billingOptions")
    public LedgerEntryDetailsDto getBillingOptions() { return dataService.getBillingOptions(); }

    @PostMapping("/ledgerEntry")
    @ResponseBody
    public LedgerEntryDetailsDto createLedgerEntry(@RequestBody NewLedgerEntryDto newLedgerEntryDto) {
        return dataService.createLedgerEntry(newLedgerEntryDto);
    }

    @PostMapping("/billing")
    @ResponseBody
    public LedgerEntryDetailsDto createBilling(@RequestBody BillingDto billingDto) {
        return dataService.createBilling(billingDto);
    }

    @PutMapping("/billing")
    @ResponseBody
    public Billing updateBilling(@RequestBody BillingDto billingDto) {
        return dataService.updateBilling(billingDto);
    }

    @PatchMapping("/ledgerEntry/{id}")
    @ResponseBody
    public LedgerEntry completeLedgerEntry(@PathVariable long id) {
        return dataService.completeLedgerEntry(id);
    }
}
