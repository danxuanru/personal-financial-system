# Personal Financial System (個人化消費系統)

本專案是一個結合記帳服務、支付優惠推薦與消費分析的個人化消費管理系統。使用者可以直接透過 **Telegram Bot** 以對話形式來進行記帳與查詢，獲得更直覺便捷的財務管理體驗。

## 🌟 核心功能 (Features)

- **💰 交易管理**：新增、查詢、修改與刪除個人的日常交易（收支）紀錄。
- **🏦 帳戶管理**：支援多帳戶架構，包含帳戶餘額追蹤、新增、查詢、修改與刪除。
- **💳 支付優惠推薦**：查詢當下最佳的支付優惠，系統會根據爬取的優惠資訊（如各類信用卡及電子支付）給予適當付款建議。
- **📊 消費分析**：查詢並統計個人的消費分析資料，掌握財務狀況。

## 🛠️ 技術棧 (Tech Stack)

- **後端框架**：Java 23 + Spring Boot
- **資料庫**：PostgreSQL 18 + Spring Data JPA
- **使用者介面**：Telegram Bot API
- **API 文件與開發工具**：Swagger UI (springdoc-openapi), Maven

## 📌 開發進度 (Current Progress)

專案正處於核心系統開發階段，詳細開發引導請參考 `notes/開發過程.md`。

### 目前已完成項目
- ✅ **Phase 0: 環境建置與驗證**
  - 完成 PostgreSQL 資料庫 (`financialSystemDB`) 建立。
  - 完成 9 張資料表（包含 Users, Accounts, Transactions 等）及 Enum Type 建置引擎。
  - 完成 Spring Boot 專案初始化，並順利連線至資料庫。
  - 成功設定機密環境變數 (`.env`) 以及 Swagger UI API 頁面。

### 即將開發項目
- 🔜 **Phase 1: Entity 層**：將建立好的資料表與 Java JPA Entity 進行 Mapping 與關聯。
- 🔜 **Phase 2: Repository 層**：實作資料庫的 CRUD 及客製化資料查詢功能。
- 🔜 **Phase 3~6: API 與邏輯開發**：實作 DTO 資料傳輸物件、Service 商業邏輯與核心 Controller。

## 📂 目錄結構簡介

- `/backend/`：Spring Boot 核心後端專案與設定檔（包含 POM、`.env.example` 等）。
- `/docs/`：放置資料庫設計腳本與專案參考文件。
- `/notes/`：開發過程的詳細步驟記錄（如 `開發過程.md`）與系統架構規劃。
