package com.khrizman.pledger.repository;

import com.khrizman.pledger.model.LedgerEntry;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LedgerEntryRepository extends JpaRepository<LedgerEntry, Long> {
    List<LedgerEntry> findAllByEntryCompleteOrderByStartDate(boolean complete);

    LedgerEntry findById(int id);
}
