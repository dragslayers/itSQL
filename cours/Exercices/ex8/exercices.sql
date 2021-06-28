
/*
## Exercice 

Créez une procédure permettant de calculer la moyenne des salaires des pilotes d'une compagnie donnée.
*/

USE db_aviation;
DROP PROCEDURE IF EXISTS avg_pilot_comp;

DELIMITER |
CREATE PROCEDURE avg_pilot_comp (IN comp CHAR(4), OUT savg INT) 
    BEGIN
        SELECT AVG(salary) INTO savg 
        FROM pilots
        WHERE compagny = comp;
    END |
DELIMITER ; 

set @sav = 0;
CALL avg_pilot_comp('AUS', @sav);


-- Exercices

-- 1. Créez une procédure qui affiche la liste des pilotes

DROP PROCEDURE IF EXISTS PROCEDURE list_pilots;

DELIMITER |
CREATE PROCEDURE list_pilots()
    BEGIN
        SELECT name FROM pilots;
    END |
DELIMITER ; 

-- 2. Créez une procédure qui affiche les compagnies qui employent plus de 2 pilotes

DROP PROCEDURE IF EXISTS PROCEDURE compagny_more_than_two_pilots;

DELIMITER |
CREATE PROCEDURE compagny_more_than_two_pilots()
    BEGIN
        SELECT c.name, COUNT(p.certificate) as nb
        FROM pilots as p
        JOIN compagnies as c
        ON p.compagny = c.comp
        GROUP BY p.compagny
        HAVING nb > 2
    END |
DELIMITER ; 

-- 3. Créez une procédure qui affiche les compagnies qui n'ont pas de pilote.

DROP PROCEDURE IF EXISTS PROCEDURE compagny_more_than_two_pilots;

DELIMITER |
CREATE PROCEDURE compagny_more_than_two_pilots()
    BEGIN
        SELECT c.name
        FROM pilots as p
        RIGHT JOIN compagnies as c
        ON p.compagny = c.comp
        WHERE p.name IS NULL;
    END |
DELIMITER ; 

-- et de manière équivalente 
/*
SELECT comp, name FROM compagnies WHERE NOT EXISTS (SELECT compagny FROM pilots WHERE comp = compagny);
*/


-- 4. Créez une procédure qui affiche la somme des heures de vols pour un pilote.

DROP PROCEDURE IF EXISTS sum_hour_by_pilot;

DELIMITER |
CREATE PROCEDURE sum_hour_by_pilot(
    IN cert VARCHAR(6), 
    OUT nb SMALLINT UNSIGNED
    )
    BEGIN
        SELECT ROUND( SUM(numFlying), 1 ) INTO nb
        FROM pilots 
        WHERE certificate = cert;
    END |
DELIMITER ; 

set @sum = 0;
CALL sum_hour_by_pilot('ct-09', @sum);
SELECT @sum;


-- 5. Créez une procédure qui affiche les pilotes d'une compagnie donnée.

DROP PROCEDURE IF EXISTS show_pilots_by_compagny;

DELIMITER |
CREATE PROCEDURE show_pilots_by_compagny(
    IN comp CHAR(4)
    )
    BEGIN
        SELECT p.name
        FROM pilots as p
        JOIN compagnies as c
        ON p.compagny = c.comp
        WHERE c.comp = comp;
    END |
DELIMITER ; 

CALL show_pilots_by_compagny('AUS');

-- 6. Créez une procédure qui affiche les noms des pilotes avec leurs bonus ordonnées par ordre décroissant de bonus.

DROP PROCEDURE IF EXISTS pilot_name_by_bonus;

DELIMITER |
CREATE PROCEDURE pilot_name_by_bonus()
    BEGIN
        SELECT name, bonus
        FROM pilots
        WHERE bonus IS NOT NULL
        ORDER BY bonus DESC ;
    END |
DELIMITER ; 

call pilot_name_by_bonus();

-- 7.Créez une procédure permettant de calculer la moyenne des salaires des pilotes d'une compagnie donnée.

DROP PROCEDURE IF EXISTS avg_compagny;

DELIMITER |
CREATE PROCEDURE avg_compagny(IN code_compagny CHAR(4))
    BEGIN
        SELECT AVG(p.salary) as avg_salary, c.name as compagny_name
        FROM pilots as p
        JOIN compagnies as c
        ON p.compagny = c.comp
        WHERE c.comp = code_compagny;
    END |
DELIMITER ; 

call avg_compagny('FRE1');

-- 8. Créez une procédure qui retourne 1 ou 0 si la compagnie a respectivement des pilotes ou aucun pilote.

DROP PROCEDURE IF EXISTS is_pilots_by_compagny;

DELIMITER |
CREATE PROCEDURE is_pilots_by_compagny (
    IN code_compagny CHAR(4), 
    OUT res TINYINT(1) ) 
    BEGIN
        DECLARE nb_pilots INT DEFAULT 0;
        SELECT COUNT(p.certificate) INTO nb_pilots
        FROM pilots as p
        JOIN compagnies as c
        ON c.comp = p.compagny
        WHERE c.comp = code_compagny ;
        
        IF nb_pilots > 0 THEN
            SELECT 1 INTO res;
        ELSE
            SELECT 0 INTO res;
        END IF;
    END |
DELIMITER ; 

set @c = 'AUS';
set @nb = 0;

CALL is_pilots_by_compagny(@c, @nb);
SELECT @nb;

-- 9. Créez une procédure qui augmente tous les salaires de 10% si ce dernier est pair pour sa partie entière.

DROP PROCEDURE IF EXISTS increase_salary;

DELIMITER |
CREATE PROCEDURE increase_salary(IN per DECIMAL(5,1), IN parity TINYINT(1))
    BEGIN
       UPDATE pilots
       SET salary = salary * (per + 1)
       WHERE MOD(TRUNCATE(salary, 0), 2) = parity;
       SELECT salary, name
       FROM pilots
       WHERE  MOD(TRUNCATE(salary, 0), 2) = parity;
    END |
DELIMITER ; 

call increase_salary(0.1, 0);


-- 10. Créez une procédure qui augmente le salaire de 10%, sans le modifier la table pilots, si ce dernier est pair, ordonné les résultats par ordre décroissant de salaire.
-- Ajoutez également une colonne d'indices row. Elle commencera par 1 et sera incrémenté de +1 pour afficher les résultats.


DROP PROCEDURE IF EXISTS more_even;

DELIMITER |
CREATE PROCEDURE more_even (IN per DECIMAL(5,1) , IN parity TINYINT(1)) 
    BEGIN
        SET @row = 0;
        SELECT @row := @row + 1 as row, salary *(1 + per) 
        FROM pilots
        WHERE MOD(TRUNCATE(salary, 0), 2) = parity
        ORDER BY salary DESC;
    END |

DELIMITER ;

-- Algo Savoir si on a un nombre pair de lignes dans la table pilots.

DROP PROCEDURE IF EXISTS is_even_pilots;

DELIMITER |
CREATE PROCEDURE is_even_pilots (OUT even CHAR(4)) 
    BEGIN
        DECLARE s INT DEFAULT 0;
       
        SELECT COUNT(*) INTO s
        FROM pilots;

        IF MOD(s, 2) = 0 THEN
            SET even = 'yes';
        ELSE
            SET even = 'no';
        END IF;
    END |
DELIMITER ;
        

-- mediane

DROP PROCEDURE IF EXISTS mediane_salary;

DELIMITER |
CREATE PROCEDURE mediane_salary(OUT mediane INT) 
    BEGIN
        DECLARE nb INT DEFAULT 0;
        DECLARE middle1 INT DEFAULT 0;
        DECLARE middle2 INT DEFAULT 0;
        SET @row = 0;

        SELECT COUNT(*) INTO nb FROM pilots WHERE salary IS NOT NULL;

        IF MOD(nb, 2) = 0 THEN
            SET middle1 = nb / 2 ;
            SET middle2 = middle1 + 1 ;
        ELSE 
            SET middle1 = (nb + 1) / 2  ;
            SET middle2 = 0 ;
        END IF;

        SELECT SUM(p.salary) INTO mediane FROM (
                SELECT @row := @row + 1 as `row`, salary
                FROM pilots
                WHERE salary IS NOT NULL
                ORDER BY salary ASC
            ) as p
        WHERE p.row IN ( middle1, middle2 );

        IF middle2 != 0 THEN
            SET mediane = ROUND( mediane / 2 );
        END IF;
    END |

DELIMITER ;
    