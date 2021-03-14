package com.khrizman.pledger.repository;

import com.khrizman.pledger.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Integer> {

}
