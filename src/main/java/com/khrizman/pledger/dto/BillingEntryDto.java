package com.khrizman.pledger.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BillingEntryDto implements Serializable {
    @Temporal(TemporalType.DATE)
    private Date serviceDate;
    private long billingId;
    private long ledgerEntryId;
    private String category;
    private String billingType;
    private boolean billed;
    private boolean reportComplete;
    private String initials;
    private int age;
}
