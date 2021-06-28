---- partie des exercices supplémentaires

/*
Quelles sont les coordonnées des compagnies qui employe(nt) des 
pilotes faisant moins de 90 heures de vols ?
*/

SELECT numStreet, street, city 
FROM compagnies WHERE comp IN ( 
    SELECT compagny FROM pilots WHERE numFlying < 90 
);


/*
Quelles sont les noms des compagnies qui employe(nt) des 
pilotes  qui sont nés après 1978 ?

*/

SELECT name
FROM compagnies WHERE comp IN ( 
   SELECT compagny FROM pilots WHERE birth_date > '1979'
);

/*
Faites la somme des heures de vols des pilotes de la compagnie Air France.
*/

SELECT sum(`numFlying`) 
FROM `pilots`
WHERE `certificate` IN
(
    SELECT `certificate` 
    FROM `pilots` 
    WHERE `compagny` IN (
        SELECT `comp` 
        FROM `compagnies`
        WHERE `name`='Air France'
    )
);


/*
Trouvez toute(s) les/la compagnie(s) n'ayant pas de pilotes.
*/

INSERT INTO `compagnies` 
SET `comp` = 'ITA', 
    `street` = 'mapoli', 
    `city` = 'Rome', 
    `name` = 'Italia Air', 
    `numStreet` =  20;

SELECT numStreet, street, city 
FROM compagnies
WHERE comp NOT IN (
    SELECT compagny
    FROM pilots
);


/*
Sélectionnez toutes les pilotes  dont 
le nombre d'heures de travail est inférieur 
à tous les nombres d'heures de travail de la compagnie CHI
*/

SELECT name, compagny
    FROM pilots
    WHERE num_jobs < ALL (
        SELECT num_jobs
        FROM pilots
        WHERE compagny='CHI'
    );

/*
Sélectionnez toutes les pilotes et la longueur de leurs noms dont 
la longueur de leurs noms est inférieur
à toutes les longueurs des noms de la compagny FRE1
*/

SELECT length(name), compagny
    FROM pilots
    WHERE length(name) < ALL (
       select length(name) from pilots where compagny = 'FRE1'
    );


/*
Il existe une clause ANY, 
elle est permet de vérifier que pour au moins une valeur une condition est vérifiée dans une sous-requête
*/

SELECT length(name), compagny
    FROM pilots
    WHERE length(name) < ALL (
       select length(name) from pilots where compagny = 'FRE1'
    );

/*
    Sélectionnez toutes les compagnies dont 
    le nombre d'heures de vol des pilots est inférieur 
    à tous les nombres d'heures de vol des A380.
*/

-- avant il faut ajouter le colonne plane et les valeurs suivantes

/*
ALTER TABLE pilots
ADD COLUMN plane
ENUM('A380', 'A320', 'A340') AFTER name;

UPDATE pilots
SET plane = 'A380'
WHERE name in ('Alan', 'Sophie', 'Albert', 'Benoit');

UPDATE pilots
SET plane = 'A320'
WHERE name in ('Tom', 'Jhon', 'Pierre');

UPDATE pilots
SET plane = 'A340'
WHERE name in ('Yan', 'Yi');
*/

SELECT numStreet, street, city 
FROM compagnies
WHERE comp IN(
    SELECT compagny
    FROM pilots
    WHERE numFlying < ALL (
        SELECT numFlying
        FROM pilots
        WHERE plane='A380'
    )
);
