package vn.edu.hcmute.springboot3_4_12.entity;

import jakarta.persistence.*;
import lombok.ToString;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "blogs")
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

}

