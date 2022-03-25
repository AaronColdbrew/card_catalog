-- Please note, variables are expressed as :[VARIABLE NAME]_input.
-- Please note, while IDs are referenced as input, they are displayed to the user in the form of a drop-down list. The user never accesses FK IDs directly.

-- VIEW ALL PEOPLE
-- ----------------------------------------------------------------------------------------------------------------------------

-- Populate world drop down, faction drop down for adding
SELECT worlds.world_id, worlds.name FROM worlds
SELECT factions.faction_id, factions.acronym FROM factions

-- Add a new person-of-interest with a faction 
INSERT INTO people(`first_name`, `last_name`, `homeworld`, `faction`, `living`) VALUES(:first_name_input, :last_name_input, :homeworld_input, :faction_input, :living_input)

-- View all people by name, world, faction and status
SELECT people.person_id, people.first_name, people.last_name, worlds.world_id, worlds.name AS homeworld, factions.faction_id, factions.name AS faction, people.living 
FROM people LEFT JOIN factions ON people.faction=factions.faction_id INNER JOIN worlds ON people.homeworld=worlds.world_id ORDER BY people.last_name

-- Delete a selected person
DELETE FROM people WHERE people.person_id=:person_id_input


-- PEOPLE UPDATE FORM
-- ----------------------------------------------------------------------------------------------------------------------------

-- Populate the input forms with the current data
SELECT people.person_id, people.first_name, people.last_name, worlds.world_id, worlds.name AS homeworld, factions.faction_id, factions.acronym AS faction, people.living 
FROM people LEFT JOIN factions ON people.faction=factions.faction_id INNER JOIN worlds ON people.homeworld=worlds.world_id WHERE people.person_id=:person_id_input ORDER BY people.last_name

-- Populate the factions drop down, worlds drop down
SELECT factions.faction_id, factions.acronym FROM factions
SELECT worlds.world_id, worlds.name FROM worlds

-- Update a person's data 
UPDATE people SET people.first_name =:first_name_input, people.last_name=:last_name_input, people.homeworld=:homeworld_input, people.faction=:faction_input, people.living=:status_input  
WHERE people.person_id=:person_id_input

-- Select ships an individual has boarded to allow for deleting
SELECT ships.ship_id, ships.name, ships.class, ships.type, ships.faction AS faction_id, factions.acronym AS faction 
FROM ships LEFT JOIN factions ON ships.faction=factions.faction_id INNER JOIN people_ships ON ships.ship_id=people_ships.ship 
INNER JOIN people ON people_ships.passenger=people.person_id WHERE people.person_id=:person_id_input

-- Delete a people_ships relationship
DELETE FROM people_ships 
WHERE people_ships.passenger=:person_id_input AND people_ships.ship=:ship_id_input

-- Select ships the individual has not boarded for populating the ship dropdown
SELECT ships.ship_id, ships.name AS ship_name 
FROM ships LEFT JOIN (SELECT ships.ship_id, ships.name, ships.class, ships.type, ships.faction FROM ships INNER JOIN people_ships ON ships.ship_id=people_ships.ship INNER JOIN people ON people_ships.passenger=people.person_id WHERE people.person_id=:person_id_input) as knownShips ON ships.ship_id=knownShips.ship_id WHERE knownShips.ship_id IS NULL ORDER BY ships.name DESC

-- Add people_ships relationship
INSERT INTO people_ships (`passenger`, `ship`) VALUES (:person_id_input, :ship_id_input)



-- VIEW SHIPS BOARDED BY INDIVIDUAL
-- ----------------------------------------------------------------------------------------------------------------------------

-- Populating the drop down menu with individuals to allow for searching ships
SELECT people.person_id, people.first_name, people.last_name, people.homeworld, people.faction, people.living 
FROM people ORDER BY people.last_name

-- Get the name of the target person from the dropdown
SELECT people.first_name, people.last_name FROM people WHERE people.person_id=:person_id_input ORDER BY people.last_name ASC

-- Display ships for the specific individual
SELECT ships.ship_id, ships.name AS ship_name, ships.class, ships.type, ships.faction, factions.acronym AS faction_name, people.person_id FROM ships INNER JOIN people_ships ON ships.ship_id = people_ships.ship INNER JOIN people ON people_ships.passenger = people.person_id LEFT JOIN factions ON ships.faction = factions.faction_id WHERE people.person_id=:person_id_input ORDER BY ship_name

-- Delete a people_ships relationship
DELETE FROM people_ships WHERE people_ships.passenger=:person_id_input AND people_ships.ship=:ship_id_input

-- Get a list of ships the individual has not boarded to populate a list of potential existing ships to add to their profile 
SELECT ships.ship_id, ships.name AS ship_name FROM ships LEFT JOIN(SELECT ships.ship_id, ships.name AS ship_name, ships.class, ships.type, ships.faction, factions.acronym AS faction_name, people.person_id FROM ships INNER JOIN people_ships ON ships.ship_id = people_ships.ship INNER JOIN people ON people_ships.passenger = people.person_id LEFT JOIN factions ON people.faction = factions.faction_id WHERE people.person_id=:person_id_input ORDER BY ship_name) as boardedShips ON ships.ship_id=boardedShips.ship_id WHERE boardedShips.ship_name IS NULL ORDER BY ship_name DESC

-- Add people_ships relationship
INSERT INTO people_ships (`passenger`, `ship`)VALUES (:person_id_input, :ship_id_input)



-- SKILLS AND QUALIFICATIONS BY INDIVIDUAL
-- Please note, as only one M:M relationship is required to be implemented, this page merely displays data.
-- -------------------------------------------------------------------------------------------------------------------------------

-- Display skills and qualifications for all individuals
SELECT people.person_id, people.first_name, people.last_name, skills.name 
FROM people INNER JOIN people_skills ON people.person_id = people_skills.individual 
INNER JOIN skills ON people_skills.skill = skills.skill_id ORDER BY people.last_name



-- VIEW ALL SHIPS
-- -- ----------------------------------------------------------------------------------------------------------------------------

-- View all ships by name, class, type and faction
SELECT ships.ship_id, ships.name, ships.type, ships.class, factions.name AS owning_faction FROM ships LEFT JOIN factions ON ships.faction=factions.faction_id 
ORDER BY ships.name

-- Populate the factions dropdown for adding
SELECT factions.faction_id, factions.acronym FROM factions

-- Add a new ship
INSERT INTO ships(`name`, `class`, `type`, `faction`) VALUES(:name_input,:class_input,:type_input,:faction_id_input)

-- Delete a specific ship
DELETE FROM ships WHERE ships.ship_id=:ship_id_input



-- SHIP UPDATE FORM
-- -- ----------------------------------------------------------------------------------------------------------------------------
-- Populate the input fields with the existing data
SELECT ships.ship_id, ships.name, ships.class, ships.type, factions.faction_id, factions.name AS faction_name 
FROM ships LEFT JOIN factions ON ships.faction=factions.faction_id WHERE ships.ship_id=:ship_id_input

-- Populate the factions dropdown for adding
SELECT factions.faction_id, factions.acronym FROM factions

-- Update a ships information
UPDATE ships SET ships.name = :name_input, ships.class=:class_input, ships.type=:type_input, ships.faction=:faction_input
WHERE ships.ship_id=:ship_id_input

-- Search for the ships known passengers
SELECT ships.ship_id, ships.name AS ship_name, people.person_id, people.first_name, people.last_name, worlds.designation, people.faction, factions.acronym AS faction_name, people.living AS status FROM ships INNER JOIN people_ships ON ships.ship_id = people_ships.ship INNER JOIN people ON people_ships.passenger = people.person_id INNER JOIN worlds ON people.homeworld=worlds.world_id LEFT JOIN factions ON people.faction = factions.faction_id WHERE ship_id=:ship_id_input ORDER BY people.last_name

-- Delete a people_ships relationship
DELETE FROM people_ships WHERE people_ships.passenger=:person_id:input AND people_ships.ship=:ship_id_input

-- Populate the list of potential passengers that can be added to the ship
SELECT people.person_id, people.first_name, people.last_name FROM people LEFT JOIN(SELECT people.person_id, ships.name AS ship_name FROM people INNER JOIN people_ships ON people.person_id=people_ships.passenger INNER JOIN ships ON people_ships.ship = ships.ship_id WHERE ships.ship_id=:ship_id_input) as alreadyAboard ON people.person_id=alreadyAboard.person_id WHERE alreadyAboard.ship_name IS NULL ORDER BY people.last_name DESC

-- Add people_ships relationship
INSERT INTO people_ships (`passenger`, `ship`)VALUES (:person_id_input, :ship_id_input)



-- VIEW PASSENGER MANIFEST
-- -- ----------------------------------------------------------------------------------------------------------------------------
-- Populate the dropdown bar with all possible ships for searching
SELECT ships.ship_id, ships.name, ships.type, ships.class FROM ships ORDER BY ships.name

-- Get the name of a specific ship by id
SELECT ships.name FROM ships WHERE ship_id=:ship_id_input

-- Display all the known passengers for a specific ship
SELECT ships.ship_id, ships.name AS ship_name, people.person_id, people.first_name, people.last_name, worlds.designation, people.faction, factions.name AS faction_name, 
people.living AS status FROM ships INNER JOIN people_ships ON ships.ship_id = people_ships.ship INNER JOIN people ON people_ships.passenger = people.person_id 
INNER JOIN worlds ON people.homeworld=worlds.world_id LEFT JOIN factions ON people.faction = factions.faction_id WHERE ship_id=:ship_id_input ORDER BY people.last_name

-- Populate the drop down for adding passengers to a ship
SELECT people.person_id, people.first_name, people.last_name FROM people LEFT JOIN(SELECT people.person_id, ships.name AS ship_name FROM people INNER JOIN people_ships ON people.person_id=people_ships.passenger INNER JOIN ships ON people_ships.ship = ships.ship_id WHERE ships.ship_id=:ship_id_input) as alreadyAboard ON people.person_id=alreadyAboard.person_id WHERE alreadyAboard.ship_name IS NULL ORDER BY people.last_name DESC

-- Add people_ships relationship
INSERT INTO people_ships (`passenger`, `ship`) VALUES (:person_id_input, :ship_id_input)

-- Delete a people_ships relationship
DELETE FROM people_ships WHERE people_ships.passenger=:person_id_input AND people_ships.ship=:ship_id_input



-- WORLDS
-- -- ----------------------------------------------------------------------------------------------------------------------------
-- Display the world name, location, population, governing body and resident designation
SELECT worlds.world_id, worlds.name, worlds.location, worlds.population, factions.faction_id, factions.name AS faction_name 
FROM worlds LEFT JOIN factions ON worlds.faction=factions.faction_id 

-- Populate the faction and resident designation drop down
SELECT factions.faction_id, factions.acronym FROM factions

-- Add a new world to the database
INSERT INTO worlds (name, location, population, faction, designation) VALUES (:world_name_input, :world_location_input, :population_input, :faction_from_dropdown, :designation_input);

-- Delete a record for a given world
DELETE FROM worlds WHERE world.world_id= :world_id_from_row



-- WORLDS UPDATE FORM
-- -- ----------------------------------------------------------------------------------------------------------------------------
-- Populate the input fields with the existing data
SELECT worlds.world_id, worlds.name, worlds.location, worlds.population, factions.faction_id, factions.name AS faction_name 
FROM worlds LEFT JOIN factions ON worlds.faction=factions.faction_id 
WHERE worlds.world_id= :world_id_from_row

-- Populate the factions dropdown for update
SELECT factions.faction_id, factions.acronym FROM factions

-- ??? Populate designations?

-- Update information on a given world
UPDATE worlds SET worlds.name= :world_name_input, worlds.location=:world_location_input, worlds.population=:population_input, 
		worlds.faction= :faction_from_dropdown, worlds.designation=:designation_input WHERE worlds.world_id=:world_id_from_row



-- FACTIONS
-- -- ----------------------------------------------------------------------------------------------------------------------------
-- Displays the factions page
SELECT factions.faction_id, factions.name, factions.acronym FROM factions ORDER BY factions.name

-- Add a new faction to the database
INSERT INTO factions (name, acronym) VALUES (:faction_name_input, :acronym_input)

-- Delete a faction from the database
DELETE FROM factions WHERE factions.faction_id = ?



-- FACTION UPDATE FORM
-- -- ----------------------------------------------------------------------------------------------------------------------------
-- Populate the input fields with the existing data
SELECT factions.faction_id, factions.name, factions.acronym FROM factions WHERE factions.faction_id= :faction_id_from_row

-- Update information on a given faction
UPDATE factions SET factions.name= :faction_name_input, factions.acronym=:acronym_input WHERE factions.faction_id = :faction_id_from_row



-- SKILLS
-- -- ----------------------------------------------------------------------------------------------------------------------------
-- Displays all available skills
SELECT skills.skill_id, skills.name FROM skills ORDER BY skills.name

-- Add a new skill to the database
INSERT INTO skills (name) VALUES (:skill_text_input)

-- Delete a skill from the database
DELETE FROM skills WHERE skills.skill_id = :skill_id_from_row



-- SKILLS UPDATE FORM
-- -- ----------------------------------------------------------------------------------------------------------------------------
-- Populate the input fields with the existing data
SELECT skills.skill_id, skills.name FROM skills WHERE skills.skill_id= :skill_id_from_row

-- Update information on a given faction
UPDATE skills SET skills.name= :skill_text_input WHERE skills.skill_id = :skill_id_from_row