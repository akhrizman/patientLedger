package com.khrizman.pledger.service;

import com.khrizman.pledger.dto.LedgerEntryDto;
import com.khrizman.pledger.model.LedgerEntry;
import com.khrizman.pledger.repository.LedgerEntryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class DataService {

    private static final Logger log = Logger.getLogger(DataService.class.getName());

    @Autowired
    LedgerEntryRepository ledgerEntryRepository;

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
}
