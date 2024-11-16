<?php
    session_start();

    if (!array_key_exists('num_deleted', $_SESSION)){ 
        $_SESSION['num_deleted'] = 0;
    }

    if (isset($_POST['logout'])){
    session_unset();
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit(); 
    }

    if (isset($_POST['username'])) {
    $_SESSION['username'] = $_POST['username'];
    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit(); 
    }
    
?>
<!-- - - - - - - - -FUNCTION DEFINITION TO CREATE/ LOAD HTML- - - - - - - - - - - - -->
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

<!-- - - - - - - - -HANDLING ADDITION OF RECORDS- - - - - - - - - - - - -->
<?php
if (array_key_exists('add_records', $_POST)) {
    $conn = new mysqli('localhost', 'mril', 'mril', 'instrument_rentals');

    $add_sql = file_get_contents($sql_location .'add_instruments.sql');
    
    if ($conn->query($add_sql) === FALSE) {
        echo "Error: " . $conn->error;
        exit();

    } else {
        $conn->close();
        header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
        exit();
    }
}
?>

<!-- - - - - - - - -HANDLING DELETION OF RECORDS- - - - - - - - - - - - -->
<?php
if (array_key_exists('delbtn', $_POST)) {
    /*echo "<pre>";
    print_r($_POST);
    echo "</pre>";*/
    $conn = new mysqli('localhost', 'mril', 'mril', 'instrument_rentals');

    $delt_stmt = $conn->prepare(file_get_contents('delete_instrument.sql'));

    foreach ($_POST as $key => $value) {
        if (strpos($key, 'checkbox') === 0) {
            $id = (int)$value;
            $delt_stmt->bind_param('i', $id);
            $delt_stmt->execute();
        }
    }

    $delt_stmt->close();
    $conn->close();

    header("Location: {$_SERVER['REQUEST_URI']}", true, 303);
    exit();
}
?>

<!-- - - - - - - - -LOADING SQL AND CALLING HTML TO EXECUTE- - - - - - - - - - - - -->
<?php
    $conn = new mysqli( 'localhost', 'mril', 'mril', 'instrument_rentals');    // 1
    $sel_tbl = file_get_contents($sql_location . 'select_instruments.sql');         // 2
    $result = $conn->query($sel_tbl);   // 3
    result_to_html_table($result);      // 4
?>

