const express = require("express");
const router = express.Router();
const tecController = require("../controllers/tecControllers.js");

router.post("/register",tecController.createUser);
router.post("/login",tecController.loginUser);

module.exports = router;