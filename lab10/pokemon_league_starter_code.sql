DROP DATABASE IF EXISTS pokemon_league;
CREATE DATABASE pokemon_league;
USE pokemon_league;

CREATE TABLE trainers (
    trainer_id          INT AUTO_INCREMENT,
    trainer_name        VARCHAR(32),
    trainer_hometown    VARCHAR(32),
    PRIMARY KEY (trainer_id)
);

CREATE TABLE pokemon (
    pokemon_id          INT AUTO_INCREMENT,
    pokemon_species     VARCHAR(32),
    pokemon_level       INT,
    trainer_id          INT,
    pokemon_is_in_party BOOLEAN,
    PRIMARY KEY (pokemon_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers (trainer_id),
    CONSTRAINT minimum_pokemon_level CHECK (pokemon_level >= 1),
    CONSTRAINT maximum_pokemon_level CHECK (pokemon_level <= 100)
);

INSERT INTO trainers (trainer_name, trainer_hometown)
 VALUES ("Ash",   "Pallet Town"),
        ("Misty", "Cerulean City"),
        ("Brock", "Pewter City");

INSERT INTO pokemon (pokemon_species, pokemon_level, trainer_id, pokemon_is_in_party)
 VALUES ("Pikachu", "58",  1, TRUE),
        ("Staryu", "44",   2, TRUE),
        ("Onyx", "52",     3, TRUE),
        ("Magicarp", "12", 1, FALSE);

-- Get pokemon count for a trainer
DROP FUNCTION IF EXISTS pokemon_party_count;
CREATE FUNCTION pokemon_party_count(trainer_id INT)
RETURNS INT
RETURN (
    SELECT COUNT(*)
    FROM pokemon
    WHERE pokemon.trainer_id = trainer_id
    AND pokemon_is_in_party = TRUE
);

-- Min/Max Pokemon Trigger
DELIMITER //

CREATE TRIGGER pokemon_max_party_size
BEFORE INSERT ON pokemon
FOR EACH ROW
BEGIN
    IF (pokemon_party_count(NEW.trainer_id) >= 6 AND NEW.pokemon_is_in_party = TRUE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A trainer cannot have more than 6 Pokemon in their party!';
    END IF;
END//

CREATE TRIGGER pokemon_min_party_size
BEFORE UPDATE ON pokemon
FOR EACH ROW
BEGIN
    IF (pokemon_party_count(NEW.trainer_id) = 1 AND NEW.pokemon_is_in_party = FALSE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A trainer must have at least 1 Pokemon in their party!';
    END IF;
END//
DELIMITER ;

-- Pokemons trainer id retreival
DROP FUNCTION IF EXISTS pokemons_trainer;
CREATE FUNCTION pokemons_trainer(pokemon_id INT)
RETURNS INT
RETURN (
    SELECT trainer_id
    FROM pokemon
    WHERE pokemon.pokemon_id = pokemon_id
);

-- is pokemon in party?

DROP FUNCTION IF EXISTS is_in_party;
CREATE FUNCTION is_in_party(pokemon_id INT)
RETURNS BOOLEAN
RETURN (
    SELECT pokemon_is_in_party
    FROM pokemon
    WHERE pokemon.pokemon_id = pokemon_id
);

-- Pokemon Trading
DELIMITER //
CREATE PROCEDURE trade_pokemon(IN pokemon1_id INT, IN pokemon2_id INT)
BEGIN
    DECLARE trainer1_id INT;
    DECLARE trainer2_id INT;

    DECLARE EXIT HANDLER FOR 45000
    BEGIN
        SELECT 'Procedure failed because of reasons!' as Error;
        ROLLBACK;
    END;

    START TRANSACTION;

    SET trainer1_id = pokemons_trainer(pokemon1_id);
    SET trainer2_id = pokemons_trainer(pokemon2_id);

    IF (trainer1_id IS NULL OR trainer2_id IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error message! Incorrect pokemon input/s';
    END IF;

    IF (is_in_party(pokemon1_id) IS FALSE OR is_in_party(pokemon2_id) IS FALSE) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error message! Pokemon isnt in party to trade!';
    END IF;

    UPDATE pokemon 
    SET trainer_id = trainer2_id
    WHERE pokemon_id = pokemon1_id;

    UPDATE pokemon 
    SET trainer_id = trainer1_id
    WHERE pokemon_id = pokemon2_id;

    COMMIT;
END//
DELIMITER ;

-- checkng maximum pokemon trigger
INSERT INTO pokemon (pokemon_species, pokemon_level, trainer_id, pokemon_is_in_party) 
    VALUES 
    ("squirtle", 15, 2, TRUE),
    ("squirtle", 15, 2, TRUE),
    ("squirtle", 15, 2, TRUE),
    ("squirtle", 15, 2, TRUE),
    ("squirtle", 15, 2, TRUE);

INSERT INTO pokemon (pokemon_species, pokemon_level, trainer_id, pokemon_is_in_party) 
    VALUES 
    ("charmander", 15, 2, TRUE);

-- checcking minimum pokemon trigger
UPDATE pokemon SET pokemon_is_in_party = FALSE WHERE trainer_id = 1 AND pokemon_id = 1;

-- checking unsuccessful pokemon trade trigger
CALL trade_pokemon(1,4); -- magikarp is not in party to trade

-- succesful trade example
CALL trade_pokemon(1,3);