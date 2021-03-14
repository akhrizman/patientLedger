package com.khrizman.pledger.repository;

import com.khrizman.pledger.model.BillingType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BillingTypeRepository extends JpaRepository<BillingType, Integer> {
}
