package lhl.hhu;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 库存管理器（单例），内存缓存 + 数据库持久化。
 */
public class InventoryManager {
    private static InventoryManager instance = new InventoryManager();

    private Map<String, Integer> stock;   // 当前库存（内存缓存）
    private Map<String, Integer> sold;    // 累计销量（内存缓存）
    private DatabaseManager db;           // 数据库管理器

    private InventoryManager() {
        db = DatabaseManager.getInstance();
        // 从数据库加载库存与销量
        stock = db.loadStock();
        sold  = db.loadSold();
    }

    public static InventoryManager getInstance() {
        return instance;
    }

    public Map<String, Integer> getStock() {
        return stock;
    }

    public Map<String, Integer> getSold() {
        return sold;
    }

    /** 检查饮料库存是否足够 */
    public boolean checkStock(String product) {
        Integer s = stock.get(product);
        return s != null && s > 0;
    }

    /** 检查配料库存是否足够（需要份数） */
    public boolean checkStock(String decorator, int quantity) {
        Integer s = stock.get(decorator);
        return s != null && s >= quantity;
    }

    /** 扣减库存并增加销量（同步写入数据库） */
    public synchronized void consume(String product, String decorator, int quantity) {
        // 1. 更新内存
        if (product != null && stock.containsKey(product)) {
            stock.put(product, stock.get(product) - 1);
            sold.put(product, sold.get(product) + 1);
        }
        if (decorator != null && stock.containsKey(decorator)) {
            stock.put(decorator, stock.get(decorator) - quantity);
            sold.put(decorator, sold.get(decorator) + quantity);
        }
        // 2. 同步写入数据库
        db.consume(product, decorator, quantity);
    }

    /** 补货（同步写入数据库） */
    public synchronized void restock(String item, int amount) {
        if (stock.containsKey(item) && amount > 0) {
            stock.put(item, stock.get(item) + amount);
            db.restock(item, amount);
        }
    }
}
