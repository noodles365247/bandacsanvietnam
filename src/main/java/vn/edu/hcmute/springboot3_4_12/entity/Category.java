package vn.edu.hcmute.springboot3_4_12.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "categories")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nameVi;
    private String nameEn;
    private String image;
    private Boolean status;

    @ToString.Exclude
    @ManyToMany(mappedBy = "categories")
    private List<Product> products = new ArrayList<>();

    // Manual Getters/Setters to bypass Lombok issues
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNameVi() { return nameVi; }
    public void setNameVi(String nameVi) { this.nameVi = nameVi; }
    public String getNameEn() { return nameEn; }
    public void setNameEn(String nameEn) { this.nameEn = nameEn; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public Boolean getStatus() { return status; }
    public void setStatus(Boolean status) { this.status = status; }
    public List<Product> getProducts() { return products; }
    public void setProducts(List<Product> products) { this.products = products; }
}
