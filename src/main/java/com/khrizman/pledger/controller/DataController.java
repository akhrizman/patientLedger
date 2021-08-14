package com.khrizman.pledger.controller;

import com.khrizman.pledger.dto.BillingEntryDto;
import com.khrizman.pledger.dto.LedgerEntryDetailsDto;
import com.khrizman.pledger.dto.NewLedgerEntryDto;
import com.khrizman.pledger.model.Billing;
import com.khrizman.pledger.model.LedgerEntry;
import com.khrizman.pledger.service.DataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
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

    @PatchMapping("/completeLedgerEntry/{id}")
    @ResponseBody
    public LedgerEntry completeLedgerEntry(@PathVariable long id) {
        return dataService.completeLedgerEntry(id);
    }

    @PatchMapping("/ledgerEntry")
    @ResponseBody
    public LedgerEntry completeLedgerEntry(@RequestBody LedgerEntry ledgerEntry) {
        return dataService.updateLedgerEntry(ledgerEntry);
    }



    @GetMapping("/billingOptions")
    @ResponseBody
    public LedgerEntryDetailsDto getBillingOptions() { return dataService.getBillingOptions(); }

    @GetMapping("/billings")
    @ResponseBody
    public List<BillingEntryDto> getAllBillings(@RequestParam(required = false) Date startDate, @RequestParam(required=false) Date endDate) {
        return dataService.getAllBillings(startDate, endDate);
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
    public LedgerEntryDetailsDto createBilling(@RequestBody Billing billing) {
        LedgerEntryDetailsDto ledgerEntryDetailsDto = dataService.createBilling(billing);
        return ledgerEntryDetailsDto;
    }

    @PutMapping("/billingFlags")
    @ResponseBody
    public Billing updateBillingFlags(@RequestBody Billing billing) {
        log.info("Updating billing Flags " + billing.getId());
        return dataService.updateBillingFlags(billing);
    }

    @PutMapping("/billing")
    @ResponseBody
    public Billing updateBilling(@RequestBody Billing billing) {
        log.info("Updating billing " + billing.getId());
        return dataService.updateBilling(billing);
    }

    @DeleteMapping("/billing/{id}")
    public void deleteBilling(@PathVariable long id) {
        dataService.deleteBilling(id);
    }

    @GetMapping("/unreportedBillings")
    @ResponseBody
    public Integer getUnreportedBillingsCount() {
        return dataService.getUnreportedBillingsCount();
    }
}
