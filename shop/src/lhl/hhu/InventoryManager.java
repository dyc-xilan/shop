package lhl.hhu;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 库存管理器（单例），管理饮料和配料的库存及销量。
 */
public class InventoryManager {
    private static InventoryManager instance = new InventoryManager();

    private Map<String, Integer> stock;   // 当前库存
    private Map<String, Integer> sold;    // 累计销量

    private InventoryManager() {
        stock = new LinkedHashMap<String, Integer>();
        sold  = new LinkedHashMap<String, Integer>();
        // 初始库存
        stock.put("coca",   20);
        stock.put("coffee", 20);
        stock.put("milk",   20);
        stock.put("ice",    20);
        // 初始销量
        sold.put("coca",   0);
        sold.put("coffee", 0);
        sold.put("milk",   0);
        sold.put("ice",    0);
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

    /** 扣减库存并增加销量 */
    public void consume(String product, String decorator, int quantity) {
        // 扣减饮料
        if (product != null && stock.containsKey(product)) {
            stock.put(product, stock.get(product) - 1);
            sold.put(product, sold.get(product) + 1);
        }
        // 扣减配料（按份数）
        if (decorator != null && stock.containsKey(decorator)) {
            stock.put(decorator, stock.get(decorator) - quantity);
            sold.put(decorator, sold.get(decorator) + quantity);
        }
    }

    /** 补货 */
    public void restock(String item, int amount) {
        if (stock.containsKey(item) && amount > 0) {
            stock.put(item, stock.get(item) + amount);
        }
    }
}
