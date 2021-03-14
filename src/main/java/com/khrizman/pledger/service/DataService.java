package com.khrizman.pledger.service;

import com.khrizman.pledger.dto.LedgerEntryDto;
import com.khrizman.pledger.model.*;
import com.khrizman.pledger.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@Service
public class DataService {

    private static final Logger log = Logger.getLogger(DataService.class.getName());

    @Autowired
    LedgerEntryRepository ledgerEntryRepository;
    @Autowired
    BillingRepository billingRepository;
    @Autowired
    CategoryRepository categoryRepository;
    @Autowired
    BillingTypeRepository billingTypeRepository;
    @Autowired
    CategoryBillingTypeRepository categoryBillingTypeRepository;

    public List<LedgerEntry> getIncompleteLedgerEntries() {
        return ledgerEntryRepository.findAllByEntryCompleteOrderByStartDate(false);
    }

    public List<LedgerEntry> getCompleteLedgerEntries() {
        return ledgerEntryRepository.findAllByEntryCompleteOrderByStartDate(true);
    }

    public List<LedgerEntryDto> getEntriesForSelection() {
        List<LedgerEntryDto> entriesForSelection = new ArrayList<LedgerEntryDto>();
        getIncompleteLedgerEntries().stream().forEach(entry->entriesForSelection.add(new LedgerEntryDto(entry)));
        return entriesForSelection;
    }

    public LedgerEntryDto getLedgerEntry(int id) {
        return new LedgerEntryDto(ledgerEntryRepository.findById(id));
    }

    public LedgerEntryDto getBillings(int entryId) {
        return new LedgerEntryDto(
                billingRepository.findAllByLedgerEntryIdOrderByServiceDate(entryId),
                getCategoryMap(),
                getBillingTypeMap());
    }

    public Map<Integer, String> getCategoryMap() {
        return categoryRepository.findAll()
                .stream()
                .collect(Collectors.toMap(Category::getId, Category::getName));
    }

    public Map<Integer, String> getBillingTypeMap() {
        return billingTypeRepository.findAll()
                .stream()
                .collect(Collectors.toMap(BillingType::getId, BillingType::getName));
    }

    public Map<Integer, List<Integer>> getCategoryToBillingTypesMap() {
        return categoryBillingTypeRepository.findAll().stream()
                .collect(Collectors.groupingBy(CategoryBillingType::getCategoryId,
                        Collectors.mapping(CategoryBillingType::getBillingTypeId, Collectors.toList())));
    }

    public LedgerEntryDto getBillingOptions() {
        return new LedgerEntryDto(getCategoryMap(), getBillingTypeMap(), getCategoryToBillingTypesMap());
    }
}
