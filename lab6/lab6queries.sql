-- 1
SELECT owner_name
FROM owners;

-- 2
SELECT climb_name, crag_name
FROM climbs
	INNER JOIN crags
	USING (crag_id);

-- 3
SELECT climb_name, grade_str
	FROM climbs
		INNER JOIN crags
		USING (crag_id)
		INNER JOIN climb_grades
		USING (grade_id)
		INNER JOIN sport_climbs 
		USING (climb_id)
	WHERE crags.crag_name = 'Slab City';

-- 4
SELECT climb_name, grade_str, trad_climb_descent
	FROM climbs
		INNER JOIN climb_grades
		USING (grade_id)
		INNER JOIN trad_climbs
		USING (climb_id);

-- 5
SELECT climb_name, grade_str, climb_len_ft, crag_name
	FROM climbs
		INNER JOIN climb_grades 
		USING (grade_id)
		INNER JOIN crags
		USING (crag_id)
	WHERE climb_grades.grade_str = '5.9';

-- 6
SELECT DISTINCT grade_str
	FROM climbs
		INNER JOIN crags
		USING (crag_id)
		INNER JOIN regions
		USING (region_id)
		INNER JOIN owners
		USING (owner_id)
		INNER JOIN climb_grades
		USING (grade_id)
	WHERE owners.owner_name = 'John and Elizabeth Muir';

-- 7
SELECT climb_name, sport_climb_bolts, 
        GROUP_CONCAT(climber_forum_handle) AS "FA Party"
    FROM climbs
        INNER JOIN sport_climbs
        USING (climb_id) 
        INNER JOIN climber_first_ascents
        USING (climb_id)
        INNER JOIN climbers
        USING (climber_id)
    GROUP BY climbs.climb_name;


-- 8
SELECT climber_first_name, climber_last_name
    FROM climbs
        INNER JOIN crags
        USING (crag_id)
        INNER JOIN regions
        USING (region_id)
        INNER JOIN climber_climbs_established
        USING (climb_id)
        INNER JOIN climbers
        USING (climber_id)
    WHERE region_name = "Miller Fork"
    GROUP BY climbers.climber_last_name; -- WB: Fixed.

-- 9
SELECT grade_str,
    COUNT(climb_id) AS "Num Routes"
    FROM climb_grades
        LEFT OUTER JOIN climbs
        USING (grade_id)
    GROUP BY climb_grades.grade_str;

-- 10
SELECT grade_str,
    GROUP_CONCAT(climb_name) AS "Route Names"
    FROM climb_grades
        INNER JOIN climbs
        USING (grade_id)
    GROUP BY climb_grades.grade_str;

-- 11 -- This is not quite right, according to the test cases.
SELECT climber_first_name, climber_last_name, 
       CONCAT(MAX(grade_str)) AS "maximum grades"
    FROM climbers
        INNER JOIN climber_climbs_established
        USING (climber_id)
        INNER JOIN climbs
        USING (climb_id)
        INNER JOIN climb_grades
        USING (grade_id)
    GROUP BY climber_first_name, climber_last_name;
