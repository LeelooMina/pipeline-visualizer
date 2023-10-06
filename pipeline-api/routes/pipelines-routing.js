const express = require("express");
const router = express.Router();
const mongoose = require("mongoose");
const Pipeline = require("../models/pipeline");

router.get("/", async (req, res) => {
  try {
    const pipelinesMain = await Pipeline.find({ branch_name: "main" })
      .sort({ created_on: -1 })
      .limit(1); // Get the most recent pipelines from the 'main' branch
    console.log("pipelinesMain", pipelinesMain); // Log the result

    const pipelinesRecent = await Pipeline.find()
      .sort({ created_on: -1 })
      .limit(3); // Get the 3 most recent pipelines from any branch
    console.log("pipelinesRecent", pipelinesRecent.steps); // Log the result

    const pipelines = [...pipelinesMain, ...pipelinesRecent]; // Merge the two arrays, keeping 'main' branch pipelines at the top

    res.status(200).json(pipelines);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Error fetching pipelines" });
  }
});
module.exports = router;
