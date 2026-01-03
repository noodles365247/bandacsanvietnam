package vn.edu.hcmute.springboot3_4_12.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "blogs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Blog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String titleVi;
    private String titleEn;

    @Column(columnDefinition = "TEXT")
    private String contentVi;

    @Column(columnDefinition = "TEXT")
    private String contentEn;
    @ToString.Exclude
    @ManyToOne private User author;
    @ToString.Exclude
    @ManyToMany
    @JoinTable(
            name = "blog_product",
            joinColumns = @JoinColumn(name = "blog_id"),
            inverseJoinColumns = @JoinColumn(name = "product_id")
    )
    private List<Product> products = new ArrayList<>();

    // Manual Getters/Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitleVi() { return titleVi; }
    public void setTitleVi(String titleVi) { this.titleVi = titleVi; }
    public String getTitleEn() { return titleEn; }
    public void setTitleEn(String titleEn) { this.titleEn = titleEn; }
    public String getContentVi() { return contentVi; }
    public void setContentVi(String contentVi) { this.contentVi = contentVi; }
    public String getContentEn() { return contentEn; }
    public void setContentEn(String contentEn) { this.contentEn = contentEn; }
    public User getAuthor() { return author; }
    public void setAuthor(User author) { this.author = author; }
    public List<Product> getProducts() { return products; }
    public void setProducts(List<Product> products) { this.products = products; }
}

