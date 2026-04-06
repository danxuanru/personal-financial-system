package com.personal.finance.entity;

import com.personal.finance.enums.CrawlStatus;
import java.time.*;
import jakarta.persistence.*;

@Entity
@Table(name = "crawl_snapshot")
public class CrawlSnapshot {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "source_url", nullable = false, length = 256)
    private String sourceUrl;

    @Column(name = "issuer", nullable = false, length = 128)
    private String issuer;

    @Column(name = "raw_data", nullable = false, columnDefinition = "TEXT")
    private String rawData;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private CrawlStatus status;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bid", nullable = false)
    private Benefit benefit;

    @PrePersist
    protected void onCreate() {
        createAt = LocalDateTime.now();
        status = CrawlStatus.pending;
    }
}
