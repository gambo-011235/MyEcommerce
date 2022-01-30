package it.example.myecommerce.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class Prodotto {

    @JsonProperty("nome_prodotto")
    private String nomeProdotto;

    @JsonProperty("descrizione_analizzata")
    private String descrizioneAnalizzata;

    @JsonProperty("macro_categoria")
    private String macroCategoria;

    @JsonProperty("sotto_categoria")
    private String sottoCategoria;

    @JsonProperty("larghezza")
    private Integer larghezza;

    @JsonProperty("consegna_gratuita")
    private Boolean consegnaGratuita;

    @JsonProperty("prezzo")
    private BigDecimal prezzo;

    @JsonProperty("data_creazione")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
    private Date dataCreazione;

    @JsonProperty("produttore")
    private Produttore produttore;

    @JsonProperty("intervallo_validita")
    private IntervalloDate intervalloDate;

    @JsonProperty("certificazioni")
    private String[] certificazioni;

    @JsonProperty("numero_certificazioni_necessarie")
    private String numeroCertificazioniNecessarie;

}
