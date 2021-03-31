package com.khrizman.pledger.repository;

import com.khrizman.pledger.model.Billing;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;

public interface BillingRepository extends JpaRepository<Billing, Long> {
    List<Billing> findAllByLedgerEntryIdOrderByServiceDate(long ledgerEntryId);

    Billing findById(long id);

    List<Billing> findByLedgerEntryIdAndBilledTrueAndReportCompleteTrue(long id);

    Integer countByLedgerEntryId(long id);

    List<Billing> findByServiceDateBetween(Date startDate, Date endDate);
}
