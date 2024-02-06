#!/usr/bin/env mongo
mongo = db.getSiblingDB("mongosh");

db.createUser({
  user: "User",
  pwd: "1234",
  roles: [
    {
      role: "readWrite",
      db: "mongo"
    }
  ]
});

print("User create");

mongo.createCollection("loyals_customers","current_customers");

mongo.loyals_customers.insertMany([
    { id: 1, name:"Michelle Laroche",country:"France",mail:"mlaroche@gmail.com",age:56,article:"Freedent-White",price:"2.56",quantity:1,date:"01/03/2022",zone:"Montpellier"},
    { id: 2, name:"Jean-Pierre Fugasse",country:"France",mail:"jpgugu@gmail.com",age:34,article:"Jus de pomme",price:"2.60",quantity:3,date:"03/03/2022",zone:"Paris"},
    { id: 3, name:"Pierre Boulu",country:"Belgique",mail:"pboubou@gmail.com",age:18,article:"Kellogs",price:"5.22",quantity:1,date:"06/01/2022",zone:"Paris"},
    { id: 4, name:"Jacques Martin",country:"France",mail:"jmartin@gmail.com",age:76,article:"Confiture bonne Maman",price:"4.25",quantity:2,date:"04/01/2022",zone:"Nantes"},
    { id: 5, name:"Louise Marie",country:"Suisse",mail:"louisemarie@gmail.com",age:20,article:"Bananes",price:"2.25",quantity:3,date:"03/03/2022",zone:"Nantes"},
]);

mongo.current_customers.insertMany([
    { name:"Sylvia Bron",country:"France",mail:"sbron@gmail.com",article:"Lait",price:"2",quantity:6,date:"04/01/2022",zone:"Paris"},
    { name:"Zelie Pique",country:"France",mail:"zpique@gmail.com",article:"Melon",price:"2.25",quantity:4,date:"01/01/2022",zone:"Paris"},
    { name:"Monique Clide",country:"Londres",mail:"mc@gmail.com",article:"Aspirateur",price:"86.5",quantity:1,date:"01/01/2022",zone:"Paris"},
    { name:"Patrick Fioru",country:"France",mail:"pfior@gmail.com",article:"Lampe",price:"34.2",quantity:1,date:"05/01/2022",zone:"La Rochelle"},
]);

print("Data in loyals_customers:");
myDatabase.loyals_customers.find().forEach(printjson);
print("Data in current_customers:");
myDatabase.currents_customers.find().forEach(printjson);

// Déconnexion de la base de données
db.logout();