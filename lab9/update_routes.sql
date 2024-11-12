UPDATE climbs
    SET grade_id = (SELECT grade_id FROM climb_grades WHERE grade_str = '5.10b')
  WHERE grade_id = (SELECT grade_id FROM climb_grades WHERE grade_str = '5.10a');

SELECT climb_name, grade_str FROM climbs
    INNER JOIN climb_grades
    USING (grade_id);