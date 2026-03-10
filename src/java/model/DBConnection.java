package model;

import java.sql.Connection;
import java.sql.SQLException;
import com.microsoft.sqlserver.jdbc.SQLServerDataSource;

public class DBConnection {

    private static final String SERVER = "MSI";
    private static final String USER = "sa";
    private static final String PASSWORD = "123123";
    private static final String DATABASE = "CarBooking";
    private static final int PORT = 1433;

    public static Connection getConnection() {
        SQLServerDataSource ds = new SQLServerDataSource();

        ds.setServerName(SERVER);
        ds.setPortNumber(PORT);
        ds.setUser(USER);
        ds.setPassword(PASSWORD);
        ds.setDatabaseName(DATABASE);
        ds.setEncrypt("true");
        ds.setTrustServerCertificate(true);

        try {
            return ds.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
