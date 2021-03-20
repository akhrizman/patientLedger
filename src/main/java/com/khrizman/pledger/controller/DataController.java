package com.khrizman.pledger.controller;

import com.khrizman.pledger.dto.BillingEntryDto;
import com.khrizman.pledger.dto.LedgerEntryDetailsDto;
import com.khrizman.pledger.dto.BillingDto;
import com.khrizman.pledger.dto.NewLedgerEntryDto;
import com.khrizman.pledger.model.Billing;
import com.khrizman.pledger.model.LedgerEntry;
import com.khrizman.pledger.service.DataService;
import com.khrizman.pledger.util.Utilities;
import jdk.jshell.execution.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

@RestController
public class DataController {
    private static final Logger log = Logger.getLogger(DataController.class.getName());

    @Autowired
    private DataService dataService;

    @GetMapping("/entrySelection")
    @ResponseBody
    public List<LedgerEntryDetailsDto> getEntriesForSelection() {
        return dataService.getEntriesForSelection();
    }

    @GetMapping("/ledgerEntry/{id}")
    @ResponseBody
    public LedgerEntryDetailsDto getEntry(@PathVariable long id) { return dataService.getLedgerEntry(id); }

    @PostMapping("/ledgerEntry")
    @ResponseBody
    public LedgerEntryDetailsDto createLedgerEntry(@RequestBody NewLedgerEntryDto newLedgerEntryDto) {
        return dataService.createLedgerEntry(newLedgerEntryDto);
    }

    @PatchMapping("/ledgerEntry/{id}")
    @ResponseBody
    public LedgerEntry completeLedgerEntry(@PathVariable long id) {
        return dataService.completeLedgerEntry(id);
    }



    @GetMapping("/billingOptions")
    @ResponseBody
    public LedgerEntryDetailsDto getBillingOptions() { return dataService.getBillingOptions(); }

    @GetMapping("/billingEntries")
    @ResponseBody
    public List<BillingEntryDto> getAllBillings() {
        return dataService.getAllBillings();
    }

    @GetMapping("/billings/{ledgerEntryId}")
    @ResponseBody
    public LedgerEntryDetailsDto getBillings(@PathVariable long ledgerEntryId) {
        LedgerEntryDetailsDto ledgerEntryDetailsDto = dataService.getBillings(ledgerEntryId);
        return ledgerEntryDetailsDto;
    }

    @GetMapping("/billing/{id}")
    @ResponseBody
    public LedgerEntryDetailsDto getBilling(@PathVariable long id) {
        LedgerEntryDetailsDto ledgerEntryDetailsDto = dataService.getBilling(id);
        return ledgerEntryDetailsDto;
    }

    @PostMapping("/billing")
    @ResponseBody
    public LedgerEntryDetailsDto createBilling(@RequestBody BillingDto billingDto) {
        LedgerEntryDetailsDto ledgerEntryDetailsDto = dataService.createBilling(billingDto);
        return ledgerEntryDetailsDto;
    }

    @PutMapping("/billing")
    @ResponseBody
    public Billing updateBilling(@RequestBody BillingDto billingDto) {
        return dataService.updateBilling(billingDto);
    }

}
