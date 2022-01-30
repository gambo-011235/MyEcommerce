package it.example.myecommerce;


import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch._types.aggregations.Aggregation;
import co.elastic.clients.elasticsearch._types.aggregations.LongTermsBucket;
import co.elastic.clients.elasticsearch._types.query_dsl.Query;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import co.elastic.clients.elasticsearch.core.search.Hit;
import co.elastic.clients.util.ObjectBuilder;
import it.example.myecommerce.dto.Aggregazione;
import it.example.myecommerce.dto.Prodotto;
import it.example.myecommerce.dto.Risposta;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

@Slf4j
@Controller
public class MyEcommerceController {

    @Autowired
    private ElasticsearchClient elasticsearchClient;

    @RequestMapping("/MyEcommerce")
    public String index(Model model) {
        return "index.html";
    }

    /**
     * Endpoint di ricerca
     */
    @RequestMapping("/search")
    @ResponseBody
    public Risposta result(
            @RequestParam(required = false, value = "descrizione") String descrizione,
            @RequestParam(required = false, value = "consegna_gratis") String consegnaGratis
    ) throws IOException{

        List<Prodotto> prodottoList = new ArrayList<>();
        List<Aggregazione> aggregazioneList = new ArrayList<>();

        SearchResponse<Prodotto> search;

        search = elasticsearchClient.search(s -> s
                .index("my_ecommerce")
                .size(100)
                .query(
                        getCompoundQuery(descrizione, consegnaGratis)
                )
                .aggregations("consegna", Aggregation.of(
                    a -> a.terms(
                            t -> t.field("consegna_gratuita")
                    )
                )),
        Prodotto.class);

        for (Hit<Prodotto> hit: search.hits().hits()) {
            log.info(hit.source().toString());
            prodottoList.add(hit.source());
        }

        for(String aggregazione : search.aggregations().keySet()){
            Map<String, Long> mappa = new HashMap<String, Long>();

            log.info(search.aggregations().get(aggregazione).lterms().buckets().array().toString());

            for(LongTermsBucket bucket : search.aggregations().get(aggregazione).lterms().buckets().array()){
                mappa.put(bucket.keyAsString(), bucket.docCount());
            }

            aggregazioneList.add(new Aggregazione(aggregazione, mappa));
        }

        return new Risposta(prodottoList, aggregazioneList);
    }

    /**
     * Creazione di una query composta con filtri e ricerca full text
     */
    private Function<Query.Builder, ObjectBuilder<Query>> getCompoundQuery(String descrizione, String consegnaGratis){
        if(descrizione != null && consegnaGratis == null){
            return getSearchBoxFilter(descrizione);
        } else if(descrizione == null && consegnaGratis != null){
            return getFilter(consegnaGratis);
        } else if(descrizione != null && consegnaGratis != null){
            return q -> q.bool(
                b -> b.must(
                    getSearchBoxFilter(descrizione)
                ).filter(
                    getFilter(consegnaGratis)
                )
            );
        } else {
            return q -> q.matchAll(t -> t);
        }
    }

    /**
     * Ricerca full text sulle descrizioni dei prodotti
     */
    private Function<Query.Builder, ObjectBuilder<Query>> getSearchBoxFilter(String descrizione){

        if(descrizione == null) return null;

        return m -> m.match(t -> t
                        .field("descrizione_analizzata")
                        .query(v -> v.stringValue(descrizione))
                //.operator(Operator.And)
        );
    }

    /**
     * Applicazione del filter alla query di ricerca (sulla base dei filtri posti su determinati valori)
     */
    private Function<Query.Builder, ObjectBuilder<Query>> getFilter(String consegnaGratis){

        if(consegnaGratis == null) return null;

        return f -> f.term(t -> t
                .field("consegna_gratuita")
                .value(v -> v.stringValue(consegnaGratis))
        );
    }
}