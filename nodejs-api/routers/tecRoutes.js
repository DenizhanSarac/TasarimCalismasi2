const express = require("express");
const router = express.Router();
const tecController = require("../controllers/tecControllers.js");

router.post("/register",tecController.createUser);
router.post("/login",tecController.loginUser);
router.get("/me",tecController.getUser);
router.post("/addts",tecController.tsAdd);
router.get("/getTsList/:username",tecController.getTsList);

module.exports = router;