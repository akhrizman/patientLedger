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

    public LedgerEntryDto(LedgerEntry ledgerEntry) {
        this.ledgerEntry = ledgerEntry;
        this.name = getNameForSelection();
    }

    private String getNameForSelection() {
        return ledgerEntry.getInitials() + "-" + ledgerEntry.getAge() + " ("+ ledgerEntry.getStartDate() + ")";
    }


}
