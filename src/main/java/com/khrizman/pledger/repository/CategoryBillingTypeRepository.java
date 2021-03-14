package com.khrizman.pledger.repository;

import com.khrizman.pledger.model.CategoryBillingType;
import com.khrizman.pledger.model.CategoryBillingTypeId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryBillingTypeRepository extends JpaRepository<CategoryBillingType, CategoryBillingTypeId> {
}
