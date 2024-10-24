<html>
    <head>
    <title>Database Details</title>
    </head>
    <body>
        
        <h3>Showing All Tables in: <br><?php echo htmlspecialchars($_POST['name']); ?> Database </h3>  
        
        <?php
        $dbhost = 'localhost';
        $dbuser = 'mril'; // Hard-coding credentials directly in code is not ideal: (1) we might have to 
        $dbpass = 'mril';       // change them in multiple places, and (2) this creates security concerns. 

        $conn = new mysqli($dbhost, $dbuser, $dbpass);
        $conn->query("USE " . htmlspecialchars($_POST['name']));
        $dblist = "SHOW TABLES";
        $result = $conn->query($dblist);

        while ($dbname = $result->fetch_array()) {
            echo "<li>". $dbname['Tables_in_' . htmlspecialchars($_POST['name'])] . "<br>";
        }
            
        $conn->close();

        ?>
    </body>
</html>