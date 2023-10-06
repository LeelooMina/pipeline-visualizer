const mongoose = require("mongoose");

const StepSchema = new mongoose.Schema({
  name: String,
  result: String,
  started_on: String,
  duration_seconds: Number,
  completed_on: String,
});

const PipelineSchema = new mongoose.Schema({
  build_number: Number,
  branch_name: String,
  uuid: {
    type: String,
    unique: true,
  },
  status: String,
  duration_seconds: Number,
  build_seconds_used: Number,
  steps: [StepSchema],
  created_on: Date,
  completed_on: Date,
});

const Pipeline = mongoose.model("Pipeline", PipelineSchema);

module.exports = Pipeline;
