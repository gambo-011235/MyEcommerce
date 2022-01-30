#!/bin/bash
curl -XDELETE "http://localhost:9200/my_ecommerce" -H 'Content-Type: application/json'
curl -XPUT "http://localhost:9200/my_ecommerce" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "analysis": {

      "char_filter": {
        "filtro_unita_misura": {
            "type": "mapping",
            "mappings": [
            "cm => centimetri",
            "mm => metri",
            "cl => centilitri"
          ]
        }
      },

      "filter": {

        "stopword_italiane": {
          "type": "stop",
          "stopwords": "_italian_"
        },

        "stemmer_italiano": {
          "type": "stemmer",
          "language": "italian"
        },

        "sinonimi": {
          "type": "synonym",
          "synonyms": [
              "tosaerba, tagliaerba",
              "mazzetta, hammer => martello",
              "telefono => iphone, cellulare"
            ]
        }

      },

      "analyzer": {
        "ecommerce_custom_analyzer": {
          "type": "custom",
          "tokenizer": "standard",
          "filter":  [
            "lowercase",
            "asciifolding",
            "sinonimi",
            "stopword_italiane",
            "stemmer_italiano"
            ],
          "char_filter": [
              "filtro_unita_misura"
            ]
        }
      }

    }
  },

  "mappings": {
    "properties": {
      "nome_prodotto": {
        "type": "text"
      },
      "descrizione_analizzata": {
        "type": "text",
        "analyzer": "ecommerce_custom_analyzer"
      },

      "macro_categoria": {
        "type": "keyword"
      },
      "sotto_categoria": {
        "type": "keyword"
      },
      "dimensione_lama": {
        "type": "long"
      },
      "altezza": {
        "type": "integer"
      },
      "larghezza": {
        "type": "integer"
      },
      "consegna_gratuita": {
        "type": "boolean"
      },
      "prezzo": {
        "type": "float"
      },
      "data_creazione": {
        "type": "date",
        "format": "dd-MM-yyyy||dd/MM/yyyy"
      },
      "costo": {
        "type": "alias",
        "path": "prezzo"
      },
      "produttore": {
        "properties": {
          "ragione_sociale": {
            "type": "keyword"
          },
          "descrizione_azienda": {
            "type": "text"
          },
          "indirizzo": {
            "properties": {
              "paese": {
                "type": "keyword"
              },
              "indirizzo": {
                "type": "keyword"
              }
            }
          }
        }
      },
      "dimensione_lame_compatibili": {
        "type": "integer_range"
      },
      "intervallo_validita": {
        "type": "date_range",
        "format": "dd-MM-yyyy HH:mm:ss||dd/MM/yyyy HH:mm:ss||epoch_millis"
      },
      "certificazioni": {
        "type": "keyword"
      },
      "numero_certificazioni_necessarie": {
        "type": "long"
      }
    }
  }
}'

curl -XPOST "http://localhost:9200/my_ecommerce/_create/1" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Tosaerba SUPER",
  "descrizione_analizzata": "Tosaerba verde con lama 30 cm",
  "macro_categoria": "giardinaggio",
  "sotto_categoria": "tosaerba",
  "altezza": 100,
  "larghezza": 50,
  "consegna_gratuita": false,
  "prezzo": "225.34",
  "data_creazione": "01/05/2022",
  "produttore": {
    "ragione_sociale": "ABC123",
    "descrizione_azienda": "fornitore classico",
    "indirizzo": {
      "paese": "milano",
      "indirizzo": "via falsa 123"
    }
  },
  "dimensione_lame_compatibili": {
    "gte" : 25,
    "lt" : 30
  },
  "intervallo_validita": {
    "gte" : "02-01-2022 00:00:00",
    "lte" : "15-06-2022 23:59:59"
  },
  "nota_aggiuntiva": "fornitura discontinua",
  "profondita_test": 122
}'



curl -XPOST "http://localhost:9200/my_ecommerce/_create/2" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Tosaerba Mega",
  "descrizione_analizzata": "Tosaerba rinforzato, scocca rossa con lama 45 cm",
  "macro_categoria": "giardinaggio",
  "sotto_categoria": "tosaerba",
  "altezza": 125,
  "larghezza": 50,
  "consegna_gratuita": true,
  "prezzo": "235.34",
  "data_creazione": "01/05/2022",
  "produttore": {
    "ragione_sociale": "ABC123",
    "descrizione_azienda": "fornitore classico",
    "indirizzo": {
      "paese": "milano",
      "indirizzo": "via falsa 123"
    }
  },
  "dimensione_lame_compatibili": {
    "gte" : 40,
    "lt" : 45
  },
  "intervallo_validita": {
    "gte" : "02-05-2022 00:00:00",
    "lte" : "15-06-2022 23:59:59"
  }
}'


curl -XPOST "http://localhost:9200/my_ecommerce/_create/3" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Tosaerba Giga",
  "descrizione_analizzata": "Tagliaerba di colore azzurro con lama 40 cm",
  "macro_categoria": "giardinaggio",
  "sotto_categoria": "tosaerba",
  "altezza": 130,
  "larghezza": 40,
  "consegna_gratuita": true,
  "prezzo": "100",
  "data_creazione": "01/05/2022",
  "produttore": {
    "ragione_sociale": "ABC123",
    "descrizione_azienda": "fornitore classico",
    "indirizzo": {
      "paese": "milano",
      "indirizzo": "via falsa 123"
    }
  },
  "dimensione_lame_compatibili": {
    "gte" : 40,
    "lt" : 45
  },
  "intervallo_validita": {
    "gte" : "02-01-2022 00:00:00",
    "lte" : "15-06-2022 23:59:59"
  }
}'


curl -XPOST "http://localhost:9200/my_ecommerce/_create/4" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Cacciavite a stella piccolo",
  "descrizione_analizzata": "Cacciavite a stella diametro 5mm",
  "macro_categoria": "utensileria",
  "sotto_categoria": "cacciaviti",
  "larghezza": 5,
  "consegna_gratuita": true,
  "prezzo": "5",
  "data_creazione": "10/05/2022",
  "produttore": {
    "ragione_sociale": "COD_000",
    "descrizione_azienda": "fornitore nuovo",
    "indirizzo": {
      "paese": "milano",
      "indirizzo": "via nuova 456"
    }
  },
  "intervallo_validita": {
    "gte" : "10-05-2022 00:00:00",
    "lte" : "15-08-2022 23:59:59"
  }
}'


curl -XPOST "http://localhost:9200/my_ecommerce/_create/5" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Cacciavite a stella medio",
  "descrizione_analizzata": "Cacciavite a stella diametro 7mm",
  "macro_categoria": "utensileria",
  "sotto_categoria": "cacciaviti",
  "larghezza": 7,
  "consegna_gratuita": true,
  "prezzo": "10",
  "data_creazione": "10/05/2022",
  "produttore": {
    "ragione_sociale": "COD_000",
    "descrizione_azienda": "fornitore nuovo",
    "indirizzo": {
      "paese": "milano",
      "indirizzo": "via nuova 456"
    }
  },
  "intervallo_validita": {
    "gte" : "10-01-2022 00:00:00",
    "lte" : "15-08-2022 23:59:59"
  }
}'


curl -XPOST "http://localhost:9200/my_ecommerce/_create/6" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Cacciavite piatto dimensione media",
  "descrizione_analizzata": "Cacciavite a stella diametro 7mm",
  "macro_categoria": "utensileria",
  "sotto_categoria": "cacciaviti",
  "larghezza": 7,
  "consegna_gratuita": true,
  "prezzo": "12",
  "data_creazione": "10/05/2022",
  "produttore": {
    "ragione_sociale": "COD_000",
    "descrizione_azienda": "fornitore nuovo",
    "indirizzo": {
      "paese": "milano",
      "indirizzo": "via nuova 456"
    }
  },
  "intervallo_validita": {
    "gte" : "10-05-2022 00:00:00",
    "lte" : "15-08-2022 23:59:59"
  }
}'
curl -XPOST "http://localhost:9200/my_ecommerce/_create/7" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Cacciavite piatto dimensione grande",
  "descrizione_analizzata": "Cacciavite a stella diametro 10mm",
  "macro_categoria": "utensileria",
  "sotto_categoria": "cacciaviti",
  "larghezza": 10,
  "consegna_gratuita": true,
  "prezzo": "20",
  "data_creazione": "10/05/2022",
  "produttore": {
    "ragione_sociale": "COD_000",
    "descrizione_azienda": "fornitore nuovo",
    "indirizzo": {
      "paese": "milano",
      "indirizzo": "via nuova 456"
    }
  },
  "intervallo_validita": {
    "gte" : "10-05-2022 00:00:00",
    "lte" : "15-08-2022 23:59:59"
  },
  "nota_aggiuntiva": "Sempre disponibile"
}'
curl -XPOST "http://localhost:9200/my_ecommerce/_create/8" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Portacacciaviti grandi",
  "descrizione_analizzata": "Portacacciaviti compatibile con cacciaviti di diametro 10mm",
  "macro_categoria": "utensileria",
  "sotto_categoria": "altro",
  "larghezza": 10,
  "consegna_gratuita": true,
  "prezzo": "50",
  "data_creazione": "10/05/2022",
  "produttore": {
    "ragione_sociale": "COD_999",
    "descrizione_azienda": "fornitore nuovo",
    "indirizzo": {
      "paese": "torino",
      "indirizzo": "via roma 879"
    }
  },
  "intervallo_validita": {
    "gte" : "11-01-2022 00:00:00",
    "lte" : "13-08-2022 23:59:59"
  }
}'
curl -XPOST "http://localhost:9200/my_ecommerce/_create/9" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Portacacciaviti grandi blu",
  "descrizione_analizzata": "Portacacciaviti compatibile con cacciaviti di diametro 10mm colore blu",
  "macro_categoria": "utensileria",
  "sotto_categoria": "altro",
  "larghezza": 10,
  "consegna_gratuita": true,
  "prezzo": "55",
  "data_creazione": "10/05/2022",
  "produttore": {
    "ragione_sociale": "COD_999",
    "descrizione_azienda": "fornitore nuovo",
    "indirizzo": {
      "paese": "torino",
      "indirizzo": "via roma 879"
    }
  },
  "intervallo_validita": {
    "gte" : "11-05-2022 00:00:00",
    "lte" : "13-08-2022 23:59:59"
  },
  "nota_aggiuntiva": null
}'
curl -XPOST "http://localhost:9200/my_ecommerce/_create/10" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Portacacciaviti grandi giallo",
  "descrizione_analizzata": "Portacacciaviti compatibile con cacciaviti di diametro 10mm colore giallo",
  "macro_categoria": "utensileria",
  "sotto_categoria": "altro",
  "larghezza": 10,
  "consegna_gratuita": true,
  "prezzo": "55",
  "data_creazione": "10/05/2022",
  "produttore": {
    "ragione_sociale": "COD_999",
    "descrizione_azienda": "fornitore nuovo",
    "indirizzo": {
      "paese": "torino",
      "indirizzo": "via roma 879"
    }
  },
  "intervallo_validita": {
    "gte" : "11-01-2022 00:00:00",
    "lte" : "13-08-2022 23:59:59"
  },
  "certificazioni": ["ISO-100", "ISO-200", "ISO-300"],
  "numero_certificazioni_necessarie": "2"
}'
curl -XPOST "http://localhost:9200/my_ecommerce/_create/11" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Portacacciaviti grandi verde",
  "descrizione_analizzata": "Portacacciaviti compatibile con cacciaviti di diametro 10mm colore verde",
  "macro_categoria": "utensileria",
  "sotto_categoria": "altro",
  "larghezza": 10,
  "consegna_gratuita": true,
  "prezzo": "60",
  "data_creazione": "16/05/2022",
  "produttore": {
    "ragione_sociale": "COD_456",
    "descrizione_azienda": "fornitore alternativo",
    "indirizzo": {
      "paese": "novara",
      "indirizzo": "via venezia 879"
    }
  },
  "intervallo_validita": {
    "gte" : "11-05-2022 00:00:00",
    "lte" : "13-08-2022 23:59:59"
  },
  "certificazioni": ["ISO-100", "ISO-200", "ISO-800", "ISO-900"],
  "numero_certificazioni_necessarie": "3"
}'
curl -XPOST "http://localhost:9200/my_ecommerce/_create/12" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Concime per prati",
  "descrizione_analizzata": "Concime per far crescere prati di erba",
  "macro_categoria": "giardinaggio",
  "sotto_categoria": "altro",
  "larghezza": 0,
  "consegna_gratuita": false,
  "prezzo": "5",
  "data_creazione": "20/05/2022",
  "produttore": {
    "ragione_sociale": "COD_1",
    "descrizione_azienda": "fornitore1",
    "indirizzo": {
      "paese": "venezia",
      "indirizzo": "via falsa 1"
    }
  },
  "intervallo_validita": {
    "gte" : "11-05-2022 00:00:00",
    "lte" : "13-08-2022 23:59:59"
  }
}'
curl -XPOST "http://localhost:9200/my_ecommerce/_create/13" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Semi per fiori",
  "descrizione_analizzata": "Semi per creare fiori di diversi colori in prati con erba",
  "macro_categoria": "giardinaggio",
  "sotto_categoria": "altro",
  "larghezza": 0,
  "consegna_gratuita": true,
  "prezzo": "5",
  "data_creazione": "20/05/2022",
  "produttore": {
    "ragione_sociale": "COD_1",
    "descrizione_azienda": "fornitore1",
    "indirizzo": {
      "paese": "venezia",
      "indirizzo": "via falsa 1"
    }
  },
  "intervallo_validita": {
    "gte" : "11-05-2022 00:00:00",
    "lte" : "13-08-2022 23:59:59"
  }
}'
curl -XPOST "http://localhost:9200/my_ecommerce/_create/14" -H 'Content-Type: application/json' -d'
{
  "nome_prodotto": "Tulipani",
  "descrizione_analizzata": "Semi per tulipani rossi",
  "macro_categoria": "giardinaggio",
  "sotto_categoria": "altro",
  "larghezza": 0,
  "consegna_gratuita": true,
  "prezzo": "5",
  "data_creazione": "22/05/2022",
  "produttore": {
    "ragione_sociale": "COD_1",
    "descrizione_azienda": "fornitore1",
    "indirizzo": {
      "paese": "venezia",
      "indirizzo": "via falsa 1"
    }
  },
  "intervallo_validita": {
    "gte" : "11-01-2022 00:00:00",
    "lte" : "13-08-2022 23:59:59"
  }
}'


