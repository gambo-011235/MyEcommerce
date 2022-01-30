package it.example.myecommerce.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Map;

@Data
@AllArgsConstructor
public class Aggregazione {
    private String nome;
    private Map<String, Long> valori;  // valore -> conteggio documenti
}
