// const mongoose = require('mongoose');
// const faker = require('faker');

// // Replace with your MongoDB connection string
// const uri = 'mongodb://localhost:27017/myDatabase';

// mongoose.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true })
//   .then(() => console.log('Connected to MongoDB'))
//   .catch(err => console.error(err));

// const userSchema = new mongoose.Schema({
//   name: String,
//   email: String
// });

// const User = mongoose.model('User', userSchema);

// async function createDummyUsers(numberOfUsers) {
//   for (let i = 0; i < numberOfUsers; i++) {
//     const user = new User({
//       name: faker.name.findName(),
//       email: faker.internet.email()
//     });
//     try {
//       await user.save();
//       console.log(`User ${i + 1} created:`, user);
//     } catch (err) {
//       console.error(err);
//     }
//   }

//   mongoose.connection.close();
// }

// // Change the number to the desired amount of dummy users
// createDummyUsers(10);
