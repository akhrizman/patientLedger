package com.khrizman.pledger.dto;

import com.khrizman.pledger.model.Billing;
import com.khrizman.pledger.model.LedgerEntry;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
public class LedgerEntryDto implements Serializable {
    private LedgerEntry ledgerEntry;
    private String name;
    private List<Billing> billings;
    private Map<Integer,String> categoryMap;
    private Map<Integer,String> billingTypeMap;
    private Map<Integer,List<Integer>> categoryToBillingTypesMap;

    public LedgerEntryDto(LedgerEntry ledgerEntry) {
        this.ledgerEntry = ledgerEntry;
        this.name = getNameForSelection();
    }

    public LedgerEntryDto(Map<Integer,String> categoryMap,
                          Map<Integer,String> billingTypeMap,
                          Map<Integer,List<Integer>> categoryToBillingTypeMap) {
        this.categoryMap = categoryMap;
        this.billingTypeMap = billingTypeMap;
        this.categoryToBillingTypesMap = categoryToBillingTypeMap;
    }

    public LedgerEntryDto(List<Billing> billings, Map<Integer,String> categoryMap, Map<Integer,String> billingTypeMap) {
        this.billings = billings;
        this.categoryMap = categoryMap;
        this.billingTypeMap = billingTypeMap;
    }

    private String getNameForSelection() {
        return ledgerEntry.getInitials() + "-" + ledgerEntry.getAge() + " ("+ ledgerEntry.getStartDate() + ")";
    }


}
