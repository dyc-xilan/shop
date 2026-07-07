package lhl.hhu;

public class ShopClientBean {
    private String product = "";
    private String decorator = "";
    private String description = "您还没有点饮料。";
    private double price = 0;

    public String getProduct() {
        return product;
    }
    public void setProduct(String product) {
        this.product = product;
    }
    public String getDecorator() {
        return decorator;
    }
    public void setDecorator(String decorator) {
        this.decorator = decorator;
    }
    public double getPrice() {
        return price;
    }
    public void setPrice(double price) {
        this.price = price;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
}