<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
session_start();

$uid = "UID";
$secret = "SECRET";
$token_url = "https://api.intra.42.fr/oauth/token";

// Get token
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $token_url);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
    "grant_type" => "client_credentials",
    "client_id" => $uid,
    "client_secret" => $secret,
]));

$response = curl_exec($ch);
if (!$response) {
    die("cURL error: " . curl_error($ch));
}
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

$data = json_decode($response, true);

if ($http_code !== 200 || !isset($data['access_token'])) {
    die("Error getting token: " . json_encode($data));
}

$access_token = $data['access_token'];
$expires_at = time() + $data['expires_in'];

// Fetch Campuses
$api_url = "https://api.intra.42.fr/v2/campus?per_page=100&sort=name";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $api_url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Authorization: Bearer $access_token",
]);

$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($http_code !== 200) {
    die("Error fetching API data: " . json_encode(json_decode($response, true)));
}

$data = json_decode($response, true);

echo "<h1>All Names</h1>";
echo "<ul>";
foreach ($data as $entry) {
    // Check if 'name' exists and display it
    if (isset($entry['name'])) {
        echo "<li>" . htmlspecialchars($entry['name']) . "</li>";
    }
}
echo "</ul>";

// Fetch Events
$api_url = "https://api.intra.42.fr/v2/campus/67/events";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $api_url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Authorization: Bearer $access_token",
]);

$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($http_code !== 200) {
    die("Error fetching API data: " . json_encode(json_decode($response, true)));
}

$data = json_decode($response, true);
echo "<h1>Events</h1>";
echo "<ul>";
foreach ($data as $key => $value) {
    echo "<li><strong>$key:</strong> " . htmlspecialchars(json_encode($value, JSON_PRETTY_PRINT)) . "</li>";
}
echo "</ul>";
?>

