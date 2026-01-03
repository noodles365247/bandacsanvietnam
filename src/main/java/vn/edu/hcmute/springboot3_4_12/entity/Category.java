package vn.edu.hcmute.springboot3_4_12.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

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
}