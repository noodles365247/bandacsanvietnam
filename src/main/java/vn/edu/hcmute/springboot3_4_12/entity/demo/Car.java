package vn.edu.hcmute.springboot3_4_12.entity.demo;

import jakarta.persistence.*;
import lombok.*;


@Entity
@Table(name = "cardemo")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class Car {


    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String make;
    private int numberOfSeats;
    private String  type;

    //constructor, getters, setters etc.
}