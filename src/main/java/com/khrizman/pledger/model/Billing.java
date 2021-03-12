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
    private int id;

    private int ledger_entry_id;
    private int billingTypeId;
    private int categoryId;
    private boolean billed;
    private boolean reportComplete;

    @Temporal(TemporalType.DATE)
    private Date serviceDate;

    @Temporal(TemporalType.DATE)
    private Date createdDate;
    @Temporal(TemporalType.DATE)
    private Date modifiedDate;


}
