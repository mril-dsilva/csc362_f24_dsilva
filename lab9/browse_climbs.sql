USE red_river_climbs;
DROP FUNCTION IF EXISTS get_first_ascent;
CREATE FUNCTION get_first_ascent(climb_id INT)
RETURNS VARCHAR(2048)
RETURN (
    SELECT GROUP_CONCAT(CONCAT(climber_first_name, ' ', climber_last_name))
    FROM climber_first_ascents 
    INNER JOIN climbers USING (climber_id)
    WHERE climber_first_ascents.climb_id = climb_id
);

DROP FUNCTION IF EXISTS get_equippers;
CREATE FUNCTION get_equippers(climb_id INT)
RETURNS VARCHAR(64)
RETURN (
    SELECT GROUP_CONCAT(CONCAT(climber_first_name, ' ', climber_last_name))
    FROM climber_climbs_established 
    JOIN climbers USING (climber_id)
    WHERE climber_climbs_established.climb_id = climb_id
);

SELECT  climb_name AS Name, 
        grade_str AS Grade, 
        climb_len_ft AS "Length (ft)", 
        crag_name AS Crag,

        get_first_ascent(climb_id) AS "First ascent by",
        get_equippers(climb_id) AS "Equipped by"

    FROM climbs
    INNER JOIN climb_grades USING (grade_id)
    INNER JOIN crags USING (crag_id)

    /*
    WHERE (crag_name = ?)
    AND (grade_str = ?);
    */