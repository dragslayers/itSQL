
CREATE DATABASE IF NOT EXISTS `db_aviation`
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `db_aviation`;

--  Exercice modifier
CREATE TABLE `compagnies` (
    `comp` CHAR(4),
    `street` VARCHAR(20),
    `city` VARCHAR(20) NULL,
    `name` VARCHAR(20) NOT NULL,
    CONSTRAINT pk_compagny PRIMARY KEY (`comp`)
);

-- alter table

ALTER TABLE `compagnies` 
ADD COLUMN `status` ENUM('published', 'unpublished', 'draft')
DEFAULT 'draft';

ALTER TABLE `compagnies`
DROP COLUMN `numStreet`;

ALTER TABLE `compagnies` 
ADD COLUMN `numStreet` TINYINT UNSIGNED AFTER `name`;

--  Exercice créer la table pilots

CREATE TABLE `pilots` (
    `certificate` VARCHAR(6),
    `numFlying` DECIMAL(7,1),
    `compagny` CHAR(4),
    `name` VARCHAR(20) NOT NULL,
    CONSTRAINT pk_pilots PRIMARY KEY (`certificate`)
) ENGINE=InnoDB ;

ALTER TABLE pilots ADD CONSTRAINT fk_pilots_compagny FOREIGN KEY (compagny) REFERENCES compagnies(`comp`);

ALTER TABLE pilots
ADD CONSTRAINT un_name UNIQUE (name);

-- supprimer la contrainte nommée de la clé étrangère et la clé étrangère elle-même

ALTER TABLE pilots DROP FOREIGN KEY fk_pilots_compagny;
ALTER TABLE pilots DROP KEY fk_pilots_compagny;

-- création de la clé étrangère sans la nommée => MySQL crée un nom de contrainte par défaut
-- ALTER TABLE pilots ADD FOREIGN KEY (compagny) REFERENCES compagnies(`comp`);
