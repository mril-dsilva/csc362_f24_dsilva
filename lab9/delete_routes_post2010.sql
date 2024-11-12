
DELETE from climber_climbs_established
    WHERE climb_id IN (SELECT climb_id FROM climbs WHERE climb_established_date >= '2010-01-01');