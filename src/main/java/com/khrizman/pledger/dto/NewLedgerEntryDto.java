package com.khrizman.pledger.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
public class NewLedgerEntryDto implements Serializable {
    private String initials;
    private int age;
    @Temporal(TemporalType.DATE)
    private Date startDate;
    private boolean entryComplete;
}
