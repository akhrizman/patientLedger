package com.khrizman.pledger.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;
import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name="category_billing_type")
@IdClass(CategoryBillingTypeId.class)
public class CategoryBillingType implements Serializable {
    @Id
    private int categoryId;

    @Id
    private int billingTypeId;

}
