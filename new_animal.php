<html>
<body>
	<?php
	$host = "db.tecnico.ulisboa.pt";
	$user = "istxxxxxx";
	$pass = "xxxxxxxx";
	$dsn = "mysql:host=$host;dbname=$user";
	try
	{
		$connection = new PDO($dsn, $user, $pass);
	}
	catch(PDOException $exception)
	{
		echo("<p>Error: ");
		echo($exception->getMessage());
		echo("</p>");
		exit();
	}

	$animal_name = $_REQUEST["animal_name"];
	$VAT = $_REQUEST["VAT"];
	$species_name = $_REQUEST["species_name"];
	$colour = $_REQUEST["colour"];
	$gender = $_REQUEST["gender"];
	$birth_year = $_REQUEST["birth_year"];
	
	$stmt1 = $connection->prepare("INSERT INTO animal VALUES (:animal_name, :VAT, :species_name, :colour, :gender, :birth_year, 0)");
	if ($stmt1 == FALSE)
	{
		$info = $connection->errorInfo();				
		echo("<p>Error: {$info[2]}</p>");
		exit();
	}
	$test = $stmt1->execute(array(":animal_name" => $animal_name, 
								  ":VAT" => $VAT,
								  ":species_name" => $species_name,
								  ":colour" => $colour,
								  ":gender" => $gender,
								  ":birth_year" => $birth_year));
	if ($test == FALSE)
	{
		$info = $connection->errorInfo();
		echo("<h3>Animal is already in the Database</h3>");	
		echo("<p></p>");
		echo("<p>Error: {$info[2]}</p>");
		exit();
	}

	$stmt2 = $connection->prepare("SELECT name 
								   FROM person 
								   WHERE VAT = :VAT");
	if ($stmt2 == FALSE)
	{
		$info = $connection->errorInfo();
		echo("<p>Error: {$info[2]}</p>");
		exit();
	}
	$stmt2->execute(array(":VAT" => $VAT));
	foreach($stmt2 as $row)
	{
		$owner_name = $row["name"];
	}

	$connection = null;
	?>
	
	<h2>Animal Successfully Registered</h2>

	<br> </br>

	<form action="check_cenas.php" method="post">
		<h3>See the animal in the database and add new consults</h3>
		<p><input type="hidden" name="VAT_client" value="<?=$VAT?>"/></p>
		<p><input type="hidden" name="animal_name" value="<?=$animal_name?>"/></p>
		<p><input type="hidden" name="owner_name" value="<?=$owner_name?>"/></p>
		<p><input type="submit" value="BACK"/></p>
	</form>
	
	<br> </br>
	<form action="introduce_data.php" method="post">
		<h3>Go back to Homepage</h3>
		<p><input type="submit" value="HOME"/></p>
	</form>
</body>
</html>
