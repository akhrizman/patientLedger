package com.khrizman.pledger.model;

import com.khrizman.pledger.dto.NewLedgerEntryDto;
import lombok.*;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name="ledger_entry")
public class LedgerEntry implements Serializable {

    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private long id;

    private String initials;

    private int age;
    private boolean entryComplete;

    @Temporal(TemporalType.DATE)
    private Date startDate;

    @Column(insertable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;

    @Column(insertable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date modifiedDate;

    public LedgerEntry(NewLedgerEntryDto newLedgerEntryDto) {
        this.initials = newLedgerEntryDto.getInitials().toUpperCase();
        this.age = newLedgerEntryDto.getAge();
        this.entryComplete = newLedgerEntryDto.isEntryComplete();
        this.startDate = newLedgerEntryDto.getStartDate();
    }
}
