const express = require('express');
const bodyParser = require('body-parser');
const tecRoutes = require("./routers/tecRoutes.js");

const app = express();
const port = 3000;

app.use(bodyParser.json());

app.use(tecRoutes);

app.get("*", async (req, res) => {
  res.json({ message: "404" });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
