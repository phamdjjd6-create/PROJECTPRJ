package service;

import DAO.AuditLogDAO;
import model.TblAuditLog;
import java.util.List;
import java.util.stream.Collectors;

public class AuditLogService {
    private final AuditLogDAO auditLogDAO;
    private final AiService aiService;

    public AuditLogService() {
        this.auditLogDAO = new AuditLogDAO();
        this.aiService = new AiService();
    }

    public List<TblAuditLog> findAll() {
        return auditLogDAO.findAll();
    }

    /**
     * Tóm tắt hoạt động gần đây bằng AI.
     */
    public String getAiDailySummary() {
        // Lấy 50 hoạt động gần nhất
        List<TblAuditLog> logs = auditLogDAO.findRecent(50);
        if (logs.isEmpty()) return "Chưa có hoạt động nào được ghi nhận.";

        String logsText = logs.stream()
                .map(log -> String.format("[%s] %s bởi %s: %s (ID: %s)",
                        log.getChangedAt().toString(), log.getAction(),
                        log.getChangedBy() != null ? log.getChangedBy() : "Hệ thống",
                        log.getTableName(), log.getRecordId()))
                .collect(Collectors.joining("\n"));

        return aiService.summarizeAuditLogs(logsText);
    }
}
