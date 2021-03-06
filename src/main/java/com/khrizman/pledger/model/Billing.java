package com.khrizman.pledger.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name="billing")
public class Billing implements Serializable {

    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private long id;

    private long ledgerEntryId;
    private int billingTypeId;
    private int categoryId;
    private boolean billed;
    private boolean reportComplete;

    @Temporal(TemporalType.DATE)
    private Date serviceDate;

    @Column(insertable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdDate;
    @Column(insertable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date modifiedDate;


}
