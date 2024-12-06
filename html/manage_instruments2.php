<?php
function result_to_html_table($result) {
    $qryres = $result->fetch_all();
    $n_rows = $result->num_rows;
    $n_cols = $result->field_count;
    $fields = $result->fetch_fields();
    ?>
    <form method="POST">
        <table>
        <!-- Begin Header - - - - - - - - - - - - - - - - - - - - - -->  
        <thead>
        <tr>
        <td><b>Delete?</b></td>
        <?php for ($i=0; $i<$n_cols; $i++){ ?>
            <td><b><?php echo $fields[$i]->name; ?></b></td>
        <?php } ?>
        </tr>
        </thead>
        
        <!-- Begin Body - - - - - - - - - - - - - - - - - - - - - -->
        <tbody>
        <?php for ($i=0; $i<$n_rows; $i++){ ?>
            <?php $id = $qryres[$i][0]; 
            $student_name = $qryres[$i][2];?>
            <tr>
                <td><input type="checkbox" name="checkbox<?php echo $id;?>" value="<?php echo $id;?>" 
                    <?php 
                    if ($student_name !== null) {
                        echo 'disabled="disabled"';
                    }
                    ?>
                    /></td>  
            <?php for($j=0; $j<$n_cols; $j++){ ?>
                <td><?php echo $qryres[$i][$j]; ?></td>
            <?php } ?>
            </tr>
        <?php } ?>
        </tbody></table>

    <!-- Begin Buttons - - - - - - - - - - - - - - - - - - - - - -->
        <p><input type="submit" name="delbtn" value="Delete Selected Records" /></p>
        <p><input type="submit" name="add_records" value="Add extra records" /></p>

    </form>
<?php } ?>

<?php
// error handling
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// loading usrname & passw from mysql.ini file
$db_config = parse_ini_file('sql/mysql.ini');
$db_host = $db_config['mysqli.default_host'];
$db_username = $db_config['mysqli.default_user'];
$db_password = $db_config['mysqli.default_pw'];
$db_name = 'instrument_rentals';

// Define path to sql files. REMINDER to run SOURCE commands.
$sql_location = 'sql/'; 

// ----- LIGHT AND DARK MODE --------
$mode = "user_mode";
$light = "light";
$dark = "dark";
$button_pressed = "yes";
$button_label = "Toggle Dark/Light Modes";

// ----- Cookie for Light & Dark Mode
if (!isset($_COOKIE[$mode])) {
    setcookie($mode, $light, 0, "/", "", false, true); 
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit();
}

// ----- Cookie to remember if button was toggled.
if (isset($_POST[$button_pressed])) {
    $new_mode = $_COOKIE[$mode] == $light ? $dark : $light;
    setcookie($mode, $new_mode, 0, "/", "", false, true);
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit();
}

// ----- START SESSION ---------------
session_start();

// ----- Initializing session variables
if (!array_key_exists('num_deleted', $_SESSION)) { 
    $_SESSION['num_deleted'] = 0;
}
if (!array_key_exists('num_added', $_SESSION)) { 
    $_SESSION['num_added'] = 0;
}

// ----- Session Logout
if (isset($_POST['logout'])) {
    session_unset();
    session_destroy();
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit(); 
}

// ----- Session Username
if (isset($_POST['username'])) {
    $_SESSION['username'] = $_POST['username'];
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit(); 
}

// ----- HANDLING ADDITION OF RECORDS --------------------------------------
if (array_key_exists('add_records', $_POST)) {
    $conn = new mysqli($db_host, $db_username, $db_password, $db_name);
    $add_sql = file_get_contents($sql_location .'add_instruments.sql');
    
    if ($conn->query($add_sql) === FALSE) {
        echo "Error: " . $conn->error;
        exit();
    } else {
        $_SESSION['num_added']++;
        $conn->close();
        header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
        exit();
    }
}

// ----- HANDLING DELETION OF RECORDS --------------------------------------
if (array_key_exists('delbtn', $_POST)) {
    $conn = new mysqli($db_host, $db_username, $db_password, $db_name);
    $delt_stmt = $conn->prepare(file_get_contents($sql_location . 'delete_instrument.sql'));

    foreach ($_POST as $key => $value) {
        if (strpos($key, 'checkbox') === 0) {
            $id = (int)$value;
            $delt_stmt->bind_param('i', $id);
            $delt_stmt->execute();
            $_SESSION['num_deleted']++;
        }
    }

    $delt_stmt->close();
    $conn->close();
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit();
}
?>

<!DOCTYPE html>
<html>
    <head>
        <title>Delete From Table</title>
        <?php
        if ($_COOKIE[$mode] == $dark){
            echo '<link rel="stylesheet" href="darkmode.css">';
        } else {
            echo '<link rel="stylesheet" href="basic.css">';
        }
        ?>
    </head>
    <body>
        <h1>
            Manage Instruments in Database
        </h1>

        <form method=POST>
            <input type="submit" name="<?= $button_pressed ?>" value="Toggle Light/Dark Mode"/>
        </form>
        <?php
        if (isset($_SESSION['username'])) {
        ?>
            <p>Welcome <?php echo $_SESSION['username']; ?>!</p>
            <form action="manage_instruments2.php" method=POST>
                <input type=submit name='logout' value="Logout"/>
            </form>
        <?php
        } else {
        ?>
            <p>Remember my session:</p>
            <form method=POST>
                <input type=text name='username' placeholder='Enter name...'/>
                <input type=submit value='Remember Me'/>
            </form>
        <?php
        }
        ?>

        <p>
            You have added records <?php echo isset($_SESSION['num_added']) ? $_SESSION['num_added'] : "no"; ?> time(s) this session.<br>
            You have deleted <?php echo isset($_SESSION['num_deleted']) ? $_SESSION['num_deleted'] : "no"; ?> record(s) this session.<br>
            <i>Logging out will clear these counters.</i>
        </p>
        <?php
        // ----- LOAD TABLE AND DISPLAY -------------------------------------------
        $conn = new mysqli($db_host, $db_username, $db_password, $db_name);
        $sel_tbl = file_get_contents($sql_location . 'select_instruments.sql');
        $result = $conn->query($sel_tbl);
        result_to_html_table($result);
        ?>
    </body>
</html>
