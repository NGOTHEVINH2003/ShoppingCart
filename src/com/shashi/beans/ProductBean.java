package com.shashi.beans;

import java.io.InputStream;
import java.io.Serializable;

@SuppressWarnings("serial")
public class ProductBean implements Serializable {

    public ProductBean() {
    }

    private String prodId;
    private String prodName;
    private String prodCategory;
    private String prodInfo;
    private double prodPrice;
    private int prodQuantity;
    private InputStream prodImage;
    private boolean isActive;

    public ProductBean(String prodId, String prodName, String prodCategory, String prodInfo, double prodPrice,
            int prodQuantity, InputStream prodImage,boolean isActive ) {
        super();
        this.prodId = prodId;
        this.prodName = prodName;
        this.prodInfo = prodInfo;
        this.prodCategory = prodCategory;
        this.prodPrice = prodPrice;
        this.prodQuantity = prodQuantity;
        this.prodImage = prodImage;
        this.isActive = isActive;
    }

    public String getProdId() {
        return prodId;
    }

    public void setProdId(String prodId) {
        this.prodId = prodId;
    }

    public String getProdName() {
        return prodName;
    }

    public void setProdName(String prodName) {
        this.prodName = prodName;
    }

    public String getProdInfo() {
        return prodInfo;
    }

    public void setProdInfo(String prodInfo) {
        this.prodInfo = prodInfo;
    }

    public double getProdPrice() {
        return prodPrice;
    }

    public void setProdPrice(double prodPrice) {
        this.prodPrice = prodPrice;
    }

    public int getProdQuantity() {
        return prodQuantity;
    }

    public void setProdQuantity(int prodQuantity) {
        this.prodQuantity = prodQuantity;
    }

    public InputStream getProdImage() {
        return prodImage;
    }

    public void setProdImage(InputStream prodImage) {
        this.prodImage = prodImage;
    }

    public String getProdCategory() {
        return prodCategory;
    }

    public void setProdCategory(String prodCategory) {
        this.prodCategory = prodCategory;
    }
    
    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}
