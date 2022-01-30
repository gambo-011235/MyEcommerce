package it.example.myecommerce.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class Risposta {
    private List<Prodotto> prodottoList;
    private List<Aggregazione> aggregazioneList;
}
