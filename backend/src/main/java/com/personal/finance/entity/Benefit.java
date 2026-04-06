package com.personal.finance.entity;

import com.personal.finance.enums.BenefitType;
import java.math.BigDecimal;
import java.time.*;
import jakarta.persistence.*;

@Entity
@Table(name = "benefits")
public class Benefit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "merchant_name", nullable = false, length = 256)
    private String merchantName;

    @Column(name = "merchant_category", length = 128)
    private String merchantCategory;

    @Enumerated(EnumType.STRING)
    @Column(name = "benefit_type", nullable = false)
    private BenefitType benefitType;

    @Column(name = "benefit_value", nullable = false)
    private BigDecimal benefitValue;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    @Column(name = "valid_from", nullable = false)
    private LocalDate validFrom;

    @Column(name = "valid_until", nullable = false)
    private LocalDate validUntil;

    @Column(name = "max_benefit", nullable = false)
    private BigDecimal maxBenefit;

    @Column(name = "min_spend", nullable = false)
    private BigDecimal minSpend;

    @Column(name = "conditions", nullable = false)
    private String conditions;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pid", nullable = false)
    private PaymentMethod paymentMethod;
}
