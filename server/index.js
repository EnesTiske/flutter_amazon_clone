const mongoose = require("mongoose");
const express = require("express");
const authRouther = require("./routes/auth");

const app = express();
const port = 3000;

const DB = "mongodb+srv://tiske:tiske357@cluster0.s7g2a.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

app.use(express.json());
app.use(authRouther);

mongoose
  .connect(DB, {})
  .then(() => {
    console.log("Database connected");
  })
  .catch((err) => {
    console.log("Error: ", err);
  });

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
