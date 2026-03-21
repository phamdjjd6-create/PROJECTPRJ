package controller; // using existing package for classpath ease

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DBFixer {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=ResortDB;encrypt=true;trustServerCertificate=true";
        String user = "sa";
        String pass = "123";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {

            System.out.println("Connected to ResortDB. Applying fixes...");

            // 1. Fix tbl_facilities missing usage_count
            try {
                stmt.execute("ALTER TABLE tbl_facilities ADD usage_count INT NOT NULL DEFAULT 0;");
                System.out.println("Added usage_count to tbl_facilities.");
            } catch (Exception e) {
                System.out.println("usage_count might already exist: " + e.getMessage());
            }

            // 2. Recreate vw_contracts exactly as Java expects
            String viewSql = "CREATE OR ALTER VIEW vw_contracts AS\n" +
                    "SELECT \n" +
                    "    ct.contract_id,\n" +
                    "    ct.deposit,\n" +
                    "    ct.total_payment,\n" +
                    "    ct.paid_amount,\n" +
                    "    (ct.total_payment - ct.paid_amount) AS remaining_amount,\n" +
                    "    ct.status,\n" +
                    "    ct.signed_date,\n" +
                    "    ct.notes,\n" +
                    "    b.booking_id,\n" +
                    "    CONVERT(VARCHAR(10), b.start_date, 120) AS start_date,\n" +
                    "    CONVERT(VARCHAR(10), b.end_date,   120) AS end_date,\n" +
                    "    b.facility_id,\n" +
                    "    pc.id          AS customer_id,\n" +
                    "    pc.full_name   AS customer_name,\n" +
                    "    pe.id          AS employee_id,\n" +
                    "    pe.full_name   AS employee_name\n" +
                    "FROM tbl_contracts ct\n" +
                    "JOIN tbl_bookings  b   ON ct.booking_id  = b.booking_id\n" +
                    "JOIN tbl_persons   pc  ON b.customer_id  = pc.id\n" +
                    "JOIN tbl_facilities f  ON b.facility_id  = f.service_code\n" +
                    "LEFT JOIN tbl_employees e   ON ct.employee_id = e.id\n" +
                    "LEFT JOIN tbl_persons   pe  ON e.id = pe.id;";

            stmt.execute(viewSql);
            System.out.println("Recreated vw_contracts successfully.");

            System.out.println("All Database fixes applied!).");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
