package com.khrizman.pledger.dto;

import com.khrizman.pledger.model.Billing;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
public class BillingDto implements Serializable {
    private int id;
    private int ledgerEntryId;
    private int categoryId;
    private int billingTypeId;
    private Date serviceDate;
    private boolean billed;
    private boolean reportComplete;

    public BillingDto(Billing billing) {
        this.id = billing.getId();
        this.ledgerEntryId = billing.getId();
        this.categoryId = billing.getCategoryId();
        this.billingTypeId = billing.getBillingTypeId();
        this.serviceDate = billing.getServiceDate();
        this.billed = billing.isBilled();
        this.reportComplete = billing.isReportComplete();
    }
}
