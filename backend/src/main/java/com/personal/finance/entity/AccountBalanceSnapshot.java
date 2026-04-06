package com.personal.finance.entity;

import java.math.BigDecimal;
import java.time.*;
import jakarta.persistence.*;

@Entity
@Table(name = "account_balance_snapshot", uniqueConstraints = @UniqueConstraint(columnNames = { "aid",
        "snapshot_date" })) // UNIQUE (aid, snapshot_date) 設定限制
public class AccountBalanceSnapshot {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "aid", nullable = false)
    private Account account;

    @Column(nullable = false)
    private BigDecimal balance;

    @Column(name = "snapshot_date", nullable = false)
    private LocalDate snapshotDate;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createAt;

    @PrePersist
    protected void onCreate() {
        createAt = LocalDateTime.now();
    }

}
