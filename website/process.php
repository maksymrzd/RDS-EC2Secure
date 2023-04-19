<?php
$host = getenv('DB_HOST');
$port = getenv('DB_PORT');
$dbname = getenv('DB_NAME');
$user = getenv('DB_USER');
$password = getenv('DB_PASS');

// Create connection
$conn = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password");

// Check connection
if (!$conn) {
  die("Connection failed: " . pg_last_error());
}

// Create users table if it doesn't exist
$table_sql = "CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL
)";

$table_result = pg_query($conn, $table_sql);

if (!$table_result) {
  die("Error creating table: " . pg_last_error($conn));
}

// Get form data
$email = pg_escape_string($_POST["email"]);
$password = pg_escape_string($_POST["password"]);

// Insert data into database
$sql = "INSERT INTO users (email, password) VALUES ('$email', '$password')";
$result = pg_query($conn, $sql);

if (!$result) {
  die("Error: " . $sql . "<br>" . pg_last_error($conn));
}

// Retrieve all data from users table
$query = "SELECT * FROM users";
$data = pg_query($conn, $query);

if (!$data) {
  die("Error: " . $query . "<br>" . pg_last_error($conn));
}

// Display all data
while ($row = pg_fetch_assoc($data)) {
  echo "ID: " . $row["id"] . "<br>";
  echo "Email: " . $row["email"] . "<br>";
  echo "Password: " . $row["password"] . "<br><br>";
}

// Close connection
pg_close($conn);
?>