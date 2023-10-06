const mongoose = require("mongoose");
const Pipeline = require("../models/pipeline");
const { fetchBitbucketPipelines } = require("./bitbucket");

async function storePipelines(pipelines) {
  for (const pipeline of pipelines) {
    const existingPipeline = await Pipeline.findOne({ uuid: pipeline.uuid });
    if (existingPipeline) {
      // Update the existing pipeline with the new data
      (existingPipeline.build_number = pipeline.build_number),
        (existingPipeline.branch_name = pipeline.branch_name);
      (existingPipeline.uuid = pipeline.uuid),
        (existingPipeline.status = pipeline.status),
        (existingPipeline.duration_seconds = pipeline.duration_seconds),
        (existingPipeline.steps = pipeline.steps),
        (existingPipeline.created_on = pipeline.created_on),
        (existingPipeline.completed_on = pipeline.completed_on);

      await existingPipeline.save();
      // console.log(`Pipeline with UUID ${pipeline.uuid} updated successfully.`);
    } else {
      // Save the new pipeline
      const newPipeline = new Pipeline(pipeline);
      console.log(newPipeline);
      await newPipeline.save();
      // console.log(`Pipeline with UUID ${pipeline.uuid} saved successfully.`);
    }
  }
}

async function fetchDataAndStorePipelines() {
  try {
    const pipelines = await fetchBitbucketPipelines();
    await storePipelines(pipelines);
    console.log("Pipelines saved");
  } catch (error) {
    console.error(`Error fetching and storing pipelines: ${error.message}`);
    console.error(error);
  }
}

module.exports = { storePipelines, fetchDataAndStorePipelines };
