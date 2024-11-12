SELECT climber_first_name, COUNT(climb_id) AS total_routes_established 
    FROM climbers
        INNER JOIN climber_climbs_established 
        USING (climber_id)
    GROUP BY (climber_id)
    ORDER BY (total_routes_established) DESC
    LIMIT 3;

