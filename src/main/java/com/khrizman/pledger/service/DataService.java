package com.khrizman.pledger.service;

import com.khrizman.pledger.dto.BillingEntryDto;
import com.khrizman.pledger.dto.LedgerEntryDetailsDto;
import com.khrizman.pledger.dto.NewLedgerEntryDto;
import com.khrizman.pledger.model.*;
import com.khrizman.pledger.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@Service
public class DataService {

    private static final Logger log = Logger.getLogger(DataService.class.getName());

    @Autowired
    private LedgerEntryRepository ledgerEntryRepository;
    @Autowired
    private BillingRepository billingRepository;
    @Autowired
    private CategoryRepository categoryRepository;
    @Autowired
    private BillingTypeRepository billingTypeRepository;
    @Autowired
    private CategoryBillingTypeRepository categoryBillingTypeRepository;

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

    public List<BillingEntryDto> getAllBillings() {
        List<LedgerEntry> ledgerEntries = ledgerEntryRepository.findAll();
        Map<Long, LedgerEntry> ledgerEntryMap = ledgerEntries.stream().collect(Collectors.toMap(LedgerEntry::getId, le -> le));
        List<Billing> billings = billingRepository.findAll();
        return billings.stream().map(be -> BillingEntryDto.builder()
                .serviceDate(be.getServiceDate())
                .billingId(be.getId())
                .ledgerEntryId(be.getLedgerEntryId())
                .category(getCategoryMap().get(be.getCategoryId()))
                .billingType(getBillingTypeMap().get(be.getBillingTypeId()))
                .billed(be.isBilled())
                .reportComplete(be.isReportComplete())
                .initials(ledgerEntryMap.get(be.getLedgerEntryId()).getInitials())
                .age(ledgerEntryMap.get(be.getLedgerEntryId()).getAge())
                .build()
                ).collect(Collectors.toList());
    }

    public LedgerEntryDetailsDto getBillings(long ledgerEntryId) {
        return new LedgerEntryDetailsDto(
                billingRepository.findAllByLedgerEntryIdOrderByServiceDate(ledgerEntryId),
                getCategoryMap(),
                getBillingTypeMap());
    }

    public LedgerEntryDetailsDto getBilling(long id) {
        List<Billing> billings = new ArrayList<>();
        billings.add(billingRepository.findById(id));
        return new LedgerEntryDetailsDto(
                billings,
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
    public LedgerEntryDetailsDto createBilling(Billing billing) {
        List<Billing> billings = new ArrayList<>();

        Billing savedBilling = billingRepository.save(Billing.builder()
                .ledgerEntryId(billing.getLedgerEntryId())
                .categoryId(billing.getCategoryId())
                .billingTypeId(billing.getBillingTypeId())
                .serviceDate(billing.getServiceDate())
                .billed(billing.isBilled())
                .reportComplete(billing.isReportComplete())
                .build());

        Billing updatedBilling = billingRepository.findById(savedBilling.getId());
        billings.add(updatedBilling);
        return new LedgerEntryDetailsDto(
                billings,
                getCategoryMap(),
                getBillingTypeMap());
    }

    @Transactional
    public Billing updateBilling(Billing billing) {
        Billing billingToUpdate = billingRepository.findById(billing.getId());
        billingToUpdate.setBilled(billing.isBilled());
        billingToUpdate.setReportComplete(billing.isReportComplete());
        return billingRepository.save(billingToUpdate);
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

    @Transactional
    public LedgerEntry updateLedgerEntry(LedgerEntry ledgerEntry) {
        LedgerEntry existingEntry = ledgerEntryRepository.findById(ledgerEntry.getId());
        if (ledgerEntry != null) {
            existingEntry.setInitials(ledgerEntry.getInitials());
            existingEntry.setAge(ledgerEntry.getAge());
            existingEntry.setStartDate(ledgerEntry.getStartDate());
            existingEntry.setModifiedDate(new Date());
            return ledgerEntryRepository.save(existingEntry);
        }
        return new LedgerEntry();
    }

    @Transactional
    public void deleteBilling(long id) {
        billingRepository.deleteById(id);
    }
}
