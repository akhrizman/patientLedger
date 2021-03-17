package com.khrizman.pledger.dto;

import com.khrizman.pledger.model.Billing;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BillingDto implements Serializable {
    private long id;
    private long ledgerEntryId;
    private int categoryId;
    private int billingTypeId;
    @Temporal(TemporalType.DATE)
    private Date serviceDate;
    private boolean billed;
    private boolean reportComplete;
}
