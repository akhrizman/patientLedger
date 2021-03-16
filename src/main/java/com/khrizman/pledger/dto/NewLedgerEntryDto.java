package com.khrizman.pledger.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
public class NewLedgerEntryDto implements Serializable {
    private String initials;
    private int age;
    private Date startDate;
    private boolean entryComplete;
}
