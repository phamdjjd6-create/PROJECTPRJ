package service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

public class KnowledgeService {

    private static String cachedKnowledge = null;

    public String getResortKnowledge() {
        if (cachedKnowledge != null) return cachedKnowledge;
        
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("resort_knowledge.md")) {
            if (is == null) return "Thông tin resort hiện đang được cập nhật.";
            
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                cachedKnowledge = reader.lines().collect(Collectors.joining("\n"));
                return cachedKnowledge;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Lỗi khi tải thông tin resort.";
        }
    }
}
