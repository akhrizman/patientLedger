package com.khrizman.pledger.service;

import com.khrizman.pledger.dto.LedgerEntryDetailsDto;
import com.khrizman.pledger.dto.BillingDto;
import com.khrizman.pledger.dto.NewLedgerEntryDto;
import com.khrizman.pledger.model.*;
import com.khrizman.pledger.repository.*;
import com.khrizman.pledger.util.Utilities;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
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

    public List<LedgerEntryDetailsDto> getEntriesForSelection() {
        List<LedgerEntryDetailsDto> entriesForSelection = new ArrayList<LedgerEntryDetailsDto>();
        getIncompleteLedgerEntries().stream().forEach(entry->entriesForSelection.add(new LedgerEntryDetailsDto(entry)));
        return entriesForSelection;
    }

    public LedgerEntryDetailsDto getLedgerEntry(long id) {
        return new LedgerEntryDetailsDto(ledgerEntryRepository.findById(id));
    }

    public LedgerEntryDetailsDto getBillings(long ledgerEntryId) {
        return new LedgerEntryDetailsDto(
                billingRepository.findAllByLedgerEntryIdOrderByServiceDate(ledgerEntryId),
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

    public LedgerEntryDetailsDto getBillingOptions() {
        return new LedgerEntryDetailsDto(getCategoryMap(), getBillingTypeMap(), getCategoryToBillingTypesMap());
    }

    @Transactional
    public LedgerEntryDetailsDto createLedgerEntry(NewLedgerEntryDto newLedgerEntryDto) {
        return new LedgerEntryDetailsDto(ledgerEntryRepository.save(LedgerEntry.builder()
                .initials(newLedgerEntryDto.getInitials().toUpperCase())
                .age(newLedgerEntryDto.getAge())
                .startDate(newLedgerEntryDto.getStartDate())
                .entryComplete(newLedgerEntryDto.isEntryComplete())
                .build()));
    }

    @Transactional
    public LedgerEntryDetailsDto createBilling(BillingDto billingDto) {
        List<Billing> billing = new ArrayList<>();
        billing.add(billingRepository.save(Billing.builder()
                .ledgerEntryId(billingDto.getLedgerEntryId())
                .categoryId(billingDto.getCategoryId())
                .billingTypeId(billingDto.getBillingTypeId())
                .serviceDate(billingDto.getServiceDate())
                .billed(billingDto.isBilled())
                .reportComplete(billingDto.isReportComplete())
                .build()));
        return new LedgerEntryDetailsDto(billing,
                getCategoryMap(),
                getBillingTypeMap());
    }

    @Transactional
    public Billing updateBilling(BillingDto billingDto) {
        Billing billing = billingRepository.findById(billingDto.getId());
        billing.setBilled(billingDto.isBilled());
        billing.setReportComplete(billingDto.isReportComplete());
        return billingRepository.save(billing);
    }

    @Transactional
    public LedgerEntry completeLedgerEntry(long id) {
        int existingBillings = billingRepository.countByLedgerEntryId(id);
        int completedBillings = billingRepository.findByLedgerEntryIdAndBilledTrueAndReportCompleteTrue(id).size();
        boolean billingsExist = existingBillings > 0;
        boolean allBillingsComplete = existingBillings == completedBillings;
        LedgerEntry ledgerEntry = ledgerEntryRepository.findById(id);
        if (billingsExist && allBillingsComplete) {
            ledgerEntry.setEntryComplete(true);
            return ledgerEntryRepository.save(ledgerEntry);
        }
        return new LedgerEntry();
    }
}
