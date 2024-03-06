SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone="+00:00";

CREATE TABLE public.region (
    region_id int(11) NOT NULL,
    region_ref varchar(9) NOT NULL,
    region_name varchar(30) NOT NULL
);

ALTER TABLE public.region
    ADD CONSTRAINT pk_region PRIMARY KEY (region_id);

INSERT INTO public.region (region_id, region_ref, region_name)
VALUES
    (1, 'region91', 'Guadeloupe'),
    (2, 'region92', 'Martinique'),
    (3, 'region93', 'Guyane'),
    (4, 'region94', 'La Réunion'),
    (5, 'region95', 'Mayotte'),
    (6, 'region11', 'Île-de-France'),
    (7, 'region24', 'Centre-Val de Loire'),
    (8, 'region2', 'Bourgogne-Franche-Comté'),
    (9, 'region7', 'Normandie'),
    (10, 'region9', 'Hauts-de-France'),
    (11, 'region1', 'Grand Est'),
    (12, 'region8', 'Pays de la Loire'),
    (13, 'region6', 'Bretagne'),
    (14, 'region10', 'Nouvelle-Aquitaine'),
    (15, 'region5', 'Occitanie'),
    (16, 'region3', 'Auvergne-Rhône-Alpes'),
    (17, 'region4', 'Provence-Alpes-Côte d\'Azur'),
    (18, 'region96', 'Corse'),
    (19, 'regioncom', 'Collectivités d\'Outre-Mer');
