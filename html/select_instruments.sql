SELECT instrument_id, instrument_type, student_name 
    FROM instruments 
        LEFT OUTER JOIN student_instruments 
        USING (instrument_id) 
        LEFT OUTER JOIN students 
        USING (student_id);