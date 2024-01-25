// Fichier : hello.js

// Importation du module 'http'
const http = require('http');

// Configuration du serveur HTTP
const server = http.createServer((req, res) => {
  // Définition du code de statut de la réponse
  res.statusCode = 200;
  
  // Définition du type de contenu de la réponse
  res.setHeader('Content-Type', 'text/plain');
  
  // Écriture du message "Hello World" dans la réponse
  res.end('Hello World\n');
});

// Écoute du serveur sur le port 3000
const PORT = 3000;
server.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
});

