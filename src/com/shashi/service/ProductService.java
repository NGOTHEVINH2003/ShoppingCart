package com.shashi.service;

import java.io.InputStream;
import java.util.List;

import com.shashi.beans.ProductBean;

public interface ProductService {

	public String addProduct(String prodName, String prodCategory, String prodInfo, double prodPrice, int prodQuantity,
			InputStream prodImage, boolean isActive);

	public String addProduct(ProductBean product);

	public String removeProduct(String prodId, boolean s);

	public String updateProduct(ProductBean prevProduct, ProductBean updatedProduct);

	public String updateProductPrice(String prodId, double updatedPrice);

	public List<ProductBean> getAllProducts();
        
        public List<ProductBean> getAllProductStock(String categoryId, boolean isActive, String searchKeyword);

	public List<ProductBean> getAllProductsByType(String type);

	public List<ProductBean> searchAllProducts(String search, String type);

	public byte[] getImage(String prodId);

	public ProductBean getProductDetails(String prodId);

	public String updateProductWithoutImage(String prevProductId, ProductBean updatedProduct);

	public double getProductPrice(String prodId);

	public boolean sellNProduct(String prodId, int n);

	public int getProductQuantity(String prodId);
}
