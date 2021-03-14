package com.khrizman.pledger.repository;

import com.khrizman.pledger.model.Billing;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BillingRepository extends JpaRepository<Billing, Integer> {
    List<Billing> findAllByLedgerEntryIdOrderByServiceDate(int entryId);
}
