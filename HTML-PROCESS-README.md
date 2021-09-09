= HTML-muotoisten Moodle-palautusten käsittely

Kaksi vaihetta. Ensimmäinen lajittelee tuotokset alihakemistoihin.

Ensimmäinen komento ajetaan hakemistossa, jonka alla puretut tuotokset orig-hakemisto. 
Eli hakemistossa orig purettu HTML-muotoiset palautukset Moodlesta.
````
$ html_split_process.pl orig dest
````

Syntyy dest-tieto-a, dest-tieto-b jne.
Mennään johonkin näistä ja ajetaan:
````
$ links_process.pl NAMED.html buildie-nm.html
````
Saadaan yksi tiedosto, jossa klikattavat URL:it.

