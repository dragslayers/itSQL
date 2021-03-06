/*



*/


-- La requête

ALTER TABLE `compagnies` ADD COLUMN `numStreet` INT;

INSERT INTO `compagnies`
(`comp`, `street`, `city`, `name`, `numStreet`, `status`)
VALUES
('AUS', 'sidney', 'Australie', 'AUSTRA Air', 19, 'draft'),
('CHI', 'chi', 'Chine', 'CHINA Air', NULL, 'draft'),
('FRE1', 'beaubourg', 'France', 'Air France', 17, 'draft'),
('FRE2', 'paris', 'France', 'Air Electric', 22, 'draft'),
('SIN', 'pasir', 'Singapour', 'SIN A', 15, 'draft');


-- insert pilots

INSERT INTO `pilots`
(`certificate`,`numFlying`,`compagny` ,`name`)
VALUES
    ('ct-1', 90, 'AUS', 'Alan' ),
    ('ct-12', 190, 'AUS', 'Albert' ),
    ('ct-7', 80, 'CHI', 'Pierre' ),
    ('ct-11', 200, 'AUS', 'Sophie' ),
    ('ct-6', 20, 'FRE1', 'Jhon' ),
    ('ct-10', 90, 'FRE1', 'Tom' ),
    ('ct-100', 200, 'SIN', 'Yi' ),
    ('ct-16', 190, 'SIN', 'Yan' ),
    ('ct-56', 300, 'AUS', 'Benoit' )
    ;

-- Avant d'exécutez

INSERT INTO `pilots`
(`certificate`,`numFlying`,`compagny` ,`name`)
VALUES
 ('ct-59', 300, 'IRL', 'Philippe' );
