package com.personal.finance.entity;

import java.time.LocalDateTime;
import jakarta.persistence.*;

@Entity
@Table(name = "users") // 映射到users資料表

public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 256)
    private String name;

    @Column(name = "telegram_bot_id", nullable = false, length = 256)
    private String telegramBotId;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createAt;

    @PrePersist // 第一次insert前需要執行的方法
    protected void onCreate() {
        createAt = LocalDateTime.now();
    }

}