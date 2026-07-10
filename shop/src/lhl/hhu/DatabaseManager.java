package lhl.hhu;

import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 数据库管理器（单例），基于 MySQL 持久化库存与销量。
 * 首次启动自动创建 shop 数据库和 inventory 表。
 */
public class DatabaseManager {
    //数据库连接配置
    private static final String HOST = "localhost";
    private static final int    PORT = 3306;
    private static final String USER = "root";
    private static final String PASS = "dyc041213";
    private static final String DB   = "shop";
   

    private static DatabaseManager instance;
    private Connection conn;

    private static final String[] ITEMS = {"coca", "coffee", "milk", "ice"};

    private DatabaseManager() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. 连接 MySQL，自动建库
            String baseUrl = "jdbc:mysql://" + HOST + ":" + PORT
                    + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            Connection tmp = DriverManager.getConnection(baseUrl, USER, PASS);
            Statement s = tmp.createStatement();
            s.executeUpdate("CREATE DATABASE IF NOT EXISTS `" + DB
                    + "` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            s.close();
            tmp.close();

            // 2. 连接目标数据库
            String dbUrl = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DB
                    + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            conn = DriverManager.getConnection(dbUrl, USER, PASS);

            // 3. 建表 + 初始化
            createTableIfNotExists();
            initDefaults();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static synchronized DatabaseManager getInstance() {
        if (instance == null) {
            instance = new DatabaseManager();
        }
        return instance;
    }

    private void createTableIfNotExists() throws SQLException {
        Statement s = conn.createStatement();
        s.execute(
            "CREATE TABLE IF NOT EXISTS inventory (" +
            "  item  VARCHAR(20) PRIMARY KEY," +
            "  stock INT DEFAULT 20," +
            "  sold  INT DEFAULT 0" +
            ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
        );
        s.close();
    }

    /** 首次启动插入默认数据，已存在则忽略 */
    private void initDefaults() throws SQLException {
        for (String item : ITEMS) {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT IGNORE INTO inventory (item, stock, sold) VALUES (?, 20, 0)"
            );
            ps.setString(1, item);
            ps.executeUpdate();
            ps.close();
        }
    }

    /** 从数据库加载库存 */
    public Map<String, Integer> loadStock() {
        Map<String, Integer> map = new LinkedHashMap<>();
        try {
            Statement s = conn.createStatement();
            ResultSet rs = s.executeQuery("SELECT item, stock FROM inventory");
            while (rs.next()) {
                map.put(rs.getString("item"), rs.getInt("stock"));
            }
            rs.close(); s.close();
        } catch (SQLException e) {
            e.printStackTrace();
            for (String item : ITEMS) map.put(item, 20);
        }
        return map;
    }

    /** 从数据库加载销量 */
    public Map<String, Integer> loadSold() {
        Map<String, Integer> map = new LinkedHashMap<>();
        try {
            Statement s = conn.createStatement();
            ResultSet rs = s.executeQuery("SELECT item, sold FROM inventory");
            while (rs.next()) {
                map.put(rs.getString("item"), rs.getInt("sold"));
            }
            rs.close(); s.close();
        } catch (SQLException e) {
            e.printStackTrace();
            for (String item : ITEMS) map.put(item, 0);
        }
        return map;
    }

    /** 扣减库存 + 增加销量（事务保护） */
    public synchronized void consume(String product, String decorator, int quantity) {
        try {
            conn.setAutoCommit(false);

            if (product != null && !product.isEmpty()) {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE inventory SET stock = stock - 1, sold = sold + 1 WHERE item = ? AND stock > 0"
                );
                ps.setString(1, product);
                ps.executeUpdate();
                ps.close();
            }

            if (decorator != null && !decorator.isEmpty() && quantity > 0) {
                PreparedStatement ps = conn.prepareStatement(
                    "UPDATE inventory SET stock = stock - ?, sold = sold + ? WHERE item = ? AND stock >= ?"
                );
                ps.setInt(1, quantity);
                ps.setInt(2, quantity);
                ps.setString(3, decorator);
                ps.setInt(4, quantity);
                ps.executeUpdate();
                ps.close();
            }

            conn.commit();
            conn.setAutoCommit(true);
        } catch (SQLException e) {
            e.printStackTrace();
            try { conn.rollback(); } catch (SQLException ignored) {}
        }
    }

    /** 补货 */
    public synchronized void restock(String item, int amount) {
        try {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE inventory SET stock = stock + ? WHERE item = ?"
            );
            ps.setInt(1, amount);
            ps.setString(2, item);
            ps.executeUpdate();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** 关闭连接 */
    public void shutdown() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
