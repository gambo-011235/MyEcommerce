In questo progetto presento un semplice esempio dell'utilizzo delle API di Elasticsearch in Java.

Prerequisiti:
<ul>
<li>Elasticsearch 7.16</li>
<li>Java >= 8</li>
<li>Assumo che Elasticsearch giri su localhost:9200 (in caso contrario, cambiare il puntamento nei file MyEcommerceConfiguration.java e init_data.sh)</li>
</ul>


Avviare init_data.sh per importare i dati necessari nell'indice:
<br>
sh init_data.sh

Avviare l'applicativo:
<br>
./gradlew bootRun